package com.cafehr.dto;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
// 출근 기록 실제 근무 시간 수정
public class AttendanceUpdateActualHoursDto {

    private Long attendanceId; //출근 기록 ID

    private BigDecimal actualWorkingHours; //실제 근무 시간

}
