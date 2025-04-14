package com.cafehr.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.cafehr.entity.Employee;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Long> {
    
    // 직원 이름으로 조회 (정확히 일치)
    Optional<Employee> findByName(String name);
    
    // 이름에 특정 문자열이 포함된 직원 찾기 (부분 일치)
    @Query("SELECT e FROM Employee e WHERE e.name LIKE %:nameContains%")
    List<Employee> findByNameContaining(@Param("nameContains") String nameContains);

    // 전체 직원 조회
    List<Employee> findAll();
    
    // 사원 번호로 직원 1명 조회
    Optional<Employee> findByEmployeeCode(String employeeCode);

    // 활성 상태인 직원 목록 조회 (퇴사하지 않은 직원)
    List<Employee> findByActiveTrue();

    


 
} 