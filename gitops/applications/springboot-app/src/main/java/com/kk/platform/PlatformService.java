package com.kk.platform;

import io.opentelemetry.api.trace.Span;
import io.opentelemetry.api.trace.Tracer;
import org.springframework.stereotype.Service;

@Service
public class PlatformService {

    private final Tracer tracer;

    public PlatformService(Tracer tracer) {
        this.tracer = tracer;
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
