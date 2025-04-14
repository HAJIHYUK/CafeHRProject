package com.cafehr.controller;

import java.security.Principal;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class HomeController {

    @GetMapping("/")
    public String index(Model model) {
        // 로그인 상태 확인
        addAuthToModel(model);
        return "home";
    }

    @GetMapping("/home")
    public String home(Model model) {
        // 로그인 상태 확인
        addAuthToModel(model);
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
    
    // 모델에 인증 정보 추가
    private void addAuthToModel(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        boolean isLoggedIn = auth != null && auth.isAuthenticated() && 
                            !auth.getName().equals("anonymousUser");
        
        model.addAttribute("isLoggedIn", isLoggedIn);
        if (isLoggedIn) {
            model.addAttribute("username", auth.getName());
        }
    }
} 