package com.cafehr.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cafehr.dto.WorkScheduleDto;
import com.cafehr.dto.WorkScheduleExpectTotalHoursDto;
import com.cafehr.service.WorkScheduleService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class WorkScheduleController {

    private final WorkScheduleService workScheduleService;

    //직원 근무 일정 등록 (단일등록, 다수등록 둘다가능)
    @PostMapping("/work-schedule")
    public ResponseEntity<?> registerWorkSchedule(@Valid @RequestBody List<WorkScheduleDto> workScheduleDto) {
        List<WorkScheduleDto> workScheduleList = workScheduleService.registerWorkSchedule(workScheduleDto);
        return new ResponseEntity<>(workScheduleList, HttpStatus.CREATED);
    }

    //직원 근무 일정 조회
    @GetMapping("/work-schedule/list/{employeeId}")
    public ResponseEntity<?> getWorkScheduleByEmployeeId(@PathVariable("employeeId") Long employeeId) {
        List<WorkScheduleDto> workScheduleList = workScheduleService.getWorkScheduleByEmployeeId(employeeId);
        return new ResponseEntity<>(workScheduleList, HttpStatus.OK);
    }

    //직원 근무 일정 일괄 삭제 ( 직원 id로 삭제 )
    @DeleteMapping("/work-schedule/delete/{employeeId}")
    public ResponseEntity<?> deleteWorkScheduleByEmployeeId(@PathVariable("employeeId") Long employeeId) {
        workScheduleService.deleteWorkScheduleByEmployeeId(employeeId);
        return new ResponseEntity<>("특정 직원 근무 일정 일괄삭제 완료",HttpStatus.NO_CONTENT);
    }
    
    //직원 근무일정 삭제 ( 근무일정 id로 삭제)
    @DeleteMapping("/work-schedule/delete/id/{id}")
    public ResponseEntity<?> deleteWorkScheduleById(@PathVariable("id") Long id) {
        workScheduleService.deleteWorkScheduleById(id);
        return new ResponseEntity<>("특정 근무일정 삭제 완료",HttpStatus.NO_CONTENT);
    }

    //예상 근무시간 계산
    @GetMapping("/work-schedule/expect-total-hours")
    public ResponseEntity<?> calculateExpectTotalHours() {
        List<WorkScheduleExpectTotalHoursDto> workScheduleExpectTotalHoursDtoList = workScheduleService.calculateExpectTotalHours();
        return new ResponseEntity<>(workScheduleExpectTotalHoursDtoList, HttpStatus.OK);
    }

    
}
