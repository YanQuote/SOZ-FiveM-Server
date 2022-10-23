import { OnEvent } from '../../core/decorators/event';
import { Inject } from '../../core/decorators/injectable';
import { Provider } from '../../core/decorators/provider';
import { wait } from '../../core/utils';
import { ClientEvent, ServerEvent } from '../../shared/event';
import { VehicleSpawn } from '../../shared/vehicle';
import { PlayerService } from '../player/player.service';
import { ResourceLoader } from '../resources/resource.loader';
import { VehicleService } from './vehicle.service';

@Provider()
export class VehicleSpawnProvider {
    @Inject(PlayerService)
    private playerService: PlayerService;

    @Inject(ResourceLoader)
    private resourceLoader: ResourceLoader;

    @Inject(VehicleService)
    private vehicleService: VehicleService;

    @OnEvent(ClientEvent.VEHICLE_SPAWN)
    async spawnVehicle(spawnId: string, vehicleSpawn: VehicleSpawn) {
        const player = this.playerService.getPlayer();

        if (!player) {
            return;
        }

        if (!IsModelInCdimage(vehicleSpawn.model) || !IsModelAVehicle(vehicleSpawn.model)) {
            return;
        }

        await this.resourceLoader.loadModel(vehicleSpawn.model);

        const ped = PlayerPedId();
        const vehicle = CreateVehicle(
            vehicleSpawn.model,
            vehicleSpawn.position[0],
            vehicleSpawn.position[1],
            vehicleSpawn.position[2],
            vehicleSpawn.position[3],
            true,
            false
        );

        const networkId = NetworkGetNetworkIdFromEntity(vehicle);

        SetNetworkIdCanMigrate(networkId, true);
        SetEntityAsMissionEntity(vehicle, true, false);
        SetVehicleHasBeenOwnedByPlayer(vehicle, true);
        SetVehicleNeedsToBeHotwired(vehicle, false);
        SetVehRadioStation(vehicle, 'OFF');

        await wait(0);

        console.log(vehicleSpawn.state);
        this.vehicleService.updateVehicleState(vehicle, vehicleSpawn.state);
        console.log(this.vehicleService.getVehicleState(vehicle));

        TriggerServerEvent(ServerEvent.VEHICLE_SPAWNED, spawnId, networkId);

        this.resourceLoader.unloadModel(vehicleSpawn.model);

        if (vehicleSpawn.warp) {
            TaskWarpPedIntoVehicle(ped, vehicle, -1);
        }

        if (vehicleSpawn.modification) {
            this.vehicleService.applyVehicleModification(vehicle, vehicleSpawn.modification);
        }

        this.vehicleService.syncVehicle(vehicle, vehicleSpawn.state);
    }

    @OnEvent(ClientEvent.VEHICLE_DELETE)
    async deleteVehicle(netId: number) {
        const vehicle = NetworkGetEntityFromNetworkId(netId);

        if (DoesEntityExist(vehicle)) {
            SetEntityAsMissionEntity(vehicle, true, true);
            DeleteVehicle(vehicle);

            TriggerServerEvent(ServerEvent.VEHICLE_DELETED, netId);
        }
    }
}
