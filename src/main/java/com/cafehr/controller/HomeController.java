package com.cafehr.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class HomeController {

    @GetMapping("/")
    public String index() {
        return "home";
    }

    @GetMapping("/home")
    public String home() {
        return "home";
    }
    
    @GetMapping("/attendancelist")
    public String attendanceList() {
        return "attendance/list";
    }

    @GetMapping("/salary")
    public String salary() {
        return "salary";
    }
} 