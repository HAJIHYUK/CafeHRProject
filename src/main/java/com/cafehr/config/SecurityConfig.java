package com.cafehr.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())         // CSRF 보호 비활성화1
            .formLogin(form -> form.disable())    // 폼 로그인 비활성화
            .httpBasic(basic -> basic.disable())  // HTTP Basic 인증 비활성화
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/**").permitAll()    // "/" 로 시작하는 모든 요청 허용
                .anyRequest().authenticated()        // 나머지는 인증 필요
            );

        return http.build();
    }
}

