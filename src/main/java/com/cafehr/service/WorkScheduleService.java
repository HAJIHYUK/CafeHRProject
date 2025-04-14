package com.cafehr.service;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cafehr.dto.WorkScheduleDto;
import com.cafehr.dto.WorkScheduleExpectTotalHoursDto;
import com.cafehr.entity.Attendance;
import com.cafehr.entity.Employee;
import com.cafehr.entity.WorkSchedule;
import com.cafehr.repository.AttendanceRepository;
import com.cafehr.repository.EmployeeRepository;
import com.cafehr.repository.WorkScheduleRepository;

import lombok.RequiredArgsConstructor;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class WorkScheduleService {

    private final WorkScheduleRepository workScheduleRepository;
    private final EmployeeRepository employeeRepository;
    private final AttendanceRepository attendanceRepository;

    // 여러개 근무 일정 등록 (단일등록, 다수등록 둘다가능)
    @Transactional
    public List<WorkScheduleDto> registerWorkSchedule(List<WorkScheduleDto> workScheduleDto) {
       
        // 직원 존재 여부 확인 모든 DTO가 동일한 employeeId를 가진다고 가정
        Employee employee = employeeRepository.findById(workScheduleDto.get(0).getEmployeeId())
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다."));

        List<WorkScheduleDto> workScheduleList = new ArrayList<>();
        
        // 클라이언트 요청 데이터 디버그 로깅
        System.out.println("요청된 스케줄 수: " + workScheduleDto.size());
        for (WorkScheduleDto dto : workScheduleDto) {
            System.out.println("요일: " + dto.getWorkDay() + 
                             ", 시작시간: " + dto.getStartTime() + 
                             ", 종료시간: " + dto.getEndTime());
        }
        
        // 같은 요일의 일정들을 비교하여 시간 겹침 체크 (근무일정등록시 동시에 들어온 중복 근무일정 체크)
        for (int i = 0; i < workScheduleDto.size(); i++) {
            WorkScheduleDto schedule1 = workScheduleDto.get(i);
            
            for (int j = i + 1; j < workScheduleDto.size(); j++) {
                WorkScheduleDto schedule2 = workScheduleDto.get(j);
                
                // 같은 요일인 경우에만 체크
                if (schedule1.getWorkDay() == schedule2.getWorkDay()) {
                    // 시간 겹침 체크
                    if (schedule1.getStartTime().isBefore(schedule2.getEndTime()) && 
                        schedule2.getStartTime().isBefore(schedule1.getEndTime())) {
                        throw new IllegalArgumentException(
                            String.format("%s에 겹치는 근무 시간이 있습니다. (%s-%s와 %s-%s)",
                                getDayDisplayName(schedule1.getWorkDay()),
                                schedule1.getStartTime().toString().substring(0, 5),
                                schedule1.getEndTime().toString().substring(0, 5),
                                schedule2.getStartTime().toString().substring(0, 5),
                                schedule2.getEndTime().toString().substring(0, 5)
                            )
                        );
                    }
                }
            }
        }
        
        // 디버그 로깅
        System.out.println("중복 체크 후 스케줄 수: " + workScheduleDto.size());
        
        // 해당 직원의 최신 근무 일정을 한 번만 조회
        List<WorkSchedule> existingSchedules = workScheduleRepository.findByEmployeeId(employee.getId());
        
        // 각 일정을 먼저 모두 검사만 하고 저장은 나중에 수행
        for (WorkScheduleDto dto : workScheduleDto) {
            // 현재 일정의 요일과 시간
            DayOfWeek newDay = dto.getWorkDay();
            LocalTime newStartTime = dto.getStartTime();
            LocalTime newEndTime = dto.getEndTime();
            
            // 시작 시간과 종료 시간 유효성 검사
            if (newEndTime.compareTo(newStartTime) <= 0) {
                throw new IllegalArgumentException("시작 시간은 종료 시간보다 이전이어야 합니다.");
            }
            
            // 새 일정과 기존 일정 중복 여부 확인
            for (WorkSchedule existingSchedule : existingSchedules) {
                if (existingSchedule.getWorkDay().equals(newDay)) {
                    LocalTime existingStartTime = existingSchedule.getStartTime();
                    LocalTime existingEndTime = existingSchedule.getEndTime();
                    
                    // 시간 겹침 체크: 새 일정의 시작/종료 시간이 기존 일정 시간과 겹치는지 확인
                    // 1. 새 일정 시작 시간이 기존 일정 안에 있는 경우
                    // 2. 새 일정 종료 시간이 기존 일정 안에 있는 경우
                    // 3. 새 일정이 기존 일정을 완전히 포함하는 경우
                    boolean timeOverlap = 
                        (newStartTime.compareTo(existingStartTime) >= 0 && newStartTime.compareTo(existingEndTime) < 0) ||
                        (newEndTime.compareTo(existingStartTime) > 0 && newEndTime.compareTo(existingEndTime) <= 0) ||
                        (newStartTime.compareTo(existingStartTime) <= 0 && newEndTime.compareTo(existingEndTime) >= 0);
                    
                    if (timeOverlap) {
                        throw new IllegalArgumentException(
                            String.format("%s에 이미 %s부터 %s까지 근무 일정이 존재합니다.(겹치는 근무일정)",
                                getDayDisplayName(newDay),
                                existingStartTime.toString().substring(0, 5),
                                existingEndTime.toString().substring(0, 5)
                            )
                        );
                    }
                }
            }
        }
        
        // 모든 검사가 통과했으므로 이제 일정을 저장
        for (WorkScheduleDto dto : workScheduleDto) {
            WorkSchedule workSchedule = new WorkSchedule();
            workSchedule.setEmployee(employee);
            workSchedule.setWorkDay(dto.getWorkDay());
            workSchedule.setStartTime(dto.getStartTime());
            workSchedule.setEndTime(dto.getEndTime());
            workSchedule.setBreakTime(dto.getBreakTime());
            workScheduleRepository.save(workSchedule);
            
            workScheduleList.add(dto);
        }

        return workScheduleList;
    }


    //직원 id로 근무 일정 조회
    @Transactional
    public List<WorkScheduleDto> getWorkScheduleByEmployeeId(Long employeeId) {
        Employee employee = employeeRepository.findById(employeeId)
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다."));

        List<WorkSchedule> workSchedules = workScheduleRepository.findByEmployeeId(employeeId);

        List<WorkScheduleDto> workScheduleList = new ArrayList<>();
        
        for(WorkSchedule ws : workSchedules) {
            WorkScheduleDto dto = new WorkScheduleDto();
            dto.setId(ws.getId());
            dto.setEmployeeId(ws.getEmployee().getId());
            dto.setWorkDay(ws.getWorkDay());
            dto.setStartTime(ws.getStartTime());
            dto.setEndTime(ws.getEndTime());
            dto.setBreakTime(ws.getBreakTime());
            workScheduleList.add(dto);
        }

        return workScheduleList;
    }

    //직원 id로 근무 일정 일괄 삭제
    @Transactional
    public void deleteWorkScheduleByEmployeeId(Long employeeId) {
        workScheduleRepository.deleteByEmployeeId(employeeId);
    }

    //스케쥴 id로 근무 일정 삭제
    @Transactional
    public void deleteWorkScheduleById(Long id) {
        workScheduleRepository.deleteById(id);
    }
    
    // 요일 이름 변환을 위한 유틸리티 메서드
    private String getDayDisplayName(DayOfWeek day) {
        switch (day) {
            case MONDAY: return "월요일";
            case TUESDAY: return "화요일";
            case WEDNESDAY: return "수요일";
            case THURSDAY: return "목요일";
            case FRIDAY: return "금요일";
            case SATURDAY: return "토요일";
            case SUNDAY: return "일요일";
            default: return day.toString();
        }
    }


    //예상 근무시간 계산
    @Transactional
    public List<WorkScheduleExpectTotalHoursDto> calculateExpectTotalHours() {

        List<Attendance> attendance = attendanceRepository.findAll();
        List<WorkScheduleExpectTotalHoursDto> workScheduleExpectTotalHoursDtoList = new ArrayList<>();
        
        for(Attendance a : attendance) {
            WorkScheduleExpectTotalHoursDto dto = new WorkScheduleExpectTotalHoursDto();
            LocalDateTime checkInDateTime = a.getCheckIn(); // 출근 시간 가져오기
            DayOfWeek day = checkInDateTime.getDayOfWeek(); // 요일 구하기
            List<WorkSchedule> ws = workScheduleRepository.findByEmployeeIdAndWorkDay(a.getEmployee().getId(), day);
            BigDecimal hours = BigDecimal.ZERO;

            for(WorkSchedule w : ws) {
                LocalTime startTime = w.getStartTime();
                LocalTime endTime = w.getEndTime();
                long minutes = java.time.Duration.between(startTime, endTime).toMinutes();
                
                // 휴게시간이 있으면 근무시간에서 차감
                if (w.getBreakTime() != null) {
                    // 휴게시간을 분으로 계산 (시간*60 + 분)
                    long breakMinutes = w.getBreakTime().getHour() * 60 + w.getBreakTime().getMinute();
                    minutes -= breakMinutes;
                }
                
                hours = hours.add(BigDecimal.valueOf(minutes).divide(BigDecimal.valueOf(60), 2, BigDecimal.ROUND_HALF_UP));
            }


            dto.setEmployeeId(a.getEmployee().getId());
            dto.setAttendanceId(a.getId());
            dto.setWorkDay(day);
            dto.setExpectTotalHours(hours);

            workScheduleExpectTotalHoursDtoList.add(dto);
        }
            return workScheduleExpectTotalHoursDtoList;
            
    }


    
}
