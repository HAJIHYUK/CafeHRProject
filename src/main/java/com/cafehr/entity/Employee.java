package com.cafehr.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.cafehr.enums.RoleSt;
import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "employee")
@Getter
@Setter
@NoArgsConstructor
public class Employee {

    //직원 고유 번호
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    //직원용 사원번호(출퇴근,메모보기)
    @Column(name = "employee_code", nullable = true, unique = true, length = 20)
    private String employeeCode;

    //직원 이름
    @Column(name = "name", nullable = false)
    private String name;

    //시간당 임금
    @Column(name = "hourly_wage", nullable = false)
    private BigDecimal hourlyWage;

    //직원 역할
    @Column(name = "role", nullable = false)
    @Enumerated(EnumType.STRING)
    private RoleSt role;

    //직원 비밀번호 ( 확장성 고려 해서 추가해놓음 )
    @Column(name = "password", nullable = true)
    private String password;

    //직원별 메모
    @Column(name = "memo", nullable = true, length = 2000)
    private String memo;

    //직원별 특이사항 메모
    @Column(name = "special_memo", nullable = true, length = 2000)
    private String specialMemo;


    //활성 상태 (TRUE: 근무 중, FALSE: 퇴사)
    @Column(name = "is_active", nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    @JsonProperty("isActive")
    private boolean active;

    //입사일
    @Column(name = "created_at", nullable = true)
    @CreationTimestamp
    private LocalDateTime createdAt;

    //수정시간
    @Column(name = "updated_at", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedAt;

    //퇴사시간
    @Column(name = "deleted_at", nullable = true)
    private LocalDateTime deletedAt;

}
