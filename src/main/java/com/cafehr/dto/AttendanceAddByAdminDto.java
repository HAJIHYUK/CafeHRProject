package com.cafehr.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
// 관리자가 직원 출근 기록 추가
public class AttendanceAddByAdminDto {
    
    @NotNull(message = "직원 ID는 필수입니다")
    private Long employeeId; //직원 번호

    @NotNull(message = "출근 시간은 필수입니다")
    private LocalDateTime checkIn; //출근 시간


    private LocalDateTime checkOut; //퇴근 시간


    private BigDecimal totalHours; //총 근무 시간

    private BigDecimal actualWorkingHours; //실제 근무 시간

}
