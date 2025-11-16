package com.eventpay.model;

import com.eventpay.model.enums.OrganizationStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.Instant;
import java.util.UUID;


@NoArgsConstructor
@AllArgsConstructor
public class Organization {
    

    private UUID id;
    
    private String name;
    
    private String email;
    
    private String passwordHash;
    

    private String contactPerson;

    private String phone;
    
    private String address;
    

    private OrganizationStatus status = OrganizationStatus.ACTIVE;
    
    private Instant createdAt;
}
