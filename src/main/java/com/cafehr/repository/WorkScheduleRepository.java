package com.cafehr.repository;

import java.time.DayOfWeek;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.cafehr.entity.WorkSchedule;

@Repository
public interface WorkScheduleRepository extends JpaRepository<WorkSchedule, Long> {


    // 특정 직원의 근무 일정 조회
    List<WorkSchedule> findByEmployeeId(Long employeeId);


    //특정 직원의 근무 요일로 근무 일정 조회
    List<WorkSchedule> findByEmployeeIdAndWorkDay(Long employeeId, DayOfWeek workDay);

    //특정 직원 근무 일정 일괄 삭제 
    void deleteByEmployeeId(Long employeeId);



}
