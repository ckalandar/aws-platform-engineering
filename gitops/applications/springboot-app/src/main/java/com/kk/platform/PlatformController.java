package com.kk.platform;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PlatformController {

    private static final Logger log =
            LoggerFactory.getLogger(PlatformController.class);

    @Value("${APP_USERNAME:unknown}")
    private String username;

    @Autowired
    private PlatformService service;

    @GetMapping("/")
    public Map<String, String> home() {

        log.info("Home endpoint called");

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
    public Map<String, String> config() throws Exception {

        service.getConfig();

        return Map.of(
                "username", username,
                "service", "platform-demo");
    }

    @GetMapping("/orders")
    public Map<String, Object> orders() {

        return Map.of(
                "orderId", "ORD-1001",
                "status", "SUCCESS",
                "amount", 2500);
    }

    @GetMapping("/payments")
    public Map<String, Object> payments() {

        return Map.of(
                "paymentId", "PAY-2001",
                "status", "COMPLETED",
                "amount", 2500);
    }
}
