package com.cafehr.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cafehr.dto.CreateEmployeeDto;
import com.cafehr.dto.EmployeeListDto;
import com.cafehr.dto.EmployeeMemoDto;
import com.cafehr.entity.Employee;
import com.cafehr.service.EmployeeService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;


@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class EmployeeRestController {

    private final EmployeeService employeeService;
    

    // 사원 등록
    @PostMapping("/employee/registration")
    public ResponseEntity<?> registerEmployee(@Valid @RequestBody CreateEmployeeDto employee) {
        Employee savedEmployee = employeeService.registerEmployee(employee);
        return new ResponseEntity<>(new EmployeeListDto(savedEmployee), HttpStatus.CREATED);
    }

    // 사원 목록 조회
    @GetMapping("/employees")
    public ResponseEntity<List<EmployeeListDto>> getAllEmployees() {
        List<Employee> employees = employeeService.getAllEmployees();
        List<EmployeeListDto> dtos = new ArrayList<>();
        
        for (Employee em : employees) {
            dtos.add(new EmployeeListDto(em));
        }
        
        return new ResponseEntity<>(dtos, HttpStatus.OK);
    }

    // 사원 정보 수정
    @PutMapping("/employees/modify/{id}")
    public ResponseEntity<?> updateEmployee(@PathVariable("id") Long id, @RequestBody Employee dto) {
        Employee updatedEmployee = employeeService.updateEmployee(id, dto);
        return new ResponseEntity<>(updatedEmployee, HttpStatus.OK);
    }

    // 메모 수정 프론트에서 "{"memo":"123"} 형식으로 보내야함  " "
    @PatchMapping("/employees/memo/{id}")
    public ResponseEntity<?> updateMemo(@PathVariable("id") Long id, @RequestBody Map<String, String> memoMap) {
        Employee updatedEmployee = employeeService.updateMemo(id, memoMap.get("memo"));
        return new ResponseEntity<>(updatedEmployee, HttpStatus.OK);
    }
    
    // 직원 단일 조회
    @GetMapping("/employees/{id}")
    public ResponseEntity<?> getEmployeeById(@PathVariable("id") Long id) {
        Employee employee = employeeService.getEmployeeById(id);
        return new ResponseEntity<>(employee, HttpStatus.OK);
    }

    // 직원 메모 조회
    @GetMapping("/employees/memo/{id}")
    public ResponseEntity<?> getEmployeeMemo(@PathVariable("id") Long id) {
        EmployeeMemoDto employeeMemo = employeeService.getEmployeeMemo(id);
        return new ResponseEntity<>(employeeMemo, HttpStatus.OK);
    }

}
