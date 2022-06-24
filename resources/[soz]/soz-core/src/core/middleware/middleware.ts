import { EventMetadata } from '../decorators/event';
import { Inject, Injectable } from '../decorators/injectable';
import { LogMiddlewareFactory } from './log.middleware';
import { MetricMiddlewareFactory } from './metric.middleware';
import { SourceMiddlewareFactory } from './source.middleware';

export type Middleware = (...args: any[]) => void | Promise<void>;

export interface MiddlewareFactory {
    create(event: EventMetadata, next: Middleware): Middleware;
}

@Injectable()
export class ChaineMiddlewareFactory implements MiddlewareFactory {
    @Inject(LogMiddlewareFactory)
    private logMiddlewareFactory: LogMiddlewareFactory;

    @Inject(MetricMiddlewareFactory)
    private metricMiddlewareFactory: MetricMiddlewareFactory;

    @Inject(SourceMiddlewareFactory)
    private sourceMiddlewareFactory: SourceMiddlewareFactory;

    create(eventName: EventMetadata, next: Middleware): Middleware {
        return this.logMiddlewareFactory.create(
            eventName,
            this.metricMiddlewareFactory.create(eventName, this.sourceMiddlewareFactory.create(eventName, next))
        );
    }
}
