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
}