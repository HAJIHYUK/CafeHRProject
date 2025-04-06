package com.cafehr.entity;

import java.time.DayOfWeek;
import java.time.LocalTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "work_schedule")
@Getter
@Setter
@NoArgsConstructor
public class WorkSchedule {

    // 근무 일정 ID
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;

    // 직원 정보
    @ManyToOne
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    // 근무 요일
    @Enumerated(EnumType.STRING)
    @Column(name = "work_day", nullable = false)
    private DayOfWeek workDay;

    // 근무 시작 시간
    @Column(name = "start_time", nullable = false)
    private LocalTime startTime; // 근무 시작 시간

    // 근무 종료 시간
    @Column(name = "end_time", nullable = false)
    private LocalTime endTime; // 근무 종료 시간




}
