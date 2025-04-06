package com.cafehr.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.cafehr.entity.Attendance;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, Long> {
    
    /**
     * 특정 직원의 출근 기록 존재 여부를 확인합니다.
     * 
     * @param employeeId 직원 ID
     * @param startOfDay 오늘 시작 시간
     * @param endOfDay 오늘 종료 시간
     * @return 출근 기록 존재 여부
     */
    boolean existsByEmployeeIdAndCheckInBetween(Long employeeId, LocalDateTime startOfDay, LocalDateTime endOfDay);

    /**
     * 특정 직원의 퇴근 기록 존재 여부를 확인합니다.
     * 
     * @param employeeId 직원 ID
     * @param startOfDay 오늘 시작 시간
     * @param endOfDay 오늘 종료 시간
     * @return 퇴근 기록 존재 여부
     */
    boolean existsByEmployeeIdAndCheckOutBetween(Long employeeId, LocalDateTime startOfDay, LocalDateTime endOfDay);

    /**
     * 특정 직원의 주어진 시간 범위 내 출근 기록을 조회합니다.
     * 
     * @param employeeId 직원 ID
     * @param startOfDay 시작 시간
     * @param endOfDay 종료 시간
     * @return 출근 기록 (Optional)
     */
    Optional<Attendance> findByEmployeeIdAndCheckInBetween(Long employeeId, LocalDateTime startOfDay, LocalDateTime endOfDay);

    /**
     * 특정 직원의 모든 출근 기록을 조회합니다.
     * 
     * @param employeeId 직원 ID
     * @return 출근 기록 목록
     */
    List<Attendance> findByEmployeeId(Long employeeId);

    /**
     * 특정 직원의 특정 기간 출근 기록을 조회합니다.
     * 
     * @param employeeId 직원 ID
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @return 출근 기록 목록
     */
    List<Attendance> findAllByEmployeeIdAndCheckInBetween(Long employeeId, LocalDateTime startDate, LocalDateTime endDate);

    //직원 이름으로 출근 기록 검색 (부분 일치)
    List<Attendance> findByEmployee_NameContaining(String name);

    //직원 이름과 날짜 범위로 출근 기록 검색 (부분 일치)
    List<Attendance> findByEmployee_NameContainingAndCheckInBetween(String name, LocalDateTime startDate, LocalDateTime endDate);

    // 전체 직원 출근 기록조회 ( 날짜 지정 )
    List<Attendance> findAllByCheckInBetween(LocalDateTime startDate, LocalDateTime endDate);
} 