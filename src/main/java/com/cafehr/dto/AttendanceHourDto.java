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
public class AttendanceHourDto {

    private Long employeeId; //직원 ID
    private Long attendanceId; //출근 기록 ID
    private String name; //직원 이름
    private LocalDateTime checkIn; //출근 시간
    private LocalDateTime checkOut; //퇴근 시간
    private BigDecimal totalHours; //총 근무 시간

}
