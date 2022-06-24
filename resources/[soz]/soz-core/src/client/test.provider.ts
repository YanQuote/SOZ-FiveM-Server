import { On } from '../core/decorators/event';
import { Inject } from '../core/decorators/injectable';
import { Provider } from '../core/decorators/provider';
import { Tick } from '../core/decorators/tick';
import { Logger } from '../core/logger';

@Provider()
export class TestProvider {
    private counter = 0;

    @Inject(Logger)
    private logger: Logger;

    @Tick(300)
    loop(): boolean {
        emit('soz-core:printCount', this.counter);
        emitNet('soz-core:printCount', this.counter);
        this.counter += 1;

        return this.counter <= 10;
    }

    @On('soz-core:printCount')
    printCount(param): void {
        this.logger.info('client count is', param);
        this.logger.debug('client count is', param);
        this.logger.warn('client count is', param);
        this.logger.error('client count is', param);
    }
}
