package com.cafehr.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.cafehr.entity.Employee;
import com.cafehr.enums.RoleSt;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
// 직원 목록 조회
public class EmployeeListDto {
    private Long id; //직원 ID
    private String name; //직원 이름
    private BigDecimal hourlyWage; //시급
    private RoleSt role; //직원 역할
    private String employeeCode; //출퇴근용 사원번호
    
    @JsonProperty("isActive")
    private boolean active; //직원 활성화 여부
    
    private String password; //비밀번호
    private String memo; //메모
    private String specialMemo; //특이사항 메모
    private LocalDateTime createdAt; //생성 시간
    private LocalDateTime deletedAt; //삭제 시간

    // Entity를 DTO로 변환하는 생성자
    public EmployeeListDto(Employee employee) {
        this.id = employee.getId();
        this.name = employee.getName();
        this.hourlyWage = employee.getHourlyWage();
        this.role = employee.getRole();
        this.active = employee.isActive();
        this.memo = employee.getMemo();
        this.specialMemo = employee.getSpecialMemo();
        this.createdAt = employee.getCreatedAt();
        this.password = employee.getPassword();
        this.deletedAt = employee.getDeletedAt();
        this.employeeCode = employee.getEmployeeCode();
    }
} 