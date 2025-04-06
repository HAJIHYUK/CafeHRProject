package com.cafehr.service;
//급여 관리, 급여 계산, 급여 조회 등

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cafehr.dto.SalaryCalculationDto;
import com.cafehr.entity.Attendance;
import com.cafehr.entity.Employee;
import com.cafehr.entity.Salary;
import com.cafehr.repository.AttendanceRepository;
import com.cafehr.repository.EmployeeRepository;
import com.cafehr.repository.SalaryRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SalaryService {

    private final SalaryRepository salaryRepository;
    private final EmployeeRepository employeeRepository;
    private final AttendanceRepository attendanceRepository;
    
    /**
     * 특정 직원의 특정 월에 대한 급여를 계산합니다.
     * 
     * @param salaryCalculationDto 계산할 직원ID와 월 정보
     * @return 계산된 급여 정보
     */
    @Transactional
    public Salary calculateSalary(SalaryCalculationDto salaryCalculationDto) {
        Long employeeId = salaryCalculationDto.getEmployeeId();
        String month = salaryCalculationDto.getMonth();
        
        // 1. 직원 정보 조회
        Employee employee = employeeRepository.findById(employeeId)
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다."));
            
        // 2. 기존 급여 기록 확인 
        Salary existingSalary = salaryRepository.findByEmployeeIdAndMonth(employeeId, month);
        
        // 3. 해당 월의 기간 설정
        YearMonth yearMonth = YearMonth.parse(month, DateTimeFormatter.ofPattern("yyyy-MM"));
        LocalDateTime startOfMonth = yearMonth.atDay(1).atStartOfDay();
        LocalDateTime endOfMonth = yearMonth.atEndOfMonth().atTime(23, 59, 59);
        
        // 4. 해당 월의 출퇴근 기록 조회
        List<Attendance> attendances = attendanceRepository.findAllByEmployeeIdAndCheckInBetween(
            employeeId, startOfMonth, endOfMonth);
        
        // 5. 총 근무 시간 계산
        BigDecimal totalHours = BigDecimal.ZERO;
        for (Attendance attendance : attendances) {
            if (attendance.getTotalHours() != null) {
                totalHours = totalHours.add(attendance.getTotalHours());
            }
        }
        
        // 6. 주별 근무 시간 계산 (주휴수당 계산을 위해)
        Map<Integer, BigDecimal> weeklyHours = calculateWeeklyHours(attendances, yearMonth);
        
        // 7. 주휴수당 계산
        BigDecimal holidayBonus = calculateHolidayBonus(weeklyHours, employee.getHourlyWage());
        
        // 8. 급여 계산
        BigDecimal baseSalary = totalHours.multiply(employee.getHourlyWage()).setScale(0, RoundingMode.HALF_UP);
        holidayBonus = holidayBonus.setScale(0, RoundingMode.HALF_UP);
        BigDecimal totalSalary = baseSalary.add(holidayBonus);
        
        // 9. 급여 정보 저장 (기존 기록이 있으면 업데이트, 없으면 새로 생성)
        if (existingSalary == null) {
            existingSalary = new Salary();
            existingSalary.setEmployee(employee);
            existingSalary.setMonth(month);
        }

        // 급여 정보 업데이트
        existingSalary.setTotalHours(totalHours);
        existingSalary.setBaseSalary(baseSalary);
        existingSalary.setHolidayBonus(holidayBonus);
        existingSalary.setTotalSalary(totalSalary);

        return salaryRepository.save(existingSalary);
    }
    
    /**
     * 주별 근무 시간을 계산합니다.
     */
    private Map<Integer, BigDecimal> calculateWeeklyHours(List<Attendance> attendances, YearMonth yearMonth) {
        Map<Integer, BigDecimal> weeklyHours = new HashMap<>();
        
        for (Attendance attendance : attendances) {
            if (attendance.getCheckIn() != null) {
                LocalDate date = attendance.getCheckIn().toLocalDate();
                
                // 해당 월에 속하는지 확인
                if (date.getYear() == yearMonth.getYear() && date.getMonthValue() == yearMonth.getMonthValue()) {
                    // 주차 계산 (1부터 시작)
                    int weekOfMonth = (date.getDayOfMonth() - 1) / 7 + 1;
                    
                    // 근무 시간 추가
                    BigDecimal hours = attendance.getTotalHours() != null ? 
                        attendance.getTotalHours() : BigDecimal.ZERO;
                    
                    BigDecimal existingHours = weeklyHours.getOrDefault(weekOfMonth, BigDecimal.ZERO);
                    weeklyHours.put(weekOfMonth, existingHours.add(hours));
                }
            }
        }
        
        return weeklyHours;
    }
    
    /**
     * 주휴수당을 계산합니다.
     */
    private BigDecimal calculateHolidayBonus(Map<Integer, BigDecimal> weeklyHours, BigDecimal hourlyWage) {
        BigDecimal totalHolidayBonus = BigDecimal.ZERO;
        
        for (Map.Entry<Integer, BigDecimal> entry : weeklyHours.entrySet()) {
            BigDecimal weekHours = entry.getValue();
            
            // 주 15시간 이상 근무한 경우에만 주휴수당 지급
            if (weekHours.compareTo(new BigDecimal("15")) >= 0) {
                // 주 40시간 미만 근무자의 주휴수당 계산식: (주 소정근로시간 × 8 ÷ 40 × 시급)
                BigDecimal holidayHours = weekHours.multiply(new BigDecimal("8"))
                    .divide(new BigDecimal("40"), 2, RoundingMode.HALF_UP);
                
                // 주휴수당 = 주휴시간 * 시급
                BigDecimal weeklyBonus = holidayHours.multiply(hourlyWage);
                totalHolidayBonus = totalHolidayBonus.add(weeklyBonus);
            }
        }
        
        return totalHolidayBonus;
    }
    
    /**
     * 특정 월의 모든 급여 정보를 조회합니다.
     */
    @Transactional(readOnly = true)
    public List<Salary> getAllSalariesByMonth(String month) {
        return salaryRepository.findByMonth(month);
    }
    
    /**
     * 특정 직원의 급여 이력을 조회합니다.
     */
    @Transactional(readOnly = true)
    public List<Salary> getEmployeeSalaryHistory(Long employeeId) {
        return salaryRepository.findByEmployeeId(employeeId);
    }
    
    /**
     * 특정 직원의 특정 월 급여를 조회합니다.
     */
    @Transactional(readOnly = true)
    public Salary getSalaryByEmployeeAndMonth(SalaryCalculationDto searchDto) {
        Long employeeId = searchDto.getEmployeeId();
        String month = searchDto.getMonth();
        return salaryRepository.findByEmployeeIdAndMonth(employeeId, month);
    }

    // 특정 월의 모든 직원 급여 합계 조회
    @Transactional(readOnly = true)
    public BigDecimal getTotalSalaryByMonth(String month) {
        return salaryRepository.getTotalSalaryByMonth(month);
    }


}
