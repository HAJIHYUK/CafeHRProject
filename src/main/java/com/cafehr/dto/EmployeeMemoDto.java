package com.cafehr.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
// 직원 메모 조회
public class EmployeeMemoDto {
    private Long id;
    private String employeeCode;
    private String memo;

    
}
