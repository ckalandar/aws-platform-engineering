package com.kk.platform;

import io.opentelemetry.api.OpenTelemetry;
import io.opentelemetry.api.trace.Span;
import io.opentelemetry.api.trace.Tracer;
import org.springframework.stereotype.Service;

@Service
public class PlatformService {

    private final Tracer tracer;

    public PlatformService(OpenTelemetry openTelemetry) {
        this.tracer = openTelemetry.getTracer("platform-demo");
    }

    public String getConfig() throws Exception {

        Span span = tracer
                .spanBuilder("config-read")
                .startSpan();

        try {
            Thread.sleep(100);
            return "success";
        } finally {
            span.end();
        }
    }
}
