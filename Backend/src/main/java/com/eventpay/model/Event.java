package com.eventpay.model;

import com.eventpay.model.enums.EventStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@NoArgsConstructor
@AllArgsConstructor
public class Event {
    
    private UUID id;
    
    private Organization organization;
    
    private String name;
    
    private Instant startTime;
    
    private Instant endTime;
    
    private String venue;
    
    private BigDecimal defaultMoney;

    private String defaultStudentPasswordHash;
    

    private EventStatus status = EventStatus.DRAFT;
    
    private Instant createdAt;
}
