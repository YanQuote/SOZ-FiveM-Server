import { TargetFactory } from '../../../client/target/target.factory';
import { OnEvent } from '../../../core/decorators/event';
import { Inject } from '../../../core/decorators/injectable';
import { Provider } from '../../../core/decorators/provider';
import { ServerEvent } from '../../../shared/event';
import { CraftProcess, FfsConfig } from '../../../shared/job/ffs';
import { InventoryManager } from '../../item/inventory.manager';
import { ItemService } from '../../item/item.service';
import { Notifier } from '../../notifier';
import { PlayerService } from '../../player/player.service';
import { ProgressService } from '../../player/progress.service';

@Provider()
export class FightForStyleCraftProvider {
    @Inject(ProgressService)
    private progressService: ProgressService;

    @Inject(TargetFactory)
    private targetFactory: TargetFactory;

    @Inject(InventoryManager)
    private inventoryManager: InventoryManager;

    @Inject(PlayerService)
    private playerService: PlayerService;

    @Inject(Notifier)
    private notifier: Notifier;

    @Inject(ItemService)
    private itemService: ItemService;

    @OnEvent(ServerEvent.FFS_CRAFT)
    public async onCraft(source: number, craftProcess: CraftProcess) {
        if (!this.canCraft(source, craftProcess)) {
            this.notifier.notify(source, `Vous n'avez pas les matériaux nécessaires pour confectionner.`, 'error');
            return;
        }

        this.notifier.notify(source, 'Vous ~g~commencez~s~ à confectionner.', 'success');

        while (this.canCraft(source, craftProcess)) {
            const hasCrafted = await this.doCraft(source, craftProcess);
            const outputItemLabel = this.itemService.getItem(craftProcess.output).label;
            if (hasCrafted) {
                this.notifier.notify(source, `Vous avez confectionné un·e ~g~${outputItemLabel}~s~.`);
            } else {
                this.notifier.notify(source, 'Vous avez ~r~arrêté~s~ de confectionner.');
                return;
            }
        }
        this.notifier.notify(source, `Vous n'avez pas les matériaux nécessaires pour confectionner.`);
    }

    private canCraft(source: number, craftProcess: CraftProcess): boolean {
        for (const input of craftProcess.inputs) {
            const item = this.inventoryManager.getFirstItemInventory(source, input.fabric);
            if (!item || item.amount < input.amount) {
                return false;
            }
        }
        return true;
    }

    private async doCraft(source: number, craftProcess: CraftProcess) {
        const { completed } = await this.progressService.progress(
            source,
            'ffs_craft',
            'Confection en cours',
            FfsConfig.craft.duration,
            {
                name: 'base',
                dictionary: 'amb@prop_human_seat_sewing@female@base',
                flags: 16,
            }
        );

        if (!completed) {
            return false;
        }

        for (const input of craftProcess.inputs) {
            this.inventoryManager.removeItemFromInventory(source, input.fabric, input.amount);
        }
        this.inventoryManager.addItemToInventory(source, craftProcess.output, craftProcess.outputAmount);
        return true;
    }
}
