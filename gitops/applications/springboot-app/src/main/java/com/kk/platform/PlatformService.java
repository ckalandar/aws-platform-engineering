package com.kk.platform;

import io.opentelemetry.instrumentation.annotations.WithSpan;
import org.springframework.stereotype.Service;

@Service
public class PlatformService {

    @WithSpan("config-read")
    public String getConfig() throws Exception {

        Thread.sleep(100);

        return "success";
    }
}
