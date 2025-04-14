package com.cafehr.dto;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 급여 정보 간소화된 DTO
 * 직원 ID와 최종 급여 정보만 포함
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SalarySimpleDto {
    
    private Long employeeId;
    private BigDecimal totalSalary;
    
    // 직원 이름 필드 추가 (선택적)
    private String employeeName;
    
    // 직원 ID와 총 급여만 받는 생성자
    public SalarySimpleDto(Long employeeId, BigDecimal totalSalary) {
        this.employeeId = employeeId;
        this.totalSalary = totalSalary;
    }
} 