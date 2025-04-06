package com.cafehr.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.cafehr.entity.Employee;
import com.cafehr.service.EmployeeService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class EmployeeController {

    private final EmployeeService employeeService;
    
    // 직원 목록 페이지
    @GetMapping("/employeelist")
    public String employeeList() {
        return "employeelist";
    }
    
    // 직원 등록 페이지
    @GetMapping("/employeeregistration")
    public String employeeRegistration() {
        return "employeeregistration";
    }
    
    // 직원 수정 페이지
    @GetMapping("/employeeedit/{id}")
    public String employeeEdit(@PathVariable("id") Long id) {
        // 직원 ID를 URL에 포함하고, 클라이언트에서 API를 통해 데이터를 가져오도록 함
        return "employeeedit";
    }

    // 직원 메모
    @GetMapping("/employeememo/{id}")
    public String employeeMemo(@PathVariable("id") Long id) {
        return "employeememo";
    }

} 