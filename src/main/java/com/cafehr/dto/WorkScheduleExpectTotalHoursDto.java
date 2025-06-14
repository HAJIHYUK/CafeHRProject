package com.cafehr.dto;

import java.math.BigDecimal;
import java.time.DayOfWeek;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
// 근무 일정 예상 총 근무 시간 조회
public class WorkScheduleExpectTotalHoursDto {


    private Long employeeId;
    private Long attendanceId;
    private DayOfWeek workDay;
    private BigDecimal expectTotalHours;

    

}
