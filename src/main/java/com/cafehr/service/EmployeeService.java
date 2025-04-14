package com.cafehr.service;
//직원 관리, 등록, 퇴사 처리 등

import java.time.LocalDateTime;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cafehr.dto.CreateEmployeeDto;
import com.cafehr.dto.EmployeeMemoDto;
import com.cafehr.entity.Employee;
import com.cafehr.enums.RoleSt;
import com.cafehr.repository.EmployeeRepository;

import lombok.RequiredArgsConstructor;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class EmployeeService {

    private final EmployeeRepository employeeRepository;
    private static final Logger log = LoggerFactory.getLogger(EmployeeService.class);

    //직원 등록
    @Transactional
    public Employee registerEmployee(CreateEmployeeDto employee) {
        // 입력값 로깅
        log.info("Received DTO - name: {}, isActive: {}, role: {}", 
            employee.getName(), employee.isActive(), employee.getRole());

        // CreateEmployeeDto 객체를 Employee 객체로 변환
        Employee newEmployee = new Employee();
        newEmployee.setName(employee.getName());
        newEmployee.setHourlyWage(employee.getHourlyWage());
        newEmployee.setRole(RoleSt.valueOf(employee.getRole().toUpperCase()));
        newEmployee.setPassword(employee.getPassword());
        newEmployee.setMemo(employee.getMemo());
        newEmployee.setActive(employee.isActive());

        // 디버깅을 위한 로그 추가
        log.info("Creating employee with isActive: {}", employee.isActive());
        
        return employeeRepository.save(newEmployee);
    }

    // 전체 직원 목록 조회
    public List<Employee> getAllEmployees() {
        return employeeRepository.findAll();
    }

    //직원 수정
    @Transactional
    public Employee updateEmployee(Long id, Employee updatedEmployee) {
        log.info("Updating employee with ID: {}", id);
        
        Employee existingEmployee = employeeRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다. ID: " + id));
        
        // 사원번호 중복 체크
        if (updatedEmployee.getEmployeeCode() != null) {
            // 모든 직원을 조회하여 사원번호 중복 체크
            List<Employee> allEmployees = employeeRepository.findAll();
            for (Employee employee : allEmployees) {
                // 자기 자신은 제외하고 체크
                if (!employee.getId().equals(id) && 
                    updatedEmployee.getEmployeeCode().equals(employee.getEmployeeCode())) {
                    throw new IllegalArgumentException("중복된 출퇴근용 사번이 있습니다. 출퇴근용 사번은 중복이 안됩니다.");
                }
            }
        }
        
        // 메모만 업데이트하는 경우 (다른 필드가 null인 경우)
        if (updatedEmployee.getMemo() != null && 
            updatedEmployee.getName() == null && 
            updatedEmployee.getHourlyWage() == null && 
            updatedEmployee.getRole() == null) {
            
            log.info("Updating only memo for employee ID: {}", id);
            existingEmployee.setMemo(updatedEmployee.getMemo());
            return employeeRepository.save(existingEmployee);
        }
        
        // 전체 필드 업데이트
        if (updatedEmployee.getName() != null) {
            existingEmployee.setName(updatedEmployee.getName());
        }
        
        if (updatedEmployee.getEmployeeCode() != null) {
            existingEmployee.setEmployeeCode(updatedEmployee.getEmployeeCode());
        }

        if (updatedEmployee.getHourlyWage() != null) {
            existingEmployee.setHourlyWage(updatedEmployee.getHourlyWage());
        }
        
        if (updatedEmployee.getRole() != null) {
            existingEmployee.setRole(updatedEmployee.getRole());
        }
        
        if (updatedEmployee.getMemo() != null) {
            existingEmployee.setMemo(updatedEmployee.getMemo());
        }
        
        // 비밀번호 업데이트 (null인 경우 무시)
        if (updatedEmployee.getPassword() != null) {
            existingEmployee.setPassword(updatedEmployee.getPassword());
        }

        // 특이사항 메모 업데이트
        if (updatedEmployee.getSpecialMemo() != null) {
            existingEmployee.setSpecialMemo(updatedEmployee.getSpecialMemo());
        }
        
        // 활성 상태 체크 및 퇴사일 설정
        Boolean isActiveUpdated = updatedEmployee.isActive();

        if (isActiveUpdated != null) {
            // 활성 -> 비활성 변경 (퇴사 처리)
            if (existingEmployee.isActive() && !isActiveUpdated) {
                existingEmployee.setDeletedAt(LocalDateTime.now());
                existingEmployee.setEmployeeCode(null); //퇴사시 사원번호 null로 초기화 
                log.info("Employee {} is now inactive. Setting deleted_at to current time.", id);
            } 
            // 비활성 -> 활성 변경 (복직 처리)
            else if (!existingEmployee.isActive() && isActiveUpdated) {
                existingEmployee.setDeletedAt(null);
                log.info("Employee {} is now active. Removing deleted_at.", id);
            }
            
            existingEmployee.setActive(isActiveUpdated);
        }
        
        log.info("Employee updated: {}", existingEmployee);
        return employeeRepository.save(existingEmployee);
    }


    //직원 id로 메모 조회
    public EmployeeMemoDto getEmployeeMemo(String employeeCode) {
        Employee employee = employeeRepository.findByEmployeeCode(employeeCode)
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다. 사원번호: " + employeeCode));
            
        if (!employee.isActive()) {
            throw new IllegalArgumentException("퇴직한 직원입니다. 사원번호: " + employeeCode);
        }
            
        return new EmployeeMemoDto(employee.getId(), employee.getEmployeeCode(), employee.getMemo());
    }


    // 메모 수정
    @Transactional
    public Employee updateMemo(Long id, String memo) {
        Employee employee = employeeRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다."));
        
        employee.setMemo(memo);
        return employeeRepository.save(employee);
    }

    // 특이사항 메모 수정
    @Transactional
    public Employee updateSpecialMemo(Long id, String specialMemo) {
        Employee employee = employeeRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다."));
        
        employee.setSpecialMemo(specialMemo);
        return employeeRepository.save(employee);
    }

    // 직원 ID로 조회
    public Employee getEmployeeById(Long id) {
        return employeeRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다. ID: " + id));
    }

}
