package com.cafehr.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cafehr.dto.AttendanceAddByAdminDto;
import com.cafehr.dto.AttendanceHourDto;
import com.cafehr.dto.AttendanceModifyDto;
import com.cafehr.dto.AttendanceUpdateActualHoursDto;
import com.cafehr.service.AttendanceService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class AttendanceRestController {

    private final AttendanceService attendanceService;


    // 사원 번호 입력시 출근 기록 생성
    @PostMapping("/attendance/check-in/{employeeCode}")
    public ResponseEntity<?> checkIn(@PathVariable("employeeCode") String employeeCode) {
        try {
            AttendanceHourDto attendanceHourDto = attendanceService.recordAttendance(employeeCode);
            return new ResponseEntity<>(attendanceHourDto, HttpStatus.OK);
        } catch (IllegalArgumentException | IllegalStateException e) {
            // 오류 메시지를 JSON 형식으로 반환 (message 속성 사용)
            return new ResponseEntity<>(
                Map.of("message", e.getMessage()), 
                HttpStatus.BAD_REQUEST
            );
        }
    }


    // 관리자가 임의로 만드는 출근 기록 생성
    @PostMapping("/attendance/check-in/admin")
    public ResponseEntity<?> checkInByAdmin(@Valid @RequestBody AttendanceAddByAdminDto attendanceAddByAdminDto) {
        AttendanceHourDto attendanceHourDto = attendanceService.recordAttendanceByAdmin(attendanceAddByAdminDto);
        return new ResponseEntity<>(attendanceHourDto,HttpStatus.OK);
    }

    // 관리자가 임의로 만드는 출근 기록 다중 생성
    @PostMapping("/attendance/check-in/admin/multiple")
    public ResponseEntity<?> checkInByAdminMultiple(@Valid @RequestBody List<AttendanceAddByAdminDto> attendanceList) {
        List<AttendanceHourDto> results = attendanceService.recordAttendanceByAdminMultiple(attendanceList);
        return new ResponseEntity<>(results, HttpStatus.OK);
    }

    // 사원 번호 입력시 퇴근 기록 생성
    @PutMapping("/attendance/check-out/{employeeCode}")
    public ResponseEntity<?> checkOut(@PathVariable("employeeCode") String employeeCode) {
        try {
            AttendanceHourDto attendanceHourDto = attendanceService.recordCheckOut(employeeCode);
            return new ResponseEntity<>(attendanceHourDto, HttpStatus.OK);
        } catch (IllegalArgumentException | IllegalStateException e) {
            // 오류 메시지를 JSON 형식으로 반환 (message 속성 사용)
            return new ResponseEntity<>(
                Map.of("message", e.getMessage()), 
                HttpStatus.BAD_REQUEST
            );
        }
    }

    // 전체 직원 출근 기록 조회
    @GetMapping("/attendance")
    public ResponseEntity<?> getAllAttendance() {
        List<AttendanceHourDto> attendanceList = attendanceService.getAllAttendance();
        return new ResponseEntity<>(attendanceList, HttpStatus.OK);
    }

    // 전체 직원 출근 기록 조회( 날짜 범위 )
    @GetMapping("/attendance/date-range/{startDate}/{endDate}")
    public ResponseEntity<?> getAllAttendanceByDateRange(@PathVariable("startDate") LocalDateTime startDate, @PathVariable("endDate") LocalDateTime endDate) {
        List<AttendanceHourDto> attendanceList = attendanceService.getAttendanceByDateRange(startDate, endDate);
        return new ResponseEntity<>(attendanceList, HttpStatus.OK);
    }

    // 특정 직원 출근 기록 조회( 사원번호 )
    @GetMapping("/attendance/{employeeId}")
    public ResponseEntity<?> getAttendanceByEmployeeId(@PathVariable("employeeId") Long employeeId) {
        List<AttendanceHourDto> attendanceList = attendanceService.getAttendanceByEmployeeId(employeeId);
        return new ResponseEntity<>(attendanceList, HttpStatus.OK);
    }
    
    //특정 직원 출근 기록 조회( 날짜 범위 )
    @GetMapping("/attendance/{employeeId}/{startDate}/{endDate}")
    public ResponseEntity<?> getAttendanceByEmployeeIdAndDateRange(@PathVariable("employeeId") Long employeeId, @PathVariable("startDate") LocalDateTime startDate, @PathVariable("endDate") LocalDateTime endDate) {
        List<AttendanceHourDto> attendanceList = attendanceService.getAttendanceByEmployeeIdAndDateRange(employeeId, startDate, endDate);
        return new ResponseEntity<>(attendanceList, HttpStatus.OK);
    }

    //특정 직원 이름 부분 검색으로 출근 기록 조회 (부분 일치)
    @GetMapping("/attendance/name-containing/{nameContains}")
    public ResponseEntity<?> getAttendanceByNameContaining(@PathVariable("nameContains") String nameContains) {
        List<AttendanceHourDto> attendanceList = attendanceService.getAttendanceByNameContaining(nameContains);
        return new ResponseEntity<>(attendanceList, HttpStatus.OK);
    }
    
    //특정 직원 이름 부분 검색으로 특정 기간 출근 기록 조회 (부분 일치)
    @GetMapping("/attendance/name-containing/{nameContains}/{startDate}/{endDate}")
    public ResponseEntity<?> getAttendanceByNameContainingAndDateRange(
            @PathVariable("nameContains") String nameContains, 
            @PathVariable("startDate") LocalDateTime startDate, 
            @PathVariable("endDate") LocalDateTime endDate) {
        List<AttendanceHourDto> attendanceList = attendanceService.getAttendanceByNameContainingAndDateRange(nameContains, startDate, endDate);
        return new ResponseEntity<>(attendanceList, HttpStatus.OK);
    }

    // 출근 기록 수정
    @PutMapping("/attendance/modify/{attendanceId}")
    public ResponseEntity<?> updateAttendance(@PathVariable("attendanceId") Long attendanceId, @RequestBody AttendanceModifyDto attendanceHourDto) {
        AttendanceHourDto updatedAttendance = attendanceService.updateAttendance(attendanceId, attendanceHourDto);
        return new ResponseEntity<>(updatedAttendance, HttpStatus.OK);
    }

    // 출근 기록 삭제 (true 반환)
    @DeleteMapping("/attendance/delete/{attendanceId}")
    public ResponseEntity<?> deleteAttendance(@PathVariable("attendanceId") Long attendanceId) {
        attendanceService.deleteAttendance(attendanceId);
        return new ResponseEntity<>(String.format("출근 기록 ID %d 삭제 완료", attendanceId), HttpStatus.OK);
    }


    // 선택된 함옥 근무시간 변경 (다중,단일)
    @PutMapping("/attendance/update-actual-working-hours")
    public ResponseEntity<?> updateActualWorkingHours(@RequestBody List<AttendanceUpdateActualHoursDto> attendanceUpdateActualHoursDtoList) {
        attendanceService.updateActualWorkingHours(attendanceUpdateActualHoursDtoList);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}
