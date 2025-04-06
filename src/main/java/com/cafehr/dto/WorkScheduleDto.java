package com.cafehr.dto;

import java.time.DayOfWeek;
import java.time.LocalTime;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class WorkScheduleDto {
    
    // 근무 일정 ID 
    private Long id;

    // 직원 ID
    @NotNull(message = "직원 ID는 필수입니다")
    private Long employeeId;

    // 근무 요일
    @NotNull(message = "근무 요일은 필수입니다")
    private DayOfWeek workDay;

    // 근무 시작 시간
    @NotNull(message = "시작 시간은 필수입니다")
    private LocalTime startTime;

    // 근무 종료 시간
    @NotNull(message = "종료 시간은 필수입니다")
    private LocalTime endTime;

    
}
