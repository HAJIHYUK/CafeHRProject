package com.cafehr.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "attendance")
@Getter
@Setter
@NoArgsConstructor
public class Attendance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    //직원 정보
    @ManyToOne
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    //출근 시간
    @Column(name = "check_in", nullable = false)
    private LocalDateTime checkIn;

    //퇴근 시간
    @Column(name = "check_out", nullable = true)
    private LocalDateTime checkOut;

    //수정 여부
    @Column(name = "is_modified", nullable = false)
    private boolean isModified;

    //생성 시간
    @Column(name = "created_at", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;

    //수정 시간
    @Column(name = "updated_at", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedAt;

    // 근무 시간 (자동 계산)
    @Column(name = "total_hours", nullable = true)
    private BigDecimal totalHours;

    // 출근 시간 설정
    public void setCheckIn(LocalDateTime checkIn) {
        this.checkIn = checkIn;
    }

    // 퇴근 시간 설정 시 근무 시간 계산
    public void setCheckOut(LocalDateTime checkOut) {
        this.checkOut = checkOut;
        calculateTotalHours();
    }

    // 퇴근 시간만 설정 (계산 없음)
    public void setCheckOutWithoutCalculation(LocalDateTime checkOut) {
        this.checkOut = checkOut;
    }

    // 근무 시간을 계산하는 메서드
    public void calculateTotalHours() {
        if (checkIn != null && checkOut != null) {
            long minutes = java.time.Duration.between(checkIn, checkOut).toMinutes();
            this.totalHours = BigDecimal.valueOf(minutes).divide(BigDecimal.valueOf(60), 3, BigDecimal.ROUND_HALF_UP);
        } else {
            this.totalHours = BigDecimal.ZERO;
        }
    }
}
