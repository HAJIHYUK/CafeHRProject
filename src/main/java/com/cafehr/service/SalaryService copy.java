// package com.cafehr.service;
// //급여 관리, 급여 계산, 급여 조회 등

// import java.math.BigDecimal;
// import java.math.RoundingMode;
// import java.time.LocalDate;
// import java.time.LocalDateTime;
// import java.time.LocalTime;
// import java.time.YearMonth;
// import java.time.format.DateTimeFormatter;
// import java.time.DayOfWeek;
// import java.util.HashMap;
// import java.util.List;
// import java.util.Map;
// import java.util.ArrayList;

// import org.springframework.stereotype.Service;
// import org.springframework.transaction.annotation.Transactional;

// import com.cafehr.dto.SalaryCalculationDto;
// import com.cafehr.entity.Attendance;
// import com.cafehr.entity.Employee;
// import com.cafehr.entity.Salary;
// import com.cafehr.entity.WorkSchedule;
// import com.cafehr.repository.AttendanceRepository;
// import com.cafehr.repository.EmployeeRepository;
// import com.cafehr.repository.SalaryRepository;
// import com.cafehr.repository.WorkScheduleRepository;

// import lombok.RequiredArgsConstructor;

// @Service
// @RequiredArgsConstructor
// public class SalaryService {

//     private final SalaryRepository salaryRepository;
//     private final EmployeeRepository employeeRepository;
//     private final AttendanceRepository attendanceRepository;
//     private final WorkScheduleRepository workScheduleRepository;
    
//     /**
//      * 특정 직원의 특정 월에 대한 급여를 계산합니다.
//      * 
//      * @param salaryCalculationDto 계산할 직원ID와 월 정보
//      * @return 계산된 급여 정보
//      */
//     @Transactional
//     public Salary calculateSalary(SalaryCalculationDto salaryCalculationDto) {
//         Long employeeId = salaryCalculationDto.getEmployeeId();
//         String month = salaryCalculationDto.getMonth();
        
//         // 1. 직원 정보 조회
//         Employee employee = employeeRepository.findById(employeeId)
//             .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다."));
            
//         // 2. 기존 급여 기록 확인 
//         Salary existingSalary = salaryRepository.findByEmployeeIdAndMonth(employeeId, month);
        
//         // 3. 해당 월의 기간 설정
//         YearMonth yearMonth = YearMonth.parse(month, DateTimeFormatter.ofPattern("yyyy-MM"));
//         LocalDateTime startOfMonth = yearMonth.atDay(1).atStartOfDay();
//         LocalDateTime endOfMonth = yearMonth.atEndOfMonth().atTime(23, 59, 59);
        
//         // 4. 해당 월의 출퇴근 기록 조회
//         List<Attendance> attendances = attendanceRepository.findAllByEmployeeIdAndCheckInBetween(
//             employeeId, startOfMonth, endOfMonth);
        
//         // 5. 실제 근무 시간 계산
//         BigDecimal actualWorkingHours = BigDecimal.ZERO;
//         for (Attendance attendance : attendances) {
//             if (attendance.getActualWorkingHours() != null) {
//                 actualWorkingHours = actualWorkingHours.add(attendance.getActualWorkingHours());
//             }
//         }
        
//         // 6. 주별 실제 근무 시간 계산 (주휴수당 계산을 위해)
//         Map<Integer, BigDecimal> weeklyHours = calculateWeeklyHours(attendances, yearMonth, employeeId);
        
//         // 7. 주휴수당 계산
//         BigDecimal holidayBonus = calculateHolidayBonus(weeklyHours, employee.getHourlyWage());
        
//         // 8. 급여 계산 (실제 근무시간으로만 계산)
//         BigDecimal baseSalary = actualWorkingHours.multiply(employee.getHourlyWage()).setScale(0, RoundingMode.HALF_UP);
//         holidayBonus = holidayBonus.setScale(0, RoundingMode.HALF_UP);
//         BigDecimal totalSalary = baseSalary.add(holidayBonus);
        
//         // 9. 급여 정보 저장 (기존 기록이 있으면 업데이트, 없으면 새로 생성)
//         if (existingSalary == null) {
//             existingSalary = new Salary();
//             existingSalary.setEmployee(employee);
//             existingSalary.setMonth(month);
//         }

//         // 급여 정보 업데이트
//         existingSalary.setTotalHours(actualWorkingHours);
//         existingSalary.setBaseSalary(baseSalary);
//         existingSalary.setHolidayBonus(holidayBonus);
//         existingSalary.setTotalSalary(totalSalary);

//         return salaryRepository.save(existingSalary);
//     }
    
//     /**
//      * 주별 근무 시간을 계산합니다.
//      * 월~일이 모두 포함된 표준 주 기준으로 계산합니다.
//      */
//     private Map<Integer, BigDecimal> calculateWeeklyHours(List<Attendance> attendances, YearMonth yearMonth, Long employeeId) {
//         Map<Integer, BigDecimal> weeklyHours = new HashMap<>();
//         LocalDate firstDayOfMonth = yearMonth.atDay(1);
//         LocalDate lastDayOfMonth = yearMonth.atEndOfMonth();
        
//         // 첫 주의 월요일 찾기
//         LocalDate firstWeekMonday = firstDayOfMonth;
//         while (firstWeekMonday.getDayOfWeek() != DayOfWeek.MONDAY) {
//             firstWeekMonday = firstWeekMonday.minusDays(1);
//         }
        
//         // 첫 주차의 일요일 계산
//         LocalDate firstSunday = firstWeekMonday.plusDays(6);
        
//         // 특수 케이스: 첫 주가 일요일만 있는 경우 (예: 6월 1일이 일요일인 경우)
//         // 이 경우 첫 주와 두 번째 주를 통합하지 않고 정상 처리
//         boolean isFirstDaySunday = firstDayOfMonth.getDayOfWeek() == DayOfWeek.SUNDAY;
        
//         // 첫 주가 일요일만 있는 경우는 다음 주부터 시작
//         LocalDate startMonday = isFirstDaySunday ? firstWeekMonday.plusDays(7) : firstWeekMonday;
//         int weekNumber = isFirstDaySunday ? 2 : 1; // 일요일만 있는 첫 주는 건너뜀
        
//         // 첫 주가 완전하지 않은 경우 (월요일이 이전 달인 경우) 이전 달의 근무시간 계산
//         if (startMonday.isBefore(firstDayOfMonth) && !isFirstDaySunday) {
//             // 이전 달의 마지막 날 계산
//             YearMonth prevMonth = yearMonth.minusMonths(1);
//             LocalDate prevMonthLastDay = prevMonth.atEndOfMonth();
            
//             // 이전 달의 마지막 날부터 현재 달 첫날 전까지의 근무시간 조회
//             LocalDateTime startOfFirstWeek = startMonday.atStartOfDay();
//             LocalDateTime endOfPrevMonth = prevMonthLastDay.atTime(23, 59, 59);
            
//             List<Attendance> prevMonthAttendances = attendanceRepository.findAllByEmployeeIdAndCheckInBetween(
//                 employeeId, startOfFirstWeek, endOfPrevMonth);
            
//             // 첫 주의 이전 달 부분 근무시간 계산
//             BigDecimal prevMonthHours = BigDecimal.ZERO;
//             for (Attendance attendance : prevMonthAttendances) {
//                 if (attendance.getActualWorkingHours() != null) {
//                     prevMonthHours = prevMonthHours.add(attendance.getActualWorkingHours());
//                 }
//             }
            
//             // 현재 달의 첫 주 시간 계산 (1일부터 첫 주 일요일까지)
//             LocalDate endOfFirstWeek = startMonday.plusDays(6); // 첫 주의 일요일
//             BigDecimal currentMonthFirstWeekHours = BigDecimal.ZERO;
            
//             LocalDate curDay = firstDayOfMonth;
//             while (!curDay.isAfter(endOfFirstWeek)) {
//                 for (Attendance attendance : attendances) {
//                     if (attendance.getCheckIn() != null && 
//                         attendance.getCheckIn().toLocalDate().equals(curDay)) {
//                         BigDecimal hours = attendance.getActualWorkingHours() != null ? 
//                             attendance.getActualWorkingHours() : BigDecimal.ZERO;
//                         currentMonthFirstWeekHours = currentMonthFirstWeekHours.add(hours);
//                     }
//                 }
//                 curDay = curDay.plusDays(1);
//             }
            
//             // 첫 주 전체 시간 계산
//             BigDecimal firstWeekTotal = prevMonthHours.add(currentMonthFirstWeekHours);
//             if (firstWeekTotal.compareTo(BigDecimal.ZERO) > 0) {
//                 weeklyHours.put(weekNumber, firstWeekTotal);
//             }
            
//             // 다음 주로 이동
//             weekNumber++;
//             startMonday = startMonday.plusDays(7);
//         } else if (!isFirstDaySunday) {
//             // 첫 주가 완전하면 그냥 계산
//             BigDecimal firstWeekTotal = BigDecimal.ZERO;
//             LocalDate sunday = startMonday.plusDays(6);
            
//             for (Attendance attendance : attendances) {
//                 if (attendance.getCheckIn() != null) {
//                     LocalDate attendanceDate = attendance.getCheckIn().toLocalDate();
//                     if (!attendanceDate.isBefore(startMonday) && !attendanceDate.isAfter(sunday)) {
//                         BigDecimal hours = attendance.getActualWorkingHours() != null ? 
//                             attendance.getActualWorkingHours() : BigDecimal.ZERO;
//                         firstWeekTotal = firstWeekTotal.add(hours);
//                     }
//                 }
//             }
            
//             if (firstWeekTotal.compareTo(BigDecimal.ZERO) > 0) {
//                 weeklyHours.put(weekNumber, firstWeekTotal);
//             }
            
//             // 다음 주로 이동
//             weekNumber++;
//             startMonday = startMonday.plusDays(7);
//         }
        
//         // 나머지 주 계산
//         LocalDate monday = startMonday;
        
//         while (!monday.isAfter(lastDayOfMonth)) {
//             LocalDate sunday = monday.plusDays(6); // 해당 주의 일요일
            
//             // 이 주가 완전한지 확인
//             boolean isCompleteWeek = !sunday.isAfter(lastDayOfMonth);
            
//             BigDecimal weekTotal = BigDecimal.ZERO;
            
//             if (isCompleteWeek) {
//                 // 완전한 주의 근무시간 계산
//         for (Attendance attendance : attendances) {
//             if (attendance.getCheckIn() != null) {
//                         LocalDate attendanceDate = attendance.getCheckIn().toLocalDate();
//                         if (!attendanceDate.isBefore(monday) && !attendanceDate.isAfter(sunday)) {
//                             BigDecimal hours = attendance.getActualWorkingHours() != null ? 
//                                 attendance.getActualWorkingHours() : BigDecimal.ZERO;
//                             weekTotal = weekTotal.add(hours);
//                         }
//                     }
//                 }
                
//                 if (weekTotal.compareTo(BigDecimal.ZERO) > 0) {
//                     weeklyHours.put(weekNumber, weekTotal);
//                 }
//             } else {
//                 // 마지막 주가 불완전한 경우
//                 LocalDate endDate = lastDayOfMonth;
                
//                 for (Attendance attendance : attendances) {
//                     if (attendance.getCheckIn() != null) {
//                         LocalDate attendanceDate = attendance.getCheckIn().toLocalDate();
//                         if (!attendanceDate.isBefore(monday) && !attendanceDate.isAfter(endDate)) {
//                     BigDecimal hours = attendance.getActualWorkingHours() != null ? 
//                         attendance.getActualWorkingHours() : BigDecimal.ZERO;
//                             weekTotal = weekTotal.add(hours);
//                         }
//                     }
//                 }
                
//                 // 마지막 불완전한 주는 다음 달로 이월
//                 if (weekTotal.compareTo(BigDecimal.ZERO) > 0) {
//                     // 로깅만 수행
//                     System.out.println("직원 " + employeeId + " - " + yearMonth + "의 이월 시간: " + weekTotal);
//                 }
//             }
            
//             monday = monday.plusDays(7);
//             weekNumber++;
//         }
        
//         // 디버깅용 로그
//         System.out.println("월: " + yearMonth + ", 주 수: " + weeklyHours.size() + ", 주차별 시간: " + weeklyHours);
        
//         return weeklyHours;
//     }
    
//     /**
//      * 주휴수당을 계산합니다.
//      */
//     private BigDecimal calculateHolidayBonus(Map<Integer, BigDecimal> weeklyHours, BigDecimal hourlyWage) {
//         BigDecimal totalHolidayBonus = BigDecimal.ZERO;
//         BigDecimal minimumHoursForBonus = new BigDecimal("15");
        
//         for (Map.Entry<Integer, BigDecimal> entry : weeklyHours.entrySet()) {
//             BigDecimal weekHours = entry.getValue();
            
//             // 주 15시간 이상 근무한 경우에만 주휴수당 지급
//             if (weekHours.compareTo(minimumHoursForBonus) >= 0) {
//                 BigDecimal holidayHours = weekHours.multiply(new BigDecimal("8"))
//                     .divide(new BigDecimal("40"), 2, RoundingMode.HALF_UP);
                
//                 BigDecimal weeklyBonus = holidayHours.multiply(hourlyWage);
//                 totalHolidayBonus = totalHolidayBonus.add(weeklyBonus);
//             }
//         }
        
//         return totalHolidayBonus;
//     }

//     // 직원의 예상 월 급여 계산
//     @Transactional(readOnly = true)
//     public Map<String, Object> calculateExpectedSalary(Long employeeId, String month) {
//         // 1. 직원 정보 조회
//         Employee employee = employeeRepository.findById(employeeId)
//             .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다."));
        
//         // 2. 월 정보 파싱
//         YearMonth yearMonth = YearMonth.parse(month, DateTimeFormatter.ofPattern("yyyy-MM"));
//         LocalDate firstDayOfMonth = yearMonth.atDay(1);
//         LocalDate lastDayOfMonth = yearMonth.atEndOfMonth();
        
//         // 3. 근무 일정 조회
//         List<WorkSchedule> schedules = workScheduleRepository.findByEmployeeId(employeeId);
//         if (schedules.isEmpty()) {
//             throw new IllegalArgumentException("등록된 근무 일정이 없습니다.");
//         }
        
//         // 4. 예상 근무 기록 생성
//         List<Attendance> expectedAttendances = createExpectedAttendances(employeeId, yearMonth, schedules);
        
//         // 5. 총 근무시간 계산
//         BigDecimal totalHours = BigDecimal.ZERO;
//         for (Attendance attendance : expectedAttendances) {
//             BigDecimal hours = attendance.getActualWorkingHours() != null ? 
//                 attendance.getActualWorkingHours() : BigDecimal.ZERO;
//             totalHours = totalHours.add(hours);
//         }
        
//         // 6. 주별 근무 시간 계산 (주휴수당 계산을 위해)
//         Map<Integer, BigDecimal> weeklyHours = calculateExpectedWeeklyHours(
//             expectedAttendances, yearMonth, employeeId, schedules);
        
//         // 7. 주휴수당 계산
//         BigDecimal holidayBonus = calculateHolidayBonus(weeklyHours, employee.getHourlyWage());
        
//         // 8. 기본급 계산
//         BigDecimal baseSalary = totalHours.multiply(employee.getHourlyWage()).setScale(0, RoundingMode.HALF_UP);
//         holidayBonus = holidayBonus.setScale(0, RoundingMode.HALF_UP);
//         BigDecimal totalSalary = baseSalary.add(holidayBonus);
        
//         // 9. 주차별 정보 정리
//         Map<String, BigDecimal> weeklyHoursMap = new HashMap<>();
//         for (Map.Entry<Integer, BigDecimal> entry : weeklyHours.entrySet()) {
//             int week = entry.getKey();
//             String weekLabel = week + "주차";
//             weeklyHoursMap.put(weekLabel, entry.getValue());
//         }
        
//         // 10. 결과 반환
//         Map<String, Object> result = new HashMap<>();
//         result.put("employeeId", employeeId);
//         result.put("employeeName", employee.getName());
//         result.put("month", month);
//         result.put("hourlyWage", employee.getHourlyWage());
//         result.put("totalHours", totalHours);
//         result.put("baseSalary", baseSalary);
//         result.put("holidayBonus", holidayBonus);
//         result.put("totalSalary", totalSalary);
//         result.put("weeklyHours", weeklyHoursMap);
        
//         return result;
//     }
    
//     /**
//      * 예상 근무 기록 생성
//      */
//     private List<Attendance> createExpectedAttendances(Long employeeId, YearMonth yearMonth, List<WorkSchedule> schedules) {
//         List<Attendance> expectedAttendances = new ArrayList<>();
//         LocalDate firstDayOfMonth = yearMonth.atDay(1);
//         LocalDate lastDayOfMonth = yearMonth.atEndOfMonth();
        
//         // 해당 월의 모든 날짜를 순회
//         LocalDate date = firstDayOfMonth;
//         while (!date.isAfter(lastDayOfMonth)) {
//             DayOfWeek dayOfWeek = date.getDayOfWeek();
            
//             // 이 요일에 해당하는 근무 일정 찾기
//             for (WorkSchedule schedule : schedules) {
//                 if (schedule.getWorkDay() == dayOfWeek) {
//                     // 예상 근무 기록 생성
//                     Attendance expectedAttendance = new Attendance();
//                     expectedAttendance.setCheckIn(date.atTime(schedule.getStartTime()));
                    
//                     // 근무 시간 계산
//                     LocalTime startTime = schedule.getStartTime();
//                     LocalTime endTime = schedule.getEndTime();
//                     long minutes = java.time.Duration.between(startTime, endTime).toMinutes();
                    
//                     // 휴게시간 차감
//                     if (schedule.getBreakTime() != null) {
//                         long breakMinutes = schedule.getBreakTime().getHour() * 60 + schedule.getBreakTime().getMinute();
//                         minutes -= breakMinutes;
//                     }
                    
//                     BigDecimal hoursPerDay = BigDecimal.valueOf(minutes)
//                         .divide(BigDecimal.valueOf(60), 2, RoundingMode.HALF_UP);
                    
//                     expectedAttendance.setActualWorkingHours(hoursPerDay);
//                     expectedAttendances.add(expectedAttendance);
//                 }
//             }
            
//             date = date.plusDays(1);
//         }
        
//         return expectedAttendances;
//     }
    
//     /**
//      * 예상 주별 근무 시간을 계산합니다.
//      * 월~일이 모두 포함된 표준 주 기준으로 계산합니다.
//      */
//     private Map<Integer, BigDecimal> calculateExpectedWeeklyHours(
//             List<Attendance> attendances, YearMonth yearMonth, Long employeeId, List<WorkSchedule> schedules) {
//         Map<Integer, BigDecimal> weeklyHours = new HashMap<>();
//         LocalDate firstDayOfMonth = yearMonth.atDay(1);
//         LocalDate lastDayOfMonth = yearMonth.atEndOfMonth();
        
//         // 첫 주의 월요일 찾기
//         LocalDate firstWeekMonday = firstDayOfMonth;
//         while (firstWeekMonday.getDayOfWeek() != DayOfWeek.MONDAY) {
//             firstWeekMonday = firstWeekMonday.minusDays(1);
//         }
        
//         // 첫 주차의 일요일 계산
//         LocalDate firstSunday = firstWeekMonday.plusDays(6);
        
//         // 특수 케이스: 첫 주가 일요일만 있는 경우 (예: 6월 1일이 일요일인 경우)
//         // 이 경우 첫 주와 두 번째 주를 통합하지 않고 정상 처리
//         boolean isFirstDaySunday = firstDayOfMonth.getDayOfWeek() == DayOfWeek.SUNDAY;
        
//         // 첫 주가 일요일만 있는 경우는 다음 주부터 시작
//         LocalDate startMonday = isFirstDaySunday ? firstWeekMonday.plusDays(7) : firstWeekMonday;
//         int weekNumber = isFirstDaySunday ? 2 : 1; // 일요일만 있는 첫 주는 건너뜀
        
//         // 첫 주가 완전하지 않은 경우 (월요일이 이전 달인 경우) 이전 달의 근무시간 계산
//         if (startMonday.isBefore(firstDayOfMonth) && !isFirstDaySunday) {
//             // 이전 달의 마지막 날 계산
//             YearMonth prevMonth = yearMonth.minusMonths(1);
//             LocalDate prevMonthLastDay = prevMonth.atEndOfMonth();
            
//             // 첫 주의 이전 달 부분 근무시간 계산
//             BigDecimal prevMonthHours = BigDecimal.ZERO;
            
//             LocalDate day = startMonday;
//             while (day.isBefore(firstDayOfMonth)) {
//                 DayOfWeek dayOfWeek = day.getDayOfWeek();
                
//                 // 해당 요일의 근무 일정 찾기
//                 for (WorkSchedule schedule : schedules) {
//                     if (schedule.getWorkDay() == dayOfWeek) {
//                         // 근무 시간 계산
//                         LocalTime startTime = schedule.getStartTime();
//                         LocalTime endTime = schedule.getEndTime();
//                         long minutes = java.time.Duration.between(startTime, endTime).toMinutes();
                        
//                         // 휴게시간 차감
//                         if (schedule.getBreakTime() != null) {
//                             long breakMinutes = schedule.getBreakTime().getHour() * 60 + schedule.getBreakTime().getMinute();
//                             minutes -= breakMinutes;
//                         }
                        
//                         BigDecimal hoursPerDay = BigDecimal.valueOf(minutes)
//                             .divide(BigDecimal.valueOf(60), 2, RoundingMode.HALF_UP);
                        
//                         prevMonthHours = prevMonthHours.add(hoursPerDay);
//                     }
//                 }
                
//                 day = day.plusDays(1);
//             }
            
//             // 현재 달의 첫 주 시간 계산 (1일부터 첫 주 일요일까지)
//             BigDecimal currentMonthFirstWeekHours = BigDecimal.ZERO;
//             LocalDate endOfFirstWeek = startMonday.plusDays(6); // 첫 주의 일요일
            
//             LocalDate curDay = firstDayOfMonth;
//             while (!curDay.isAfter(endOfFirstWeek)) {
//                 for (Attendance attendance : attendances) {
//                     if (attendance.getCheckIn() != null && 
//                         attendance.getCheckIn().toLocalDate().equals(curDay)) {
//                         BigDecimal hours = attendance.getActualWorkingHours() != null ? 
//                             attendance.getActualWorkingHours() : BigDecimal.ZERO;
//                         currentMonthFirstWeekHours = currentMonthFirstWeekHours.add(hours);
//                     }
//                 }
//                 curDay = curDay.plusDays(1);
//             }
            
//             // 첫 주 전체 시간 계산
//             BigDecimal firstWeekTotal = prevMonthHours.add(currentMonthFirstWeekHours);
//             if (firstWeekTotal.compareTo(BigDecimal.ZERO) > 0) {
//                 weeklyHours.put(weekNumber, firstWeekTotal);
//             }
            
//             // 다음 주로 이동
//             weekNumber++;
//             startMonday = startMonday.plusDays(7);
//         } else if (!isFirstDaySunday) {
//             // 첫 주가 완전하면 그냥 계산
//             BigDecimal firstWeekTotal = BigDecimal.ZERO;
//             LocalDate sunday = startMonday.plusDays(6);
            
//             for (Attendance attendance : attendances) {
//                 if (attendance.getCheckIn() != null) {
//                     LocalDate attendanceDate = attendance.getCheckIn().toLocalDate();
//                     if (!attendanceDate.isBefore(startMonday) && !attendanceDate.isAfter(sunday)) {
//                         BigDecimal hours = attendance.getActualWorkingHours() != null ? 
//                             attendance.getActualWorkingHours() : BigDecimal.ZERO;
//                         firstWeekTotal = firstWeekTotal.add(hours);
//                     }
//                 }
//             }
            
//             if (firstWeekTotal.compareTo(BigDecimal.ZERO) > 0) {
//                 weeklyHours.put(weekNumber, firstWeekTotal);
//             }
            
//             // 다음 주로 이동
//             weekNumber++;
//             startMonday = startMonday.plusDays(7);
//         }
        
//         // 나머지 주 계산
//         LocalDate monday = startMonday;
        
//         while (!monday.isAfter(lastDayOfMonth)) {
//             LocalDate sunday = monday.plusDays(6); // 해당 주의 일요일
            
//             // 이 주가 완전한지 확인
//             boolean isCompleteWeek = !sunday.isAfter(lastDayOfMonth);
            
//             BigDecimal weekTotal = BigDecimal.ZERO;
            
//             if (isCompleteWeek) {
//                 // 완전한 주의 근무시간 계산
//                 for (Attendance attendance : attendances) {
//                     if (attendance.getCheckIn() != null) {
//                         LocalDate attendanceDate = attendance.getCheckIn().toLocalDate();
//                         if (!attendanceDate.isBefore(monday) && !attendanceDate.isAfter(sunday)) {
//                             BigDecimal hours = attendance.getActualWorkingHours() != null ? 
//                                 attendance.getActualWorkingHours() : BigDecimal.ZERO;
//                             weekTotal = weekTotal.add(hours);
//                         }
//                     }
//                 }
                
//                 if (weekTotal.compareTo(BigDecimal.ZERO) > 0) {
//                     weeklyHours.put(weekNumber, weekTotal);
//                 }
//             } else {
//                 // 마지막 주가 불완전한 경우
//                 LocalDate endDate = lastDayOfMonth;
                
//                 for (Attendance attendance : attendances) {
//                     if (attendance.getCheckIn() != null) {
//                         LocalDate attendanceDate = attendance.getCheckIn().toLocalDate();
//                         if (!attendanceDate.isBefore(monday) && !attendanceDate.isAfter(endDate)) {
//                             BigDecimal hours = attendance.getActualWorkingHours() != null ? 
//                                 attendance.getActualWorkingHours() : BigDecimal.ZERO;
//                             weekTotal = weekTotal.add(hours);
//                         }
//                     }
//                 }
                
//                 // 마지막 불완전한 주는 다음 달로 이월
//                 if (weekTotal.compareTo(BigDecimal.ZERO) > 0) {
//                     // 로깅만 수행
//                     System.out.println("직원 " + employeeId + " - " + yearMonth + "의 이월 시간: " + weekTotal);
//                 }
//             }
            
//             monday = monday.plusDays(7);
//             weekNumber++;
//         }
        
//         // 디버깅용 로그
//         System.out.println("월: " + yearMonth + ", 주 수: " + weeklyHours.size() + ", 주차별 시간: " + weeklyHours);
        
//         return weeklyHours;
//     }
    
//     /**
//      * 특정 월의 모든 급여 정보를 조회합니다.
//      */
//     @Transactional(readOnly = true)
//     public List<Salary> getAllSalariesByMonth(String month) {
//         return salaryRepository.findByMonth(month);
//     }
    
//     /**
//      * 특정 직원의 급여 이력을 조회합니다.
//      */
//     @Transactional(readOnly = true)
//     public List<Salary> getEmployeeSalaryHistory(Long employeeId) {
//         return salaryRepository.findByEmployeeId(employeeId);
//     }
    
//     /**
//      * 특정 직원의 특정 월 급여를 조회합니다.
//      */
//     @Transactional(readOnly = true)
//     public Salary getSalaryByEmployeeAndMonth(SalaryCalculationDto searchDto) {
//         Long employeeId = searchDto.getEmployeeId();
//         String month = searchDto.getMonth();
//         return salaryRepository.findByEmployeeIdAndMonth(employeeId, month);
//     }

//     // 특정 월의 모든 직원 급여 합계 조회
//     @Transactional(readOnly = true)
//     public BigDecimal getTotalSalaryByMonth(String month) {
//         return salaryRepository.getTotalSalaryByMonth(month);
//     }
// }
