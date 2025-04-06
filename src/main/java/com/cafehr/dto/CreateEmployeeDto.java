package com.cafehr.dto;

import java.math.BigDecimal;
import java.util.List;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class CreateEmployeeDto {

    @NotBlank(message = "이름은 필수입니다")
    private String name; //직원 이름

    @NotNull(message = "시급은 필수입니다")
    @Positive(message = "시급은 0보다 커야 합니다")
    private BigDecimal hourlyWage; //시급

    @NotBlank(message = "역할은 필수입니다")
    private String role; //직원 역할

    private String password; //비밀번호

    private String memo; //메모

    private boolean isActive = true; // 기본값을 true로 설정
  
}
