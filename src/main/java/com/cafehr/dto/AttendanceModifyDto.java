package com.cafehr.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
// 출근 기록 수정
public class AttendanceModifyDto {

    private Long attendanceId; //출근 기록 ID
    private LocalDateTime checkIn; //출근 시간
    private LocalDateTime checkOut; //퇴근 시간
    private BigDecimal totalHours; //총 근무 시간
    private BigDecimal actualWorkingHours; //실제 근무 시간
}
