package com.cafehr.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * API 응답을 위한 표준 DTO
 * 모든 컨트롤러에서 공통으로 사용하여 일관된 응답 형식 제공
 */
@Getter
@Setter
@NoArgsConstructor
public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;

    /**
     * 데이터 없는 성공 응답 생성
     * @param message 성공 메시지
     * @return 성공 응답 객체
     */
    public static ApiResponse<Void> success(String message) {
        ApiResponse<Void> response = new ApiResponse<>();
        response.setSuccess(true);
        response.setMessage(message);
        return response;
    }

    /**
     * 데이터 포함 성공 응답 생성
     * @param message 성공 메시지
     * @param data 응답 데이터
     * @return 성공 응답 객체
     */
    public static <T> ApiResponse<T> success(String message, T data) {
        ApiResponse<T> response = new ApiResponse<>();
        response.setSuccess(true);
        response.setMessage(message);
        response.setData(data);
        return response;
    }

    /**
     * 오류 응답 생성
     * @param message 오류 메시지
     * @return 오류 응답 객체
     */
    public static ApiResponse<Void> error(String message) {
        ApiResponse<Void> response = new ApiResponse<>();
        response.setSuccess(false);
        response.setMessage(message);
        return response;
    }
} 