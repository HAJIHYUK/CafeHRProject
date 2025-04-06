package com.cafehr.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import jakarta.servlet.DispatcherType;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    // 관리자 인증을 위한 필터 체인
    @Bean
    @Order(1)
    public SecurityFilterChain adminSecurityFilterChain(HttpSecurity http) throws Exception {
        http
            .securityMatcher(
                "/admin/**", 
                "/employee/**", 
                "/api/employee/add/**", 
                "/api/employee/update/**", 
                "/api/employee/delete/**", 
                "/api/attendance/list/**", 
                "/api/salary/**"
            )
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .anyRequest().hasRole("ADMIN")
            )
            .formLogin(form -> form
                // 기본 로그인 페이지 사용 (커스텀 로그인 페이지 지정 제거)
                .defaultSuccessUrl("/home", true)
                .permitAll()
            )
            .logout(logout -> logout
                .logoutSuccessUrl("/login?logout")
                .permitAll()
            );

        return http.build();
    }
    
    // 직원 기능 및 공통 리소스를 위한 필터 체인
    @Bean
    @Order(2)
    public SecurityFilterChain employeeSecurityFilterChain(HttpSecurity http) throws Exception {
        http
            .securityMatcher("/**")
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                // Forward 및 Include 타입 요청 허용
                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE).permitAll()
                // 정적 리소스 및 기본 페이지는 누구나 접근 가능
                .requestMatchers("/css/**", "/js/**", "/images/**").permitAll()
                .requestMatchers("/", "/home", "/login").permitAll()
                // JSP 파일 경로 접근 허용
                .requestMatchers("/WEB-INF/views/**").permitAll()
                // API 경로는 모두 인증 없이 접근 가능
                .requestMatchers("/api/**").permitAll()
                // 직원 출퇴근 및 메모 페이지도 접근 가능
                .requestMatchers("/api/attendance/check-in/**", "/api/attendance/check-out/**", "/employeememo/**").permitAll()
                // 그 외는 인증 필요
                .anyRequest().authenticated()
            )
            // 로그인 폼 설정 추가
            .formLogin(form -> form
                // 기본 로그인 페이지 사용
                .defaultSuccessUrl("/home", true)
                .permitAll()
            )
            // 접근 거부 처리 설정
            .exceptionHandling(ex -> ex
                .accessDeniedPage("/login") // 접근 거부시 로그인 페이지로 리다이렉트
            );

        return http.build();
    }

    @Bean
    public InMemoryUserDetailsManager userDetailsManager() {
        UserDetails admin = User.builder()
            .username("admin")
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

    