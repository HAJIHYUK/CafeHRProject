package com.cafehr.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import jakarta.servlet.DispatcherType;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            // CSRF 보호 비활성화
            .csrf(csrf -> csrf.disable())
            
            // 요청 권한 설정
            .authorizeHttpRequests(auth -> auth
                // 홈 페이지 및 루트 페이지는 모든 사용자 접근 가능
                .requestMatchers("/", "/home").permitAll()
                
                // 정적 리소스는 모든 사용자 접근 가능
                .requestMatchers("/css/**", "/js/**", "/images/**", "/image/**").permitAll()
                
                // 직원 출근/퇴근 API는 모든 사용자 접근 가능
                .requestMatchers("/api/attendance/check-in/**", "/api/attendance/check-out/**").permitAll()
                
                // 직원 메모 관련 API 및 페이지는 모든 사용자 접근 가능
                .requestMatchers("/api/employees/memo/**", "/employeememo/**").permitAll()
                
                // 관리자 전용 페이지
                .requestMatchers("/employeeregistration", "/employeelist", "/employeeedit").hasRole("ADMIN")
                .requestMatchers("/attendancelist", "/salary").hasRole("ADMIN")
                
                // 관리자 전용 API
                .requestMatchers("/api/employee/add/**", "/api/employee/update/**", "/api/employee/delete/**").hasRole("ADMIN")
                .requestMatchers("/api/attendance/list/**", "/api/salary/**").hasRole("ADMIN")
                
                // 그 외 모든 요청은 인증 필요
                .anyRequest().permitAll()
            )
            
            // 로그인 설정
            .formLogin(form -> form
                .defaultSuccessUrl("/home", true)
                .permitAll()
            )
            
            // 로그아웃 설정
            .logout(logout -> logout
                .logoutSuccessUrl("/home")
                .permitAll()
            )
            
            // 접근 거부 처리
            .exceptionHandling(ex -> ex
                .accessDeniedPage("/")
            );
        
        return http.build();
    }
    
    @Bean
    public InMemoryUserDetailsManager userDetailsManager() {
        UserDetails admin = User.builder()
            .username("kayoung6768")
            .password(passwordEncoder().encode("rkddl1109"))
            .roles("ADMIN")
            .build();
        
        return new InMemoryUserDetailsManager(admin);
    }
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}

    