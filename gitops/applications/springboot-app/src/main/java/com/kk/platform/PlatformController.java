package com.kk.platform;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PlatformController {

    @Value("${APP_USERNAME:unknown}")
    private String username;

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
                "version", "v3",
                "service", "platform-demo");
    }

    @GetMapping("/config")
    public Map<String, String> config() {

    return Map.of(
            "username", System.getenv("APP_USERNAME"),
            "service", "platform-demo");
    }
}
