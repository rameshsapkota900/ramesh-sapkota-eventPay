package com.eventpay.model;

import com.eventpay.model.enums.UserRole;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.Instant;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    
    private UUID id;
    
    private Organization organization;
    
    private UserRole role;
    
    private String name;
    
    private String phone;
    
    private String email;
    
    private String passwordHash;
    
    private Boolean active = true;
    
    private String school;
    
    private Boolean visitedBefore;
    
    private Instant registrationTime;
    

    private Event event;
    
    private Instant createdAt;
}