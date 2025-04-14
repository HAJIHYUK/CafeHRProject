<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CafeHR - 직원 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="/css/cafeHR.css" rel="stylesheet">
    <link href="/css/fontawesome.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            color: #333;
        }

        .container {
            max-width: 960px;
            margin: 30px auto;
            padding: 40px 15px 40px;
        }
        
        h1 {
            color: #343a40;
            text-align: center;
            margin-bottom: 30px;
            margin-top: 10px;
            font-weight: 600;
            position: relative;
            padding-bottom: 15px;
        }
        
        h1:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background-color: #ff9900;
            border-radius: 2px;
        }
        
        .form-section {
            background-color: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
        }
        
        .form-section h2 {
            color: #343a40;
            font-size: 1.5rem;
            margin-bottom: 20px;
            font-weight: 500;
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 10px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            border-radius: 8px;
            padding: 12px 15px;
            border: 1px solid #ced4da;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        
        .form-control:focus {
            border-color: #ff9900;
            box-shadow: 0 0 0 0.2rem rgba(255, 153, 0, 0.25);
        }
        
        .btn-primary {
            background-color: #ff9900;
            border-color: #ff9900;
            font-weight: 500;
            padding: 12px 25px;
            border-radius: 8px;
            transition: all 0.2s;
        }
        
        .btn-primary:hover {
            background-color: #e68a00;
            border-color: #e68a00;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
            font-weight: 500;
            padding: 12px 25px;
            border-radius: 8px;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #5a6268;
        }
        
        /* 결과 카드 스타일 */
        #result {
            margin-top: 30px;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            display: none;
            transition: all 0.3s ease;
        }

        #result.success {
            border-left: 5px solid #28a745;
            background-color: #f0fff4;
        }

        #result.error {
            border-left: 5px solid #dc3545;
            background-color: #fff5f5;
        }
        
        #result h3 {
            color: #343a40;
            margin-bottom: 15px;
            font-weight: 600;
            font-size: 1.4rem;
        }
        
        .error-message {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 5px;
            display: none;
        }

        /* 홈으로 링크 스타일 */
        .home-link {
            display: inline-block;
            margin-top: 20px;
            font-weight: 500;
            transition: all 0.3s;
            padding: 12px 25px;
            border-radius: 8px;
            background-color: #ff9900 !important;
            border-color: #ff9900 !important;
            color: white !important;
        }

        .home-link:hover {
            background-color: #e68a00 !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        /* 애니메이션 효과 */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .form-section, #result {
            animation: fadeIn 0.5s ease-out;
        }
        
        /* 근무 일정 모달 스타일 */
        .schedule-item {
            border: 1px solid #ddd;
            border-radius: 8px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .schedule-item .card-body {
            padding: 15px;
        }
        
        .modal-day-button {
            border-radius: 8px;
            transition: all 0.2s;
            font-weight: 500;
            padding: 8px 16px;
        }
        
        .modal-day-button.active {
            background-color: #ff9900;
            border-color: #ff9900;
            color: white;
        }
        
        .modal-day-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1><i class="fas fa-user-plus me-2"></i>직원 등록</h1>
        
        <div class="form-section">
            <h2><i class="fas fa-id-card me-2"></i>직원 기본 정보</h2>
        
        <form id="employeeForm">
                <div class="row">
                    <div class="col-md-6">
            <div class="form-group">
                            <label for="name" class="form-label">이름 <span class="text-danger">*</span></label>
                            <input type="text" id="name" name="name" class="form-control" placeholder="직원 이름을 입력하세요" required>
                            <div class="error-message" id="nameError"></div>
                        </div>
            </div>
            
                    <div class="col-md-6">
            <div class="form-group">
                            <label for="role" class="form-label">직급 <span class="text-danger">*</span></label>
                            <select id="role" name="role" class="form-control" required>
                                <option value="">직급 선택</option>
                                <option value="STAFF">직원</option>
                                <option value="MANAGER">매니저</option>
                                <option value="ADMIN">관리자</option>
                            </select>
                            <div class="error-message" id="roleError"></div>
                        </div>
                    </div>
            </div>
            
                <div class="row">
                    <div class="col-md-6">
            <div class="form-group">
                            <label for="hourlyWage" class="form-label">시급 (원) <span class="text-danger">*</span></label>
                            <input type="number" id="hourlyWage" name="hourlyWage" class="form-control" min="10030" placeholder="최저시급 10,030원 이상" required>
                            <small class="text-muted">2025년 최저시급 10,030원 이상으로 입력해주세요.</small>
                            <div class="error-message" id="hourlyWageError"></div>
                        </div>
            </div>
            
                    <div class="col-md-6">
            <div class="form-group">
                            <label for="password" class="form-label">비밀번호</label>
                            <input type="password" id="password" name="password" class="form-control" placeholder="비밀번호 입력 (선택사항)">
                            <small class="text-muted">직원 로그인용 비밀번호 (선택사항)</small>
                            <div class="error-message" id="passwordError"></div>
                        </div>
                    </div>
            </div>
            
            <div class="form-group">
                    <label for="memo" class="form-label">메모</label>
                    <textarea id="memo" name="memo" class="form-control" rows="3" placeholder="직원에 대한 추가 정보를 입력하세요 (선택사항)"></textarea>
                    <div class="error-message" id="memoError"></div>
            </div>
                
                <hr class="my-4">
            
                <div class="d-grid gap-2 mt-4">
                    <button type="button" id="submitBtn" class="btn btn-primary btn-lg">
                        <i class="fas fa-save me-2"></i>직원 등록하기
                    </button>
                </div>
        </form>
        </div>
        
        <div id="result">
            <h3><i class="fas fa-check-circle me-2"></i>직원 등록 완료</h3>
            <div id="resultContent" class="mb-4"></div>
            <div class="mt-3">
                <button id="registerScheduleBtn" class="btn btn-primary">
                    <i class="fas fa-calendar-plus me-2"></i>근무 일정 등록하기
                </button>
                <button id="addAnotherBtn" class="btn btn-secondary ms-2">
                    <i class="fas fa-plus me-2"></i>다른 직원 등록하기
                </button>
                <a href="/employeelist" class="btn btn-secondary ms-2">
                    <i class="fas fa-list me-2"></i>직원 목록 보기
                </a>
            </div>
        </div>
        
        <div style="text-align: center; margin-top: 30px; margin-bottom: 30px;">
            <a href="/home" class="btn home-link">
                <i class="fas fa-home me-2"></i>홈으로 돌아가기
            </a>
        </div>
    </div>

    <!-- 플로팅 홈 버튼 추가 -->
    <a href="/home" class="floating-home-btn" title="홈으로 이동">
        <i class="fas fa-home"></i>
    </a>

    <!-- 근무 일정 등록 모달 -->
    <div class="modal fade" id="scheduleModal" tabindex="-1" aria-labelledby="scheduleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="scheduleModalLabel">
                        <i class="fas fa-calendar-alt me-2"></i>근무 일정 등록
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="modalWorkScheduleForm">
                        <!-- 오류 메시지 표시 영역 -->
                        <div id="scheduleErrorContainer" class="alert alert-info mb-3">
                            <i class="fas fa-info-circle me-2"></i>직원 <b id="currentEmployeeName"></b>(ID: <span id="currentEmployeeId"></span>)의 근무 일정을 등록합니다.<br>
                            <small>요일을 선택하고 "근무 일정 추가" 버튼을 클릭하여 시간을 지정하세요.</small>
                        </div>
                        
                        <div class="mb-4">
                            <label style="display: block; margin-bottom: 10px; font-weight: 500;">요일 선택 <span class="text-danger">*</span></label>
                            <div class="d-flex flex-wrap gap-2 mb-3 day-buttons-container">
                                <button type="button" class="btn btn-outline-secondary modal-day-button" data-day="MONDAY">월</button>
                                <button type="button" class="btn btn-outline-secondary modal-day-button" data-day="TUESDAY">화</button>
                                <button type="button" class="btn btn-outline-secondary modal-day-button" data-day="WEDNESDAY">수</button>
                                <button type="button" class="btn btn-outline-secondary modal-day-button" data-day="THURSDAY">목</button>
                                <button type="button" class="btn btn-outline-secondary modal-day-button" data-day="FRIDAY">금</button>
                                <button type="button" class="btn btn-outline-secondary modal-day-button" data-day="SATURDAY">토</button>
                                <button type="button" class="btn btn-outline-secondary modal-day-button" data-day="SUNDAY">일</button>
                            </div>
                        </div>
                        
                        <div id="modalScheduleList" class="mb-4">
                            <!-- 여기에 근무 일정이 추가됩니다 -->
                        </div>
                        
                        <button type="button" id="modalAddScheduleBtn" class="btn btn-outline-primary mb-4">
                            <i class="fas fa-plus me-2"></i>근무 일정 추가
                        </button>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" id="saveScheduleBtn" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>일정 저장하기
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 선택된 요일 배열을 객체로 변경하여 각 요일별로 여러 일정을 저장할 수 있도록 함
        let selectedDays = {};
        
        $(document).ready(function() {
            // 초기화 시 근무 일정 등록 버튼 숨기기
            $('#registerScheduleBtn').hide();
            
            // 직원 등록 폼 제출 버튼 클릭 이벤트
            $('#submitBtn').click(function() {
                if (validateForm()) {
                    $(this).prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>처리 중...');
                    registerEmployee();
                }
            });
            
            // 다른 직원 등록 버튼 이벤트
            $('#addAnotherBtn').click(function() {
                resetForm();
                $('#result').fadeOut(300);
                $('#submitBtn').prop('disabled', false).html('<i class="fas fa-save me-2"></i>직원 등록하기');
            });
            
            // 근무 일정 등록 버튼 클릭 이벤트
            $('#registerScheduleBtn').click(function() {
                // 모달 초기화
                selectedDays = {};
                $('.modal-day-button').removeClass('active');
                $('#modalScheduleList').empty();
                
                // 현재 직원 정보 표시
                $('#currentEmployeeId').text(window.registeredEmployeeId);
                $('#currentEmployeeName').text(window.registeredEmployeeName || $('#name').val().trim());
                
                // 모달 표시
                $('#scheduleModal').modal('show');
            });
            
            // 모달 내 요일 버튼 클릭 이벤트
            $(document).on('click', '.modal-day-button', function() {
                const day = $(this).data('day');
                
                if ($(this).hasClass('active')) {
                    // 이미 선택되어 있으면 선택 해제
                    $(this).removeClass('active');
                    delete selectedDays[day];
                } else {
                    // 선택되어 있지 않으면 선택
                    $(this).addClass('active');
                    selectedDays[day] = [];
                }
            });
            
            // 모달 내 근무 일정 추가 버튼 이벤트
            $(document).on('click', '#modalAddScheduleBtn', function() {
                const activeDays = Object.keys(selectedDays);
                
                if (activeDays.length === 0) {
                    alert('먼저 근무 요일을 하나 이상 선택해주세요.');
                    return;
                }
                
                // 선택된 요일 목록 저장
                const selectedDaysCopy = {...selectedDays};
                
                // 일정 폼 추가
                addScheduleForm(selectedDaysCopy);
                
                // 요일 선택 초기화
                $('.modal-day-button').removeClass('active');
                selectedDays = {};
            });
            
            // 근무 일정 항목 삭제 버튼 이벤트
            $(document).on('click', '.remove-schedule', function() {
                $(this).closest('.schedule-item').remove();
            });
            
            // 모달 내 일정 저장 버튼 클릭 이벤트
            $('#saveScheduleBtn').click(function() {
                const scheduleItems = $('.schedule-item');
                
                if (scheduleItems.length === 0) {
                    alert('근무 일정을 하나 이상 추가해주세요.');
                    return;
                }
                
                const workSchedules = [];
                let isValid = true;
                
                scheduleItems.each(function() {
                    const startTime = $(this).find('.schedule-start-time').val();
                    const endTime = $(this).find('.schedule-end-time').val();
                    
                    if (!startTime || !endTime) {
                        alert('모든 시간을 입력해주세요.');
                        isValid = false;
                        return false; // jquery each 루프 종료
                    }
                    
                    if (startTime >= endTime) {
                        alert('종료 시간은 시작 시간보다 나중이어야 합니다.');
                        isValid = false;
                        return false; // jquery each 루프 종료
                    }
                    
                    // 저장된 요일 데이터 가져오기
                    let scheduleDays = [];
                    try {
                        const daysJson = $(this).find('.selected-days-data').val();
                        scheduleDays = JSON.parse(daysJson);
                    } catch (e) {
                        console.error('요일 데이터 파싱 오류:', e);
                    }
                    
                    if (scheduleDays.length === 0) {
                        alert('일정에 적용될 요일이 없습니다.');
                        isValid = false;
                        return false;
                    }
                    
                    // 각 요일별로 일정 생성
                    scheduleDays.forEach(day => {
                        const breakHoursInput = $(this).find('.schedule-break-hours');
                        const breakMinutesInput = $(this).find('.schedule-break-minutes');
                        
                        // 유효성 검사
                        const isHoursValid = validateBreakTime(breakHoursInput[0], 'hours');
                        const isMinutesValid = validateBreakTime(breakMinutesInput[0], 'minutes');
                        
                        if (!isHoursValid || !isMinutesValid) {
                            isValid = false;
                            return false; // 루프 종료
                        }
                        
                        const breakHours = parseInt(breakHoursInput.val() || 0);
                        const breakMinutes = parseInt(breakMinutesInput.val() || 0);
                        
                        // HH:MM 형식의 문자열로 변환 (백엔드의 LocalTime 형식에 맞춤)
                        const breakTime = (breakHours > 0 || breakMinutes > 0) ? 
                            String(breakHours).padStart(2, '0') + ':' + String(breakMinutes).padStart(2, '0') : null;
                        
                        workSchedules.push({
                            employeeId: window.registeredEmployeeId,
                            workDay: day,
                            startTime: startTime,
                            endTime: endTime,
                            breakTime: breakTime
                        });
                    });
                });
                
                if (!isValid) return;
                
                console.log('서버로 전송할 근무 일정:', workSchedules);
                
                // 근무 일정 등록 AJAX 요청
                $.ajax({
                    url: '/api/work-schedule',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(workSchedules),
                    success: function(response) {
                        alert("근무 일정이 등록완료되었습니다");
                        $('#scheduleModal').modal('hide');
                        
                        // 직원의 모든 근무 일정을 조회하는 API 호출
                        $.ajax({
                            url: '/api/work-schedule/list/' + window.registeredEmployeeId,
                            type: 'GET',
                            success: function(allSchedulesResponse) {
                                // 직원 정보 준비
                                const empData = {
                                    id: window.registeredEmployeeId,
                                    name: window.registeredEmployeeName || $('#name').val().trim(),
                                    role: $('#role').val(),
                                    hourlyWage: parseInt($('#hourlyWage').val())
                                };
                                
                                // 모든 일정 표시 (새로 추가된 일정 + 기존 일정)
                                displayEmployeeWithSchedules(empData, allSchedulesResponse);
                                
                                // 근무 일정 테이블이 보이도록 스크롤
                                setTimeout(function() {
                                    const tableElement = $('.table-responsive');
                                    if (tableElement.length) {
                                        $('html, body').animate({
                                            scrollTop: tableElement.offset().top - 70
                                        }, 300);
                                    }
                                }, 500);
                            },
                            error: function(xhr, status, error) {
                                console.error('모든 근무 일정 조회 실패:', error);
                                
                                // API 호출 실패 시 새로 등록된 일정만이라도 표시
                                const empData = {
                                    id: window.registeredEmployeeId,
                                    name: window.registeredEmployeeName || $('#name').val().trim(),
                                    role: $('#role').val(),
                                    hourlyWage: parseInt($('#hourlyWage').val())
                                };
                                
                                let scheduleData = [];
                                if (Array.isArray(response)) {
                                    scheduleData = response;
                                } else if (response && typeof response === 'object') {
                                    scheduleData = [response];
                                }
                                
                                displayEmployeeWithSchedules(empData, scheduleData);
                            }
                        });
                    },
                    error: function(xhr, status, error) {
                        console.error('근무 일정 등록 실패:', error);
                        let errorMessage = '근무 일정 등록에 실패했습니다.';
                        
                        try {
                            // 응답이 JSON 형식인 경우
                            if (xhr.responseJSON && xhr.responseJSON.message) {
                                errorMessage = xhr.responseJSON.message;
                            } 
                            // 응답 텍스트가 있는 경우
                            else if (xhr.responseText) {
                                try {
                                    const response = JSON.parse(xhr.responseText);
                                    if (response.message) {
                                        errorMessage = response.message;
                                    }
                                } catch (e) {
                                    // JSON 파싱 실패 - 서버 오류 메시지 그대로 표시
                                    if (xhr.responseText.includes('Exception')) {
                                        const startIndex = xhr.responseText.indexOf('Exception:');
                                        if (startIndex !== -1) {
                                            errorMessage = xhr.responseText.substring(startIndex + 10);
                                        } else {
                                            errorMessage = xhr.responseText;
                                        }
                                    }
                                }
                            }
                        } catch (e) { 
                            console.error('응답 파싱 오류:', e);
                        }
                        
                        // 기존 화면은 유지하고 알림창으로만 오류 메시지 표시
                        alert(errorMessage);
                        
                        // 모달은 닫지 않고 유지
                    }
                });
            });

            // 시간 유효성 검사 함수 추가
            window.validateBreakTime = function(input, type) {
                const value = parseInt(input.value) || 0;
                const errorElement = $(input).siblings('.break-' + type + '-error');
                let isValid = true;
                
                if (type === 'hours') {
                    if (value < 0 || value > 23) {
                        errorElement.show();
                        isValid = false;
                    } else {
                        errorElement.hide();
                    }
                } else if (type === 'minutes') {
                    if (value < 0 || value > 59) {
                        errorElement.show();
                        isValid = false;
                    } else {
                        errorElement.hide();
                    }
                }
                
                if (!isValid) {
                    // 잘못된 값이 입력되면 유효한 범위 내 값으로 설정
                    if (type === 'hours') {
                        input.value = Math.min(23, Math.max(0, value));
                    } else if (type === 'minutes') {
                        input.value = Math.min(59, Math.max(0, value));
                    }
                }
                
                return isValid;
            };
        });
        
        // 근무 일정 폼 추가 함수
        function addScheduleForm(selectedDaysCopy) {
            const scheduleId = 'schedule_' + Date.now();
            const activeDays = Object.keys(selectedDaysCopy);
            
            let scheduleHTML = '<div class="schedule-item card mb-3" id="' + scheduleId + '">';
            scheduleHTML += '<div class="card-body">';
            scheduleHTML += '<div class="d-flex justify-content-between align-items-center mb-3">';
            scheduleHTML += '<h5 class="card-title mb-0">근무 일정</h5>';
            scheduleHTML += '<button type="button" class="btn btn-sm btn-outline-danger remove-schedule"><i class="fas fa-trash"></i></button>';
            scheduleHTML += '</div>';
            
            scheduleHTML += '<div class="row">';
            scheduleHTML += '<div class="col-md-6">';
            scheduleHTML += '<div class="form-group">';
            scheduleHTML += '<label class="form-label">시작 시간 <span class="text-danger">*</span></label>';
            scheduleHTML += '<input type="time" class="form-control schedule-start-time" value="09:00" required>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            
            scheduleHTML += '<div class="col-md-6">';
            scheduleHTML += '<div class="form-group">';
            scheduleHTML += '<label class="form-label">종료 시간 <span class="text-danger">*</span></label>';
            scheduleHTML += '<input type="time" class="form-control schedule-end-time" value="18:00" required>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            
            scheduleHTML += '<div class="mt-3">';
            scheduleHTML += '<label class="form-label">휴게 시간</label>';
            scheduleHTML += '<div class="row">';
            scheduleHTML += '<div class="col-md-3">';
            scheduleHTML += '<div class="form-group">';
            scheduleHTML += '<label class="form-label">시간</label>';
            scheduleHTML += '<input type="number" class="form-control schedule-break-hours" min="0" max="23" step="1" value="0" onchange="validateBreakTime(this, \'hours\')">';
            scheduleHTML += '<div class="text-danger break-hours-error" style="display:none;">시간은 0-23 사이의 값만 입력 가능합니다.</div>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            scheduleHTML += '<div class="col-md-3">';
            scheduleHTML += '<div class="form-group">';
            scheduleHTML += '<label class="form-label">분</label>';
            scheduleHTML += '<input type="number" class="form-control schedule-break-minutes" min="0" max="59" step="1" value="30" onchange="validateBreakTime(this, \'minutes\')">';
            scheduleHTML += '<div class="text-danger break-minutes-error" style="display:none;">분은 0-59 사이의 값만 입력 가능합니다.</div>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            scheduleHTML += '<div class="form-text">휴게 시간을 입력하면 근무 시간 계산에 반영됩니다.</div>';
            scheduleHTML += '</div>';
            
            scheduleHTML += '<div class="mt-3">';
            scheduleHTML += '<label class="form-label">적용 요일</label>';
            scheduleHTML += '<div class="d-flex flex-wrap gap-2">';
            
            // 일정에 적용될 요일 데이터 속성 추가
            scheduleHTML += '<input type="hidden" class="selected-days-data" value=\'' + JSON.stringify(activeDays) + '\'>';
            
            activeDays.forEach(day => {
                const dayName = {
                    'MONDAY': '월',
                    'TUESDAY': '화',
                    'WEDNESDAY': '수',
                    'THURSDAY': '목',
                    'FRIDAY': '금',
                    'SATURDAY': '토',
                    'SUNDAY': '일'
                }[day];
                
                scheduleHTML += '<span class="badge bg-primary">' + dayName + '</span>';
            });
            
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            
            $('#modalScheduleList').append(scheduleHTML);
        }
        
        // 폼 유효성 검사 함수
        function validateForm() {
            let isValid = true;
            
            // 모든 에러 메시지 초기화
            $('.error-message').hide();
            $('input, select, textarea').removeClass('is-invalid');
            
            // 필수 필드 검사
            const requiredFields = ['name', 'hourlyWage', 'role'];
            requiredFields.forEach(function(field) {
                const value = $('#' + field).val().trim();
                if (!value) {
                    $('#' + field + 'Error').text('필수 항목입니다.').fadeIn(200);
                    $('#' + field).addClass('is-invalid');
                    isValid = false;
                } else {
                    $('#' + field + 'Error').hide();
                    $('#' + field).removeClass('is-invalid');
                }
            });
            
            // 시급 검사
            const hourlyWage = $('#hourlyWage').val();
            if (hourlyWage && hourlyWage < 10030) {
                $('#hourlyWageError').text('최저시급(10,030원) 이상이어야 합니다.').fadeIn(200);
                $('#hourlyWage').addClass('is-invalid');
                isValid = false;
            }
            
            return isValid;
        }
        
        // 직원 등록 함수
        function registerEmployee() {
            // 직원 기본 정보
            const employeeData = {
                    name: $('#name').val().trim(),
                    hourlyWage: parseInt($('#hourlyWage').val()),
                            role: $('#role').val(),
                password: $('#password').val().trim() || null,
                memo: $('#memo').val().trim() || null,
                isActive: true
            };
            
            // AJAX 요청 - 직원 등록
                $.ajax({
                url: '/api/employee/registration',
                    type: 'POST',
                    contentType: 'application/json',
                data: JSON.stringify(employeeData),
                    success: function(response) {
                    // 등록된 직원 정보 저장
                    window.registeredEmployeeId = response.id;
                    window.registeredEmployeeName = response.name;
                    
                    // 결과 표시 (showResult 함수 대신 직접 호출)
                    displayEmployeeWithSchedules(response, null);
                    $('#submitBtn').prop('disabled', false).html('<i class="fas fa-save me-2"></i>직원 등록하기');
                    
                    // 근무 일정 등록 버튼 표시
                    $('#registerScheduleBtn').show();
                },
                error: function(xhr, status, error) {
                    console.error('직원 등록 실패:', xhr.responseText);
                    let errorMessage = '직원 등록에 실패했습니다.';
                    
                    try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.message) {
                            errorMessage = response.message;
                        }
                    } catch (e) { }
                    
                    showResultError(errorMessage);
                    $('#submitBtn').prop('disabled', false).html('<i class="fas fa-save me-2"></i>직원 등록하기');
                    }
                });
            }
            
        // 직원 정보와 근무 일정을 표시하는 함수
        function displayEmployeeWithSchedules(employee, workSchedules) {
            if (!employee || !employee.id) {
                console.error('직원 정보가 유효하지 않습니다:', employee);
                alert('직원 정보를 불러올 수 없습니다. 페이지를 새로고침 해주세요.');
                return;
            }
            
            // 결과 영역 초기화
            $('#resultContent').empty();
            
            // 직원 정보 카드 생성
            let resultHTML = '<div class="card mb-4"><div class="card-body">';
            
            resultHTML += '<div class="row">';
            resultHTML += '<div class="col-md-6">';
            resultHTML += '<p><strong><i class="fas fa-id-badge me-2"></i>직원 ID:</strong> ' + (employee.id || '정보 없음') + '</p>';
            resultHTML += '<p><strong><i class="fas fa-user me-2"></i>이름:</strong> ' + (employee.name || '정보 없음') + '</p>';
            
            if (employee.role) {
                resultHTML += '<p><strong><i class="fas fa-user-tag me-2"></i>직급:</strong> ' + getReadableRole(employee.role) + '</p>';
            }
            
            resultHTML += '</div>';
            resultHTML += '<div class="col-md-6">';
            
            if (employee.hourlyWage) {
                resultHTML += '<p><strong><i class="fas fa-money-bill-wave me-2"></i>시급:</strong> ' + employee.hourlyWage.toLocaleString() + '원</p>';
            }
            
            // 현재 날짜 표시
            const now = new Date();
            const formattedDate = now.getFullYear() + '년 ' + (now.getMonth() + 1) + '월 ' + now.getDate() + '일';
            resultHTML += '<p><strong><i class="fas fa-calendar-check me-2"></i>등록일:</strong> ' + formattedDate + '</p>';
            
            resultHTML += '</div>';
            resultHTML += '</div>';
            
            // 근무 일정 표시
            if (Array.isArray(workSchedules) && workSchedules.length > 0) {
                resultHTML += '<hr>';
                resultHTML += '<h5 class="mt-3 mb-3" style="color: #ff9900; font-size: 1.3rem; font-weight: bold;"><i class="fas fa-calendar-alt me-2"></i>등록된 근무 일정</h5>';
                resultHTML += '<div class="table-responsive"><table class="table table-bordered" style="border: 2px solid #ff9900;">';
                resultHTML += '<thead style="background-color: #fff8ec;"><tr><th style="width: 25%;">요일</th><th style="width: 40%;">근무 시간</th><th>휴게 시간</th></tr></thead>';
                resultHTML += '<tbody>';
                
                const dayMap = {
                    'MONDAY': '월요일',
                    'TUESDAY': '화요일',
                    'WEDNESDAY': '수요일',
                    'THURSDAY': '목요일',
                    'FRIDAY': '금요일',
                    'SATURDAY': '토요일',
                    'SUNDAY': '일요일'
                };
                
                // 요일별로 그룹화
                const groupedSchedules = {};
                workSchedules.forEach(schedule => {
                    const day = schedule.workDay;
                    if (!day) {
                        console.error('일정에 요일 정보가 없습니다:', schedule);
                        return;
                    }
                    
                    if (!groupedSchedules[day]) {
                        groupedSchedules[day] = [];
                    }
                    groupedSchedules[day].push(schedule);
                });
                
                // 정렬된 요일 목록 생성
                const orderedDays = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY']
                    .filter(day => groupedSchedules[day]);
                
                // 요일별로 표시
                orderedDays.forEach(day => {
                    const schedules = groupedSchedules[day];
                    schedules.forEach((schedule, index) => {
                        resultHTML += '<tr>';
                        resultHTML += '<td style="font-weight: bold; vertical-align: middle;">' + dayMap[day] + '</td>';
                        
                        // 시작 시간과 종료 시간이 있는지 확인
                        if (schedule.startTime && schedule.endTime) {
                            // 시작 시간과 종료 시간이 배열인지 확인하고 적절히 처리
                            let startTimeStr, endTimeStr;
                            
                            if (Array.isArray(schedule.startTime)) {
                                // 배열인 경우 시간과 분을 추출하여 포맷팅
                                startTimeStr = schedule.startTime[0].toString().padStart(2, '0') + 
                                             ':' + 
                                             schedule.startTime[1].toString().padStart(2, '0');
                            } else {
                                // 문자열인 경우 처음 5자리만 사용
                                startTimeStr = schedule.startTime.substring(0, 5);
                            }
                            
                            if (Array.isArray(schedule.endTime)) {
                                // 배열인 경우 시간과 분을 추출하여 포맷팅
                                endTimeStr = schedule.endTime[0].toString().padStart(2, '0') + 
                                           ':' + 
                                           schedule.endTime[1].toString().padStart(2, '0');
                            } else {
                                // 문자열인 경우 처음 5자리만 사용
                                endTimeStr = schedule.endTime.substring(0, 5);
                            }
                            
                            resultHTML += '<td><i class="far fa-clock me-2" style="color: #ff9900;"></i>' + 
                                startTimeStr + ' ~ ' + 
                                endTimeStr + '</td>';
                        } else {
                            resultHTML += '<td>시간 정보 없음</td>';
                        }
                        
                        // 휴게시간 표시 추가
                        resultHTML += '<td>';
                        if (schedule.breakTime) {
                            let breakTimeStr;
                            
                            if (Array.isArray(schedule.breakTime)) {
                                // 배열인 경우 시간과 분을 추출하여 포맷팅
                                const hours = schedule.breakTime[0] || 0;
                                const minutes = schedule.breakTime[1] || 0;
                                
                                if (hours > 0 || minutes > 0) {
                                    breakTimeStr = '';
                                    if (hours > 0) breakTimeStr += hours + '시간 ';
                                    if (minutes > 0) breakTimeStr += minutes + '분';
                                } else {
                                    breakTimeStr = '없음';
                                }
                            } else if (typeof schedule.breakTime === 'string') {
                                // 문자열인 경우 (HH:MM 형식)
                                const parts = schedule.breakTime.split(':');
                                if (parts.length >= 2) {
                                    const hours = parseInt(parts[0]);
                                    const minutes = parseInt(parts[1]);
                                    
                                    if (hours > 0 || minutes > 0) {
                                        breakTimeStr = '';
                                        if (hours > 0) breakTimeStr += hours + '시간 ';
                                        if (minutes > 0) breakTimeStr += minutes + '분';
                                    } else {
                                        breakTimeStr = '없음';
                                    }
                                } else {
                                    breakTimeStr = schedule.breakTime;
                                }
                            } else {
                                breakTimeStr = '없음';
                            }
                            
                            resultHTML += '<i class="fas fa-coffee me-2" style="color: #ff9900;"></i>' + breakTimeStr;
                        } else {
                            resultHTML += '<i class="fas fa-coffee me-2" style="color: #ff9900;"></i>없음';
                        }
                        resultHTML += '</td>';
                        
                        resultHTML += '</tr>';
                    });
                });
                
                resultHTML += '</tbody></table></div>';
                resultHTML += '<div class="alert alert-success mt-3"><i class="fas fa-check-circle me-2"></i>근무 일정이 성공적으로 등록되었습니다.</div>';
            } else {
                // 근무 일정이 없을 경우 메시지 표시
                resultHTML += '<div class="alert alert-warning mt-3"><i class="fas fa-exclamation-triangle me-2"></i>등록된 근무 일정이 없습니다.</div>';
            }
            
            resultHTML += '</div></div>';
            
            // HTML 삽입
            $('#resultContent').html(resultHTML);
            
            // 결과 영역 표시
            $('#result').hide().removeClass('error').addClass('success').fadeIn(500);
            
            // 입력 폼 초기화
            $('#employeeForm')[0].reset();
            
            // 성공 시 상단으로 스크롤
            $('html, body').animate({
                scrollTop: $('#result').offset().top - 70
            }, 300);
        }
        
        // 오류 결과 표시 함수
        function showResultError(message) {
            const resultHTML = '<div class="alert alert-danger">' +
                '<i class="fas fa-exclamation-circle me-2"></i>' +
                message +
                '</div>';
            
            $('#resultContent').html(resultHTML);
            $('#result h3').html('<i class="fas fa-times-circle me-2"></i>직원 등록 실패');
            $('#result').hide().removeClass('success').addClass('error').fadeIn(500);
            
            // 오류 시 상단으로 스크롤
            $('html, body').animate({
                scrollTop: $('#result').offset().top - 100
            }, 500);
        }
        
        // 폼 초기화 함수
        function resetForm() {
            $('#employeeForm')[0].reset();
            $('.error-message').hide();
            $('input, select, textarea').removeClass('is-invalid');
            
            // 근무 일정 등록 버튼 숨기기
            $('#registerScheduleBtn').hide();
        }
        
        // 직급명 읽기 쉽게 변환
        function getReadableRole(role) {
            const roleMap = {
                'STAFF': '직원',
                'MANAGER': '매니저',
                'ADMIN': '관리자',
                'OWNER': '대표'
            };
            return roleMap[role] || role;
        }
    </script>
</body>
</html> 