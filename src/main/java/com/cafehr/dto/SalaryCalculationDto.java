package com.cafehr.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SalaryCalculationDto {
    private Long employeeId; // 직원 ID
    private String month; // yyyy-MM 형식(예: 2023-05)
} 