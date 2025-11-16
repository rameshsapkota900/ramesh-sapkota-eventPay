package com.eventpay;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class EventPayApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(EventPayApplication.class, args);
    }
}
