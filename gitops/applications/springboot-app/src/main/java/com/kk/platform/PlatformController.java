package com.kk.platform;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PlatformController {

    @GetMapping("/")
    public Map<String, String> home() {

        return Map.of(
                "service", "platform-demo",
                "environment", "dev",
                "status", "healthy");
    }

    @GetMapping("/health")
    public Map<String, String> health() {

        return Map.of(
                "service", "platform-demo",
                "environment", "dev",
                "status", "healthy");
    }

    @GetMapping("/version")
    public Map<String, String> version() {

        return Map.of(
                "version", "v2",
                "service", "platform-demo");
    }
}
