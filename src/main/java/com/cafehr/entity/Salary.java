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
@Table(name = "salary")
@Getter
@Setter
@NoArgsConstructor
public class Salary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // 월급 ID

    @ManyToOne
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee; // 직원 ID (연결)

    @Column(name = "month", nullable = false, length = 7)
    private String month; // yyyy-MM (2025-03)

    @Column(name = "total_hours", nullable = false, precision = 5, scale = 2)
    private BigDecimal totalHours; // 총 근무 시간

    @Column(name = "base_salary", nullable = false, precision = 10, scale = 2)
    private BigDecimal baseSalary; // 기본 월급 (시급 * 근무시간)

    @Column(name = "holiday_bonus", nullable = false, precision = 10, scale = 2)
    private BigDecimal holidayBonus; // 주휴수당

    @Column(name = "total_salary", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalSalary; // 최종 월급

    @Column(name = "created_at", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedAt;
}
