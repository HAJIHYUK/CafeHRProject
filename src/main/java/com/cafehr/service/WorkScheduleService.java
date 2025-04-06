package com.cafehr.service;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

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

        // 프론트에서 받은 일정 중복 여부 확인 (같은 요일에 시간이 겹치는 일정이 있는지)
        // 요일별로 일정을 그룹화
        for (int i = 0; i < workScheduleDto.size(); i++) {
            WorkScheduleDto dto1 = workScheduleDto.get(i);
            DayOfWeek day1 = dto1.getWorkDay();
            LocalTime start1 = dto1.getStartTime();
            LocalTime end1 = dto1.getEndTime();
            
            // 시작 시간과 종료 시간 유효성 검사
            if (end1.compareTo(start1) <= 0) {
                throw new IllegalArgumentException("시작 시간은 종료 시간보다 이전이어야 합니다.");
            }
            
            // 같은 요일의 다른 일정과 비교
            for (int j = 0; j < i; j++) {
                WorkScheduleDto dto2 = workScheduleDto.get(j);
                
                // 같은 요일이면 시간 겹침 확인
                if (day1.equals(dto2.getWorkDay())) {
                    LocalTime start2 = dto2.getStartTime();
                    LocalTime end2 = dto2.getEndTime();
                    
                    // 시간 겹침 체크
                    boolean timeOverlap = 
                        (start1.compareTo(start2) >= 0 && start1.compareTo(end2) < 0) ||
                        (end1.compareTo(start2) > 0 && end1.compareTo(end2) <= 0) ||
                        (start1.compareTo(start2) <= 0 && end1.compareTo(end2) >= 0);
                    
                    if (timeOverlap) {
                        throw new IllegalArgumentException(
                            String.format("같은 요청 내에서 %s에 %s부터 %s까지와 %s부터 %s까지 시간이 겹치는 근무 일정이 있습니다.",
                                getDayDisplayName(day1),
                                start2.toString().substring(0, 5),
                                end2.toString().substring(0, 5),
                                start1.toString().substring(0, 5),
                                end1.toString().substring(0, 5)
                            )
                        );
                    }
                }
            }
        }

        // 각 일정을 개별적으로 처리
        for (WorkScheduleDto dto : workScheduleDto) {
            // 현재 일정의 요일과 시간
            DayOfWeek newDay = dto.getWorkDay();
            LocalTime newStartTime = dto.getStartTime();
            LocalTime newEndTime = dto.getEndTime();
            
            // 시작 시간과 종료 시간 유효성 검사
            if (newEndTime.compareTo(newStartTime) <= 0) {
                throw new IllegalArgumentException("시작 시간은 종료 시간보다 이전이어야 합니다.");
            }
            
            // 해당 직원의 최신 근무 일정을 매번 조회
            List<WorkSchedule> existingSchedules = workScheduleRepository.findByEmployeeId(employee.getId());
            
            // 중복 여부 확인
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
            
            // 중복 검사를 통과한 일정 등록
            WorkSchedule workSchedule = new WorkSchedule();
            workSchedule.setEmployee(employee);
            workSchedule.setWorkDay(dto.getWorkDay());
            workSchedule.setStartTime(dto.getStartTime());
            workSchedule.setEndTime(dto.getEndTime());
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
