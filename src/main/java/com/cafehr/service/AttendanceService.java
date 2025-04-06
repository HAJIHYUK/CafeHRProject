package com.cafehr.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cafehr.dto.AttendanceAddByAdminDto;
import com.cafehr.dto.AttendanceHourDto;
import com.cafehr.dto.AttendanceModifyDto;
import com.cafehr.entity.Attendance;
import com.cafehr.entity.Employee;
import com.cafehr.repository.AttendanceRepository;
import com.cafehr.repository.EmployeeRepository;

import lombok.RequiredArgsConstructor;

//출결 관리, 출결 기록 조회, 출결 기록 수정 등
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AttendanceService {

    private final EmployeeRepository employeeRepository;
    private final AttendanceRepository attendanceRepository;
    
    
    
    // 출근 기록 생성
    @Transactional
    public AttendanceHourDto recordAttendance(Long employeeId) {
        Employee employee = employeeRepository.findById(employeeId)
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다."));

        if(employee.isActive() == false) {
            throw new IllegalStateException("퇴직처리된 직원입니다.");
        }
        
        // 오늘 날짜
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(23, 59, 59);
        
        // 오늘 이미 출근 기록이 있는지 확인
        if (attendanceRepository.existsByEmployeeIdAndCheckInBetween(employeeId, startOfDay, endOfDay)) {
            throw new IllegalStateException(employee.getName() + "님은 이미 오늘 출근하셨습니다.");
        }
        
        // 출근 기록 생성
        Attendance attendance = new Attendance();
        attendance.setEmployee(employee);
        attendance.setCheckIn(LocalDateTime.now());
        attendance.setModified(false);
        
        attendanceRepository.save(attendance);

        // 출근 기록 Dto로 변환 ( 캡슐화 )
        AttendanceHourDto attendanceHourDto = new AttendanceHourDto();
        attendanceHourDto.setEmployeeId(employee.getId());
        attendanceHourDto.setAttendanceId(attendance.getId());
        attendanceHourDto.setName(employee.getName());
        attendanceHourDto.setCheckIn(attendance.getCheckIn());
        attendanceHourDto.setCheckOut(attendance.getCheckOut());

        return attendanceHourDto;
    }

    //출근 기록 관리자 임의 생성
    @Transactional
    public AttendanceHourDto recordAttendanceByAdmin(AttendanceAddByAdminDto attendanceAddByAdminDto) {
        Employee employee = employeeRepository.findById(attendanceAddByAdminDto.getEmployeeId())
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다."));

        Attendance attendance = new Attendance();
        attendance.setEmployee(employee);
        attendance.setCheckIn(attendanceAddByAdminDto.getCheckIn());
        attendance.setCheckOutWithoutCalculation(attendanceAddByAdminDto.getCheckOut());
        attendance.setTotalHours(attendanceAddByAdminDto.getTotalHours());
        attendance.setModified(true);
        attendance.setUpdatedAt(LocalDateTime.now());

        attendanceRepository.save(attendance);
        
        AttendanceHourDto attendanceHourDto = new AttendanceHourDto();
        attendanceHourDto.setEmployeeId(employee.getId());
        attendanceHourDto.setAttendanceId(attendance.getId());
        attendanceHourDto.setName(employee.getName());
        attendanceHourDto.setCheckIn(attendance.getCheckIn());
        attendanceHourDto.setCheckOut(attendance.getCheckOut());

        return attendanceHourDto;

    }




    // 퇴근 기록 생성
    @Transactional
    public AttendanceHourDto recordCheckOut(Long employeeId) {
        Employee employee = employeeRepository.findById(employeeId)
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 직원입니다."));
            
        if(employee.isActive() == false) {
            throw new IllegalStateException("퇴적처리된 직원입니다.");
        }
            
        // 오늘 날짜
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(23, 59, 59);  

        // 오늘의 출근 기록 조회
        Attendance todayAttendance = attendanceRepository.findByEmployeeIdAndCheckInBetween(employeeId, startOfDay, endOfDay)
            .orElseThrow(() -> new IllegalStateException(employee.getName() + "님의 출근 기록을 찾을 수 없습니다."));

        // 이미 퇴근 기록이 있는지 확인
        if (todayAttendance.getCheckOut() != null) {
            throw new IllegalStateException(employee.getName() + "님은 이미 오늘 퇴근하셨습니다.");
        }

        // 퇴근 시간 업데이트
        todayAttendance.setCheckOut(LocalDateTime.now());   
        attendanceRepository.save(todayAttendance);

        // 퇴근 기록 Dto로 변환
        AttendanceHourDto attendanceHourDto = new AttendanceHourDto();
        attendanceHourDto.setEmployeeId(employee.getId());
        attendanceHourDto.setAttendanceId(todayAttendance.getId());
        attendanceHourDto.setName(employee.getName());
        attendanceHourDto.setCheckIn(todayAttendance.getCheckIn());
        attendanceHourDto.setCheckOut(todayAttendance.getCheckOut());
        attendanceHourDto.setTotalHours(todayAttendance.getTotalHours());
        return attendanceHourDto;
    }


    // 전체 직원 출근 기록 조회
    public List<AttendanceHourDto> getAllAttendance() {
        List<Attendance> attendanceList = attendanceRepository.findAll();
        List<AttendanceHourDto> dtoList = new ArrayList<>();
        
        for (Attendance attendance : attendanceList) {
            AttendanceHourDto dto = new AttendanceHourDto();
            dto.setEmployeeId(attendance.getEmployee().getId());
            dto.setAttendanceId(attendance.getId());
            dto.setName(attendance.getEmployee().getName());
            dto.setCheckIn(attendance.getCheckIn());
            dto.setCheckOut(attendance.getCheckOut());
            dto.setTotalHours(attendance.getTotalHours());
            dtoList.add(dto);
        }
        
        return dtoList;
    }


    // 전체 직원 출근 기록조회 ( 날짜 지정 )
    public List<AttendanceHourDto> getAttendanceByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        List<Attendance> attendanceList = attendanceRepository.findAllByCheckInBetween(startDate, endDate);
        List<AttendanceHourDto> dtoList = new ArrayList<>();

        for(Attendance attendance : attendanceList) {
            AttendanceHourDto dto = new AttendanceHourDto();
            dto.setEmployeeId(attendance.getEmployee().getId());
            dto.setAttendanceId(attendance.getId());
            dto.setName(attendance.getEmployee().getName());
            dto.setCheckIn(attendance.getCheckIn());
            dto.setCheckOut(attendance.getCheckOut());
            dto.setTotalHours(attendance.getTotalHours());
            dtoList.add(dto);
        }

        return dtoList;
        
    }


    // 특정 직원 출근 기록 조회 
    public List<AttendanceHourDto> getAttendanceByEmployeeId(Long employeeId) {
        List<Attendance> attendanceList = attendanceRepository.findByEmployeeId(employeeId);
        List<AttendanceHourDto> dtoList = new ArrayList<>();
        
        for (Attendance attendance : attendanceList) {
            AttendanceHourDto dto = new AttendanceHourDto();
            dto.setEmployeeId(attendance.getEmployee().getId());
            dto.setAttendanceId(attendance.getId());
            dto.setName(attendance.getEmployee().getName());
            dto.setCheckIn(attendance.getCheckIn());
            dto.setCheckOut(attendance.getCheckOut());
            dto.setTotalHours(attendance.getTotalHours());
            dtoList.add(dto);
        }

        return dtoList;
    }

    // 특정 직원 출근 기록 조회 ( 날짜 범위 지정 )
    public List<AttendanceHourDto> getAttendanceByEmployeeIdAndDateRange(Long employeeId, LocalDateTime startDate, LocalDateTime endDate) {
        List<Attendance> attendanceList = attendanceRepository.findAllByEmployeeIdAndCheckInBetween(employeeId, startDate, endDate);
        List<AttendanceHourDto> dtoList = new ArrayList<>();
        
        for (Attendance attendance : attendanceList) {
            AttendanceHourDto dto = new AttendanceHourDto();
            dto.setEmployeeId(attendance.getEmployee().getId());
            dto.setAttendanceId(attendance.getId());
            dto.setName(attendance.getEmployee().getName());
            dto.setCheckIn(attendance.getCheckIn());
            dto.setCheckOut(attendance.getCheckOut());
            dto.setTotalHours(attendance.getTotalHours());
            dtoList.add(dto);
        }
        
        return dtoList;
    }

    //직원 이름 부분 검색으로 출근 기록 조회
    public List<AttendanceHourDto> getAttendanceByNameContaining(String nameContains) {
        List<Employee> employees = employeeRepository.findByNameContaining(nameContains);
        List<AttendanceHourDto> dtoList = new ArrayList<>();
        
        for (Employee employee : employees) {
            List<Attendance> attendanceList = attendanceRepository.findByEmployeeId(employee.getId());
            
            for (Attendance attendance : attendanceList) {
                AttendanceHourDto dto = new AttendanceHourDto();
                dto.setEmployeeId(attendance.getEmployee().getId());
                dto.setAttendanceId(attendance.getId());
                dto.setName(attendance.getEmployee().getName());
                dto.setCheckIn(attendance.getCheckIn());
                dto.setCheckOut(attendance.getCheckOut());
                dto.setTotalHours(attendance.getTotalHours());
                dtoList.add(dto);
            }
        }
        
        return dtoList;
    }
    
    //직원 이름 부분 검색과 날짜 범위로 출근 기록 조회
    public List<AttendanceHourDto> getAttendanceByNameContainingAndDateRange(String nameContains, LocalDateTime startDate, LocalDateTime endDate) {
        List<Employee> employees = employeeRepository.findByNameContaining(nameContains);
        List<AttendanceHourDto> dtoList = new ArrayList<>();
        
        for (Employee employee : employees) {
            List<Attendance> attendanceList = attendanceRepository.findAllByEmployeeIdAndCheckInBetween(employee.getId(), startDate, endDate);
            
            for (Attendance attendance : attendanceList) {
                AttendanceHourDto dto = new AttendanceHourDto();
                dto.setEmployeeId(attendance.getEmployee().getId());
                dto.setAttendanceId(attendance.getId());
                dto.setName(attendance.getEmployee().getName());
                dto.setCheckIn(attendance.getCheckIn());
                dto.setCheckOut(attendance.getCheckOut());
                dto.setTotalHours(attendance.getTotalHours());
                dtoList.add(dto);
            }
        }
        
        return dtoList;
    }


    // 출근 기록 수정 
    @Transactional
    public AttendanceHourDto updateAttendance(Long attendanceId, AttendanceModifyDto attendanceModifyDto) {
        Attendance attendance = attendanceRepository.findById(attendanceId)
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 출근 기록입니다."));
        
        // 1. 출근 시간 설정 (자동 계산 없음)
        if (attendanceModifyDto.getCheckIn() != null ) {
            attendance.setCheckIn(attendanceModifyDto.getCheckIn());
        };
        
        // 2. 퇴근 시간 설정 ( 자동계산 업음 )
        if (attendanceModifyDto.getCheckOut() != null) {
            
            attendance.setCheckOutWithoutCalculation(attendanceModifyDto.getCheckOut());
        };
        
        // 3. 총 근무시간 설정 ( 자동계산 없음 )
        if (attendanceModifyDto.getTotalHours() != null) {
            attendance.setTotalHours(attendanceModifyDto.getTotalHours());
        };
        
        attendance.setModified(true);
        attendanceRepository.save(attendance);

        // 수정된 출근 기록 Dto로 변환
        AttendanceHourDto updatedAttendanceHourDto = new AttendanceHourDto();
        updatedAttendanceHourDto.setEmployeeId(attendance.getEmployee().getId());
        updatedAttendanceHourDto.setAttendanceId(attendance.getId());
        updatedAttendanceHourDto.setName(attendance.getEmployee().getName());
        updatedAttendanceHourDto.setCheckIn(attendance.getCheckIn());
        updatedAttendanceHourDto.setCheckOut(attendance.getCheckOut());
        updatedAttendanceHourDto.setTotalHours(attendance.getTotalHours());
        return updatedAttendanceHourDto;
            
    }


    // 출근 기록 삭제
    @Transactional
    public void deleteAttendance(Long attendanceId) {
        attendanceRepository.deleteById(attendanceId);
    }


    




    
}
