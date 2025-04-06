<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CafeHR - 직원 정보 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/cafeHR.css" rel="stylesheet">
    <link href="/css/fontawesome.css" rel="stylesheet">
    <style>
        .form-section {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .form-section h2 {
            color: #343a40;
            margin-bottom: 20px;
            font-size: 24px;
            font-weight: 500;
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 10px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-color: #c3e6cb;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        
        .memo-container {
            width: 100%;
            margin-top: 15px;
        }
        
        #memo {
            min-height: 150px;
            width: 100%;
            padding: 12px;
            font-size: 16px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            resize: vertical;
        }
        
        /* 로딩 스피너 스타일 */
        .loading-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            display: flex;
            justify-content: center;
            align-items: center;
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
        
        .loading-text {
            display: none;
        }
        
        /* 모달 스타일 개선 */
        .modal-dialog {
            display: flex;
            align-items: center;
            min-height: calc(100% - 3.5rem);
        }
        
        .modal-content {
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
            border: none;
        }
        
        .modal-header {
            background-color: #ff7f00;
            color: #fff;
            border-bottom: 1px solid #e67300;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            padding: 15px 20px;
        }
        
        .modal-body {
            padding: 20px;
            font-size: 18px;
        }
        
        .modal-footer {
            border-top: none;
            padding: 15px 20px;
        }
        
        #goToListBtn {
            padding: 8px 20px;
            font-weight: 500;
            background-color: #ff7f00;
            border-color: #ff7f00;
        }
        
        #goToListBtn:hover {
            background-color: #e67300;
            border-color: #e67300;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>직원 정보 수정</h1>
        
        <div id="alertContainer"></div>
        
        <!-- 성공 모달 -->
        <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true" data-bs-backdrop="static">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="successModalLabel"><i class="fas fa-check-circle"></i> 저장 완료</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center">
                        <p>저장되었습니다. 직원 정보 수정이 완료되었습니다.</p>
                    </div>
                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-primary" id="goToListBtn">확인</button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="form-section position-relative">
            <div id="loadingOverlay" class="loading-overlay" style="display: none;">
                <div class="loading-spinner"></div>
            </div>
            
            <h2><i class="fas fa-user-edit"></i> 직원 기본 정보</h2>
            
            <form id="employeeForm">
                <input type="hidden" id="employeeId">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="name">이름 *</label>
                        <input type="text" id="name" class="form-control" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="role">직급 *</label>
                        <select id="role" class="form-control" required>
                            <option value="">선택하세요</option>
                            <option value="ADMIN">관리자</option>
                            <option value="MANAGER">매니저</option>
                            <option value="STAFF">직원</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="hourlyWage">시급 (원) *</label>
                        <input type="number" id="hourlyWage" class="form-control" min="9620" required>
                        <small class="text-muted">최저시급(9,620원) 이상으로 입력해주세요.</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="isActive">근무 상태 *</label>
                        <select id="isActive" class="form-control" required>
                            <option value="true">재직 중</option>
                            <option value="false">퇴직</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="password">비밀번호 변경</label>
                        <input type="password" id="password" class="form-control" placeholder="변경시에만 입력하세요">
                        <small class="text-muted">변경하지 않으려면 빈칸으로 두세요.</small>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group memo-container">
                        <label for="memo"><i class="fas fa-sticky-note"></i> 직원 메모</label>
                        <textarea id="memo" class="form-control" rows="8"></textarea>
                        <small class="text-muted">직원에 대한 중요 메모나 특이사항을 기록하세요.</small>
                    </div>
                </div>
                
                <div class="text-center mt-4">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> 저장하기
                    </button>
                    <a href="/employeelist" class="btn btn-secondary ms-2">
                        <i class="fas fa-arrow-left"></i> 목록으로 돌아가기
                    </a>
                </div>
            </form>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            // URL에서 직원 ID 추출
            const pathParts = window.location.pathname.split('/');
            const employeeId = pathParts[pathParts.length - 1];
            
            // 직원 정보 로드
            loadEmployeeData(employeeId);
            
            // 폼 제출 이벤트
            $('#employeeForm').submit(function(e) {
                e.preventDefault();
                
                // 필수 필드 검증
                if (!$('#name').val().trim()) {
                    showAlert('이름을 입력해주세요.', 'danger');
                    return;
                }
                
                if (!$('#role').val()) {
                    showAlert('직급을 선택해주세요.', 'danger');
                    return;
                }
                
                if (!$('#hourlyWage').val() || $('#hourlyWage').val() < 9620) {
                    showAlert('시급은 최저시급(9,620원) 이상으로 입력해주세요.', 'danger');
                    return;
                }
                
                // 폼 데이터 수집
                const id = $('#employeeId').val();
                const employeeData = {
                    name: $('#name').val().trim(),
                    role: $('#role').val(),
                    hourlyWage: $('#hourlyWage').val(),
                    isActive: $('#isActive').val() === 'true',
                    memo: $('#memo').val().trim()
                };
                
                // 비밀번호가 입력된 경우에만 추가
                const password = $('#password').val();
                if (password) {
                    employeeData.password = password;
                }
                
                // API 호출
                $('#loadingOverlay').show(); // 저장 시작할 때 로딩 표시
                
                $.ajax({
                    url: '/api/employees/modify/' + id,
                    type: 'PUT',
                    contentType: 'application/json',
                    data: JSON.stringify(employeeData),
                    success: function(response) {
                        // 로딩 오버레이 숨기기
                        $('#loadingOverlay').hide();
                        
                        // 성공 모달 표시
                        $('#successModal').modal('show');
                        
                        // 엔터 키 이벤트 리스너 추가
                        $(document).on('keydown.successModal', function(e) {
                            if (e.key === 'Enter' && $('#successModal').is(':visible')) {
                                $('#goToListBtn').click();
                                $(document).off('keydown.successModal');
                            }
                        });
                        
                        // 확인 버튼 클릭 시 목록 페이지로 이동
                        $('#goToListBtn').click(function() {
                            $(document).off('keydown.successModal');
                            window.location.href = '/employeelist';
                        });
                        
                        // 모달이 닫힐 때 이벤트 리스너 제거
                        $('#successModal').on('hidden.bs.modal', function() {
                            $(document).off('keydown.successModal');
                        });
                    },
                    error: function(xhr, status, error) {
                        $('#loadingOverlay').hide();
                        let errorMessage = '저장 실패';
                        if (xhr.responseJSON && xhr.responseJSON.message) {
                            errorMessage += ' ' + xhr.responseJSON.message;
                        }
                        showAlert(errorMessage, 'danger');
                    }
                });
            });
            
            // 직원 데이터 로드 함수
            function loadEmployeeData(id) {
                // 로딩 오버레이 표시
                $('#loadingOverlay').show();
                
                $.ajax({
                    url: '/api/employees/' + id,
                    type: 'GET',
                    success: function(employee) {
                        // 폼에 데이터 채우기
                        $('#employeeId').val(employee.id);
                        $('#name').val(employee.name);
                        $('#role').val(employee.role);
                        $('#hourlyWage').val(employee.hourlyWage);
                        $('#isActive').val(employee.isActive ? 'true' : 'false');
                        $('#memo').val(employee.memo);
                        
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
        });
    </script>
</body>
</html>