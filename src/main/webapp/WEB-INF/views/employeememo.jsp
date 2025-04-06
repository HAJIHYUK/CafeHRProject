<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CafeHR - 직원 메모 확인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/cafeHR.css" rel="stylesheet">
    <link href="/css/fontawesome.css" rel="stylesheet">
    <style>
        .memo-section {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .memo-section h2 {
            color: #343a40;
            margin-bottom: 20px;
            font-size: 24px;
            font-weight: 500;
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 10px;
        }
        
        .memo-box {
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            min-height: 200px;
            margin-bottom: 20px;
            font-size: 16px;
            line-height: 1.6;
            white-space: pre-wrap;
            word-wrap: break-word;
            overflow-wrap: break-word;
            word-break: break-all;
        }
        
        .employee-info {
            margin-bottom: 30px;
            padding: 15px;
            background-color: #e9f7fe;
            border-radius: 8px;
        }
        
        .employee-info .label {
            font-weight: bold;
            color: #0d6efd;
        }
        
        /* 로딩 스피너 스타일 */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        
        .loading-spinner {
            border: 6px solid #f3f3f3;
            border-top: 6px solid #3498db;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>직원 메모 확인</h1>
        
        <div id="alertContainer"></div>
        
        <div id="loadingOverlay" class="loading-overlay">
            <div class="loading-spinner"></div>
        </div>
        
        <div id="employeeInfoContainer" class="employee-info" style="display: none;">
            <div class="row">
                <div class="col-md-6">
                    <p><span class="label">사번:</span> <span id="employeeId"></span></p>
                    <p><span class="label">이름:</span> <span id="employeeName"></span></p>
                </div>
                <div class="col-md-6">
                    <p><span class="label">직급:</span> <span id="employeeRole"></span></p>
                    <p><span class="label">근무상태:</span> <span id="employeeStatus"></span></p>
                </div>
            </div>
        </div>
        
        <div class="memo-section">
            <h2><i class="fas fa-sticky-note"></i> 직원 메모</h2>
            <div class="memo-box" id="memoContent">
                <!-- 메모 내용이 여기에 표시됩니다 -->
            </div>
            
            <div class="text-center mt-4">
                <a href="/home" class="btn btn-primary">
                    <i class="fas fa-home"></i> 홈으로 돌아가기
                </a>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            // URL에서 직원 ID 추출
            const pathParts = window.location.pathname.split('/');
            const employeeId = pathParts[pathParts.length - 1];
            
            // 직원 정보 및 메모 로드
            loadEmployeeData(employeeId);
        });
        
        // 직원 데이터 로드 함수
        function loadEmployeeData(id) {
            // 로딩 오버레이 표시
            $('#loadingOverlay').show();
            
            $.ajax({
                url: '/api/employees/' + id,
                type: 'GET',
                success: function(employee) {
                    // 직원 정보 표시
                    $('#employeeId').text(employee.id);
                    $('#employeeName').text(employee.name);
                    $('#employeeRole').text(translateRole(employee.role));
                    $('#employeeStatus').text(employee.isActive ? '재직 중' : '퇴직');
                    $('#employeeInfoContainer').show();
                    
                    // 메모 표시
                    if (employee.memo) {
                        $('#memoContent').text(employee.memo);
                    } else {
                        $('#memoContent').html('<i>등록된 메모가 없습니다.</i>');
                    }
                    
                    // 로딩 오버레이 숨기기
                    $('#loadingOverlay').hide();
                },
                error: function(xhr, status, error) {
                    // 로딩 오버레이 숨기기
                    $('#loadingOverlay').hide();
                    
                    let errorMessage = '직원 정보를 불러오는데 실패했습니다.';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMessage += ' ' + xhr.responseJSON.message;
                    }
                    showAlert(errorMessage, 'danger');
                }
            });
        }
        
        // 역할 번역 함수
        function translateRole(role) {
            switch(role) {
                case 'ADMIN': return '관리자';
                case 'MANAGER': return '매니저';
                case 'STAFF': return '직원';
                default: return role;
            }
        }
        
        // 알림 표시 함수
        function showAlert(message, type) {
            const alertHtml = '<div class="alert alert-' + type + ' alert-dismissible fade show" role="alert">' +
                message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                '</div>';
            $('#alertContainer').html(alertHtml);
            
            // 3초 후 자동으로 사라지게 설정
            setTimeout(function() {
                $('.alert').alert('close');
            }, 3000);
        }
    </script>
</body>
</html> 