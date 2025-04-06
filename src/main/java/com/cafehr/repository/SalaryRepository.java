package com.cafehr.repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.cafehr.entity.Employee;
import com.cafehr.entity.Salary;

@Repository
public interface SalaryRepository extends JpaRepository<Salary, Long> {
    
    /**
     * 특정 직원의 특정 월 급여 정보를 조회합니다.
     */
    @Query("SELECT s FROM Salary s WHERE s.employee.id = :employeeId AND s.month = :month")
    Salary findByEmployeeIdAndMonth(@Param("employeeId") Long employeeId, @Param("month") String month);
    
    /**
     * 특정 월의 모든 급여 정보를 조회합니다.
     */
    List<Salary> findByMonth(String month);
    
    /**
     * 특정 직원의 모든 급여 이력을 조회합니다.
     */
    @Query("SELECT s FROM Salary s WHERE s.employee.id = :employeeId ORDER BY s.month DESC")
    List<Salary> findByEmployeeId(@Param("employeeId") Long employeeId);
    
    // 특정 직원의 특정 월 급여 조회
    Optional<Salary> findByEmployeeAndMonth(Employee employee, String month);
    
    @Query("SELECT SUM(s.totalSalary) FROM Salary s WHERE s.month = :month")
    BigDecimal getTotalSalaryByMonth(@Param("month") String month);
    
} 