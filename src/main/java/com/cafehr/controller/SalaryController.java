package com.cafehr.controller;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cafehr.dto.SalaryCalculationDto;
import com.cafehr.entity.Salary;
import com.cafehr.service.SalaryService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/salary")
@RequiredArgsConstructor
public class SalaryController {

    private final SalaryService salaryService;
    
    // 특정 직원의 월급 계산
    @PostMapping("/calculate")
    public ResponseEntity<?> calculateSalary(@RequestBody SalaryCalculationDto calculationDto) {
        Salary salary = salaryService.calculateSalary(calculationDto);
        return new ResponseEntity<>(salary, HttpStatus.OK);
    }
    
    // 특정 월의 모든 직원 급여 조회
    @GetMapping("/month/{month}")
    public ResponseEntity<?> getSalariesByMonth(@PathVariable("month") String month) {
        List<Salary> salaries = salaryService.getAllSalariesByMonth(month);
        return new ResponseEntity<>(salaries, HttpStatus.OK);
    }
    
    // 특정 직원의 급여 이력 조회
    @GetMapping("/employee/{employeeId}")
    public ResponseEntity<?> getEmployeeSalaryHistory(@PathVariable("employeeId") Long employeeId) {
        List<Salary> salaryHistory = salaryService.getEmployeeSalaryHistory(employeeId);
        return new ResponseEntity<>(salaryHistory, HttpStatus.OK);
    }
    
    // 특정 직원의 특정 월 급여 조회
    @PostMapping("/search")
    public ResponseEntity<?> getSalaryByEmployeeAndMonth(@RequestBody SalaryCalculationDto searchDto) {
        Salary salary = salaryService.getSalaryByEmployeeAndMonth(searchDto);
        if (salary == null) {
            return ResponseEntity.notFound().build();
        }
        return new ResponseEntity<>(salary, HttpStatus.OK);
    }
    

    //특정 월의 모든 직원 급여 합계 조회
    @GetMapping("/total/{month}")
    public ResponseEntity<BigDecimal> getTotalSalaryByMonth(@PathVariable("month") String month) {
        BigDecimal totalSalary = salaryService.getTotalSalaryByMonth(month);
        return ResponseEntity.ok(totalSalary);
    }



} 