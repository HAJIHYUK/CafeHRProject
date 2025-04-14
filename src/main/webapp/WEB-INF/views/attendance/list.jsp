<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CafeHR - 출퇴근 기록 조회</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/cafeHR.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- FullCalendar 라이브러리 추가 -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/locales-all.min.js"></script>
    <!-- Flatpickr (달력) 라이브러리 추가 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
    <style>
        .search-box {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        /* 정렬 버튼 스타일 */
        .sort-buttons {
            margin-bottom: 10px;
        }
        
        .sort-buttons .btn {
            border-color: #ddd;
            color: #555;
            transition: all 0.2s;
        }
        
        .sort-buttons .btn:hover {
            border-color: #ff7f00;
            color: #ff7f00;
            background-color: rgba(255, 127, 0, 0.05);
        }
        
        .sort-buttons .btn i {
            color: #ff7f00;
        }
        
        /* 선택된 날짜 스타일 */
        .selected-date {
            background-color: #ff7f00 !important;
            color: white !important;
        }
        
        /* 요일 선택 버튼 스타일 */
        .btn-outline-primary {
            border-color: #ff7f00;
            color: #ff7f00;
        }
        
        .btn-outline-primary:hover, .btn-outline-primary:active, .btn-outline-primary:focus {
            background-color: #ff7f00;
            border-color: #ff7f00;
            color: white;
        }
        
        /* 월별 버튼 스타일 */
        .month-buttons {
            display: flex;
            flex-wrap: nowrap;
            gap: 10px;
            margin-bottom: 10px;
        }
        
        .month-buttons .btn {
            min-width: 80px;
            height: 40px; /* 버튼 세로 높이 지정 */
            padding: 4px 6px;
            font-size: 0.85rem;
        }
        
        .month-buttons .active {
            background-color: #ff7f00;
            border-color: #ff7f00;
            color: white;
        }
        
        /* 플랫픽커 테마 */
        .flatpickr-day.selected, 
        .flatpickr-day.startRange, 
        .flatpickr-day.endRange, 
        .flatpickr-day.selected.inRange, 
        .flatpickr-day.startRange.inRange, 
        .flatpickr-day.endRange.inRange, 
        .flatpickr-day.selected:focus, 
        .flatpickr-day.startRange:focus, 
        .flatpickr-day.endRange:focus, 
        .flatpickr-day.selected:hover, 
        .flatpickr-day.startRange:hover, 
        .flatpickr-day.endRange:hover, 
        .flatpickr-day.selected.prevMonthDay, 
        .flatpickr-day.startRange.prevMonthDay, 
        .flatpickr-day.endRange.prevMonthDay, 
        .flatpickr-day.selected.nextMonthDay, 
        .flatpickr-day.startRange.nextMonthDay, 
        .flatpickr-day.endRange.nextMonthDay {
            background: #ff7f00;
            border-color: #ff7f00;
        }
        
        .flatpickr-calendar.animate.open {
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border-radius: 10px;
        }
        
        /* 선택된 날짜 태그 스타일 */
        .selected-date-tag {
            display: inline-block;
            background-color: #ff7f00;
            color: white;
            padding: 5px 10px;
            margin: 5px;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .selected-date-tag .remove-date {
            margin-left: 8px;
            cursor: pointer;
        }
        
        /* 요일 빠른 선택 버튼 */
        .weekday-buttons {
            margin-top: 15px;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }
        
        .weekday-buttons .btn {
            margin-right: 5px;
            font-size: 0.85rem;
            padding: 0.375rem 0.75rem;
            line-height: 1.2;
            height: 31px;
        }
        
        .weekday-buttons .form-label {
            margin-bottom: 0;
            margin-right: 8px;
            line-height: 1.2;
            height: 31px;
            display: inline-flex;
            align-items: center;
            vertical-align: middle;
            padding-top: 1px;
        }
        
        /* 입력 폼 그룹 */
        .input-form-group {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        
        .input-form-group h5 {
            margin-bottom: 15px;
            color: #444;
            font-weight: 500;
        }
        
        /* 플랫픽커 테마 */
        .flatpickr-calendar.inline {
            margin: 0 auto;
            width: 100%;
            max-width: 325px;
        }
        
        /* 달력 컨테이너 스타일 */
        #datepicker-container {
            display: flex;
            justify-content: center;
            width: 100%;
        }
        
        /* 테이블 스타일 개선 */
        .table-responsive {
            overflow-x: auto;
            margin-bottom: 20px;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th {
            white-space: nowrap;
            padding: 12px 8px;
            vertical-align: middle;
            font-weight: 600;
        }
        
        .table td {
            padding: 10px 8px;
            vertical-align: middle;
        }
        
        /* 테이블 컬럼 너비 지정 */
        .table th:nth-child(1), .table td:nth-child(1) { width: 40px; }  /* 체크박스 */
        .table th:nth-child(2), .table td:nth-child(2) { width: 80px; }  /* 출근기록ID */
        .table th:nth-child(3), .table td:nth-child(3) { width: 100px; } /* 고유 사원번호 */
        .table th:nth-child(4), .table td:nth-child(4) { width: 100px; } /* 이름 */
        .table th:nth-child(5), .table td:nth-child(5) { width: 150px; } /* 출근시간 */
        .table th:nth-child(6), .table td:nth-child(6) { width: 150px; } /* 퇴근시간 */
        .table th:nth-child(7), .table td:nth-child(7) { width: 100px; } /* 총 근무시간 */
        .table th:nth-child(8), .table td:nth-child(8) { width: 100px; } /* 실제 근무시간 */
        .table th:nth-child(9), .table td:nth-child(9) { width: 100px; } /* 예상근무시간 */
        .table th:nth-child(10), .table td:nth-child(10) { width: 130px; } /* 관리 */
        
        /* 버튼 스타일 개선 */
        .btn-action {
            white-space: nowrap;
            padding: 4px 8px;
            font-size: 0.8rem;
            margin-right: 3px;
        }
        
        .action-buttons {
            display: flex;
            justify-content: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>출퇴근 기록 관리</h1>
        
        <div class="row mb-4">
            <div class="col-md-12 text-end">
                <button class="btn btn-success" onclick="openAddAttendanceModal()">
                    <i class="fas fa-plus-circle me-1"></i> 관리자 출근 기록 추가
                </button>
            </div>
        </div>
        
        <!-- 검색 조건 -->
        <div class="form-section">
            <h2><i class="fas fa-search"></i> 출퇴근 기록 검색</h2>
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label fw-bold">검색 유형</label>
                    <select class="form-control" id="searchType">
                        <option value="all">전체 기록</option>
                        <option value="employee">고유 사원번호</option>
                        <option value="name">직원이름</option>
                    </select>
                </div>
                <div class="col-md-3" id="employeeNameBox" style="display:none;">
                    <label class="form-label fw-bold">직원 이름</label>
                    <input type="text" class="form-control" id="employeeName">
                </div>
                <div class="col-md-3" id="employeeIdBox" style="display:none;">
                    <label class="form-label fw-bold">고유 사원번호</label>
                    <input type="number" class="form-control" id="employeeId">
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold">시작일</label>
                    <input type="date" class="form-control" id="startDate">
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold">종료일</label>
                    <input type="date" class="form-control" id="endDate">
                </div>
                <!-- 월별 빠른 선택 버튼 추가 -->
                <div class="col-md-12 mt-2">
                    <label class="form-label fw-bold">월별 빠른 선택</label>
                    <div class="month-buttons">
                        <button type="button" class="btn btn-outline-primary btn-sm month-btn" data-month="1">1월</button>
                        <button type="button" class="btn btn-outline-primary btn-sm month-btn" data-month="2">2월</button>
                        <button type="button" class="btn btn-outline-primary btn-sm month-btn" data-month="3">3월</button>
                        <button type="button" class="btn btn-outline-primary btn-sm month-btn" data-month="4">4월</button>
                        <button type="button" class="btn btn-outline-primary btn-sm month-btn" data-month="5">5월</button>
                        <button type="button" class="btn btn-outline-primary btn-sm month-btn" data-month="6">6월</button>
                        <button type="button" class="btn btn-outline-primary btn-sm month-btn" data-month="7">7월</button>
                        <button type="button" class="btn btn-outline-primary btn-sm month-btn" data-month="8">8월</button>
                        <button type="button" class="btn btn-outline-primary btn-sm month-btn" data-month="9">9월</button>
                        <button type="button" class="btn btn-outline-primary btn-sm month-btn" data-month="10">10월</button>
                        <button type="button" class="btn btn-outline-primary btn-sm month-btn" data-month="11">11월</button>
                        <button type="button" class="btn btn-outline-primary btn-sm month-btn" data-month="12">12월</button>
                    </div>
                </div>
                <div class="col-md-12 text-center mt-3">
                    <button class="btn btn-primary px-4" onclick="searchAttendance()">
                        <i class="fas fa-search me-1"></i> 검색
                    </button>
                    <button class="btn btn-info ms-2" id="updateActualWorkingHoursButton">
                        <i class="fas fa-clock"></i> 실제 근무시간 변경
                    </button>
                </div>
                <div class="col-md-12 text-end mt-2 sort-buttons">
                    <button class="btn btn-outline-secondary" onclick="sortAttendanceByCheckIn('asc', true)">
                        <i class="fas fa-sort-amount-down-alt me-1"></i> 출근시간 오름차순
                    </button>
                    <button class="btn btn-outline-secondary ms-2" onclick="sortAttendanceByCheckIn('desc', true)">
                        <i class="fas fa-sort-amount-down me-1"></i> 출근시간 내림차순
                    </button>
                </div>
            </div>
        </div>

        <!-- 결과 테이블 -->
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr class="text-center">
                        <th><input type="checkbox" id="selectAll" class="form-check-input"></th>
                        <th>출근기록ID</th>
                        <th>고유 사원번호</th>
                        <th>이름</th>
                        <th>출근시간</th>
                        <th>퇴근시간</th>
                        <th>총 근무시간</th>
                        <th>실제 근무시간</th>
                        <th>예상근무시간</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody id="attendanceList">
                </tbody>
            </table>
        </div>

        <div style="text-align: center; margin-top: 20px;">
            <a href="/home" class="home-link"><i class="fas fa-home"></i> 홈으로 돌아가기</a>
        </div>
    </div>
    
    <!-- 플로팅 홈 버튼 추가 -->
    <a href="/home" class="floating-home-btn" title="홈으로 이동">
        <i class="fas fa-home"></i>
    </a>
    
    <!-- 출퇴근 기록 수정 모달 -->
    <div class="modal fade" id="editAttendanceModal" tabindex="-1" aria-labelledby="editAttendanceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editAttendanceModalLabel">출퇴근 기록 수정</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editAttendanceForm">
                        <input type="hidden" id="editAttendanceId">
                        
                        <div class="mb-3">
                            <label class="form-label">고유 사원번호</label>
                            <input type="text" class="form-control" id="editEmployeeId" readonly>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">직원 이름</label>
                            <input type="text" class="form-control" id="editEmployeeName" readonly>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">출근 날짜</label>
                            <input type="date" class="form-control" id="editCheckInDate" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">출근 시간</label>
                            <input type="time" class="form-control" id="editCheckInTime" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">퇴근 날짜</label>
                            <input type="date" class="form-control" id="editCheckOutDate">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">퇴근 시간</label>
                            <input type="time" class="form-control" id="editCheckOutTime">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">총 근무시간 수정</label>
                            <div class="row">
                                <div class="col-6">
                                    <label class="form-label">시간</label>
                                    <input type="number" class="form-control" id="editTotalHours" min="0" step="1">
                                </div>
                                <div class="col-6">
                                    <label class="form-label">분</label>
                                    <input type="number" class="form-control" id="editTotalMinutes" min="0" max="59" step="1">
                                </div>
                            </div>
                            <div class="form-text">총 근무시간을 수정하면 출퇴근 시간에 관계없이 입력한 시간이 적용됩니다.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">실제 근무시간 수정</label>
                            <div class="row">
                                <div class="col-6">
                                    <label class="form-label">시간</label>
                                    <input type="number" class="form-control" id="editActualHours" min="0" step="1">
                                </div>
                                <div class="col-6">
                                    <label class="form-label">분</label>
                                    <input type="number" class="form-control" id="editActualMinutes" min="0" max="59" step="1">
                                </div>
                            </div>
                            <div class="form-text">실제 근무시간은 휴게시간이 제외된 순수 근무시간입니다.</div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" onclick="submitEditAttendance()">저장</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 관리자 출근 기록 추가 모달 -->
    <div class="modal fade" id="addAttendanceModal" tabindex="-1" aria-labelledby="addAttendanceModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addAttendanceModalLabel">관리자 출근 기록 추가</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addAttendanceForm">
                        <div class="input-form-group">
                            <h5><i class="fas fa-user"></i> 직원 정보</h5>
                            <div class="mb-3">
                                <label class="form-label">직원 선택 *</label>
                                <select class="form-control" id="employeeSelect" required>
                                    <option value="">직원을 선택해주세요</option>
                                    <!-- 직원 목록은 자바스크립트로 로드됨 -->
                                </select>
                                <input type="hidden" id="addEmployeeId">
                            </div>
                        </div>
                        
                        <div class="input-form-group">
                            <h5><i class="fas fa-calendar-alt"></i> 근무 날짜 선택</h5>
                            <div class="row">
                                <div class="col-md-12 text-center mb-3">
                                    <!-- 달력 중앙 배치 -->
                                    <div id="datepicker-container" class="d-flex justify-content-center"></div>
                                </div>
                            </div>
                            
                            <div class="weekday-buttons mb-3 d-flex justify-content-center align-items-center">
                                <span class="form-label pe-2" style="position: relative; top: 5px; left: 10px;">요일 빠른선택 :</span>
                                <button type="button" class="btn btn-outline-primary btn-sm" id="selectAllMondays">월요일</button>
                                <button type="button" class="btn btn-outline-primary btn-sm" id="selectAllTuesdays">화요일</button>
                                <button type="button" class="btn btn-outline-primary btn-sm" id="selectAllWednesdays">수요일</button>
                                <button type="button" class="btn btn-outline-primary btn-sm" id="selectAllThursdays">목요일</button>
                                <button type="button" class="btn btn-outline-primary btn-sm" id="selectAllFridays">금요일</button>
                                <button type="button" class="btn btn-outline-primary btn-sm" id="selectAllSaturdays">토요일</button>
                                <button type="button" class="btn btn-outline-primary btn-sm" id="selectAllSundays">일요일</button>
                                <button type="button" class="btn btn-outline-secondary btn-sm" id="clearDateSelection">선택 초기화</button>
                            </div>
                            
                            <div class="selected-dates-container mt-3">
                                <label class="form-label">선택된 날짜</label>
                                <div id="selectedDates" class="mt-2">
                                    <div class="text-muted">선택된 날짜가 없습니다.</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="input-form-group">
                            <h5><i class="fas fa-clock"></i> 근무 시간 설정</h5>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label">출근 시간 *</label>
                                    <input type="time" class="form-control" id="addCheckInTime" required>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">퇴근 시간</label>
                                    <input type="time" class="form-control" id="addCheckOutTime">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">총 근무시간 직접 입력</label>
                                <div class="row">
                                    <div class="col-6">
                                        <label class="form-label">시간</label>
                                        <input type="number" class="form-control" id="addTotalHours" min="0" step="1">
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label">분</label>
                                        <input type="number" class="form-control" id="addTotalMinutes" min="0" max="59" step="1">
                                    </div>
                                </div>
                                <div class="form-text">총 근무시간을 직접 입력하면 출퇴근 시간에 관계없이 입력한 시간이 적용됩니다.</div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">실제 근무시간 직접 입력</label>
                                <div class="row">
                                    <div class="col-6">
                                        <label class="form-label">시간</label>
                                        <input type="number" class="form-control" id="addActualHours" min="0" step="1">
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label">분</label>
                                        <input type="number" class="form-control" id="addActualMinutes" min="0" max="59" step="1">
                                    </div>
                                </div>
                                <div class="form-text">실제 근무시간은 휴게시간이 제외된 순수 근무시간입니다.</div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" onclick="submitAddAttendance()">저장</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 성공 알림 모달 -->
    <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #ff7f00; color: #fff; border-bottom: 1px solid #e67300;">
                    <h5 class="modal-title" id="successModalLabel"><i class="fas fa-check-circle"></i> <span id="successTitle">저장 완료</span></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center" style="padding: 20px; font-size: 18px;">
                    <p id="successMessage"></p>
                </div>
                <div class="modal-footer justify-content-center" style="border-top: none; padding: 15px 20px;">
                    <button type="button" class="btn btn-primary" id="confirmBtn" style="padding: 8px 20px; font-weight: 500; background-color: #ff7f00; border-color: #ff7f00; margin-right: 10px;">확인</button>
                    <button type="button" class="btn btn-secondary" id="cancelBtn" style="padding: 8px 20px; font-weight: 500; display: none;">취소</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 현재 표시 중인 출근 기록 데이터를 저장할 전역 변수
        let currentAttendanceData = [];
        
        // 페이지 로드 시 전체 직원 출근 기록 조회
        $(document).ready(function() {
            // 현재 날짜 설정
            setCurrentMonthDates();
            
            // 월별 버튼 이벤트 처리
            setupMonthButtons();
            
            // 현재 월 기준으로 데이터 불러오기 (전체 데이터 대신)
            searchAttendance();
            
            // 체크된 항목들의 실제 근무시간을 예상근무시간으로 변경하는 버튼 이벤트 등록
            $("#updateActualWorkingHoursButton").click(updateActualWorkingHours);
        });
        
        // 현재 월의 시작일과 종료일 설정
        function setCurrentMonthDates() {
            const today = new Date();
            const year = today.getFullYear();
            const month = today.getMonth() + 1;
            
            // 월의 첫날
            const firstDay = new Date(year, month - 1, 2);
            // 다음 달의 첫날에서 하루를 빼면 현재 월의 마지막 날
            const lastDay = new Date(year, month, 1);
            
            // YYYY-MM-DD 형식으로 변환
            const firstDayStr = firstDay.toISOString().split('T')[0];
            const lastDayStr = lastDay.toISOString().split('T')[0];
            
            // 입력 필드에 설정
            $('#startDate').val(firstDayStr);
            $('#endDate').val(lastDayStr);
            
            // 현재 월에 해당하는 버튼 활성화
            $(`.month-btn[data-month="\${month}"]`).addClass('active');
        }
        
        // 월별 버튼 설정
        function setupMonthButtons() {
            $('.month-btn').click(function() {
                const month = $(this).data('month');
                const year = new Date().getFullYear();
                
                // 모든 버튼의 활성화 상태 제거
                $('.month-btn').removeClass('active');
                // 클릭한 버튼 활성화
                $(this).addClass('active');
                
                // 해당 월의 첫날과 마지막 날 계산
                const firstDay = new Date(year, month - 1, 2);
                const lastDay = new Date(year, month, 1);
                
                // YYYY-MM-DD 형식으로 변환
                const firstDayStr = firstDay.toISOString().split('T')[0];
                const lastDayStr = lastDay.toISOString().split('T')[0];
                
                // 입력 필드에 설정
                $('#startDate').val(firstDayStr);
                $('#endDate').val(lastDayStr);
                
                // 자동으로 검색 실행
                searchAttendance();
            });
        }
        
        // 전체 직원 출근 기록 로드 함수 제거
        
        // 예상 근무시간 데이터 로드 함수 제거

        // 검색 유형에 따라 입력 필드 표시/숨김
        $('#searchType').change(function() {
            const type = $(this).val();
            $('#employeeNameBox').hide();
            $('#employeeIdBox').hide();
            
            if (type === 'employee') {
                $('#employeeIdBox').show();
            } else if (type === 'name') {
                $('#employeeNameBox').show();
            }
        });

        // 검색 실행
        function searchAttendance() {
            const type = $('#searchType').val();
            let startDate = $('#startDate').val();
            let endDate = $('#endDate').val();
            let url = '/api/attendance';
            
            // 시작일이 있고 종료일이 없는 경우 오늘 날짜를 종료일로 설정
            if (startDate && !endDate) {
                const today = new Date();
                endDate = today.getFullYear() + '-' + 
                        String(today.getMonth() + 1).padStart(2, '0') + '-' + 
                        String(today.getDate()).padStart(2, '0');
                $('#endDate').val(endDate); // UI에도 반영
            }
            
            // 날짜에 시간 추가 (시작일: 00:00:00, 종료일: 23:59:59)
            if (startDate) startDate += 'T00:00:00';
            if (endDate) endDate += 'T23:59:59';

            if (startDate && endDate) {
                if (type === 'employee') {
                    const employeeId = $('#employeeId').val();
                    if (!employeeId) {
                        alert('고유 사원번호를 입력해주세요.');
                        return;
                    }
                    url = '/api/attendance/' + employeeId + '/' + startDate + '/' + endDate;
                } else if (type === 'name') {
                    const name = $('#employeeName').val();
                    if (!name) {
                        alert('직원 이름을 입력해주세요.');
                        return;
                    }
                    // 부분 문자열 검색 API 사용
                    url = '/api/attendance/name-containing/' + encodeURIComponent(name) + '/' + startDate + '/' + endDate;
                } else {
                    url = '/api/attendance/date-range/' + startDate + '/' + endDate;
                }
            } else {
                if (type === 'employee') {
                    const employeeId = $('#employeeId').val();
                    if (!employeeId) {
                        alert('고유 사원번호를 입력해주세요.');
                        return;
                    }
                    
                    // 시작일만 있는 경우, 직원번호 + 날짜 범위 검색
                    if (startDate) {
                        url = '/api/attendance/' + employeeId + '/' + startDate + '/' + endDate;
                    } else {
                        url = '/api/attendance/' + employeeId;
                    }
                } else if (type === 'name') {
                    const name = $('#employeeName').val();
                    if (!name) {
                        alert('직원 이름을 입력해주세요.');
                        return;
                    }
                    
                    // 시작일만 있는 경우, 직원이름 + 날짜 범위 검색
                    if (startDate) {
                        url = '/api/attendance/name-containing/' + encodeURIComponent(name) + '/' + startDate + '/' + endDate;
                    } else {
                        url = '/api/attendance/name-containing/' + encodeURIComponent(name);
                    }
                } else if (startDate) {
                    // 전체 기록에서 시작일만 있는 경우
                    url = '/api/attendance/date-range/' + startDate + '/' + endDate;
                }
            }

            // 로딩 메시지 표시
            $('#attendanceList').html('<tr><td colspan="10" class="text-center py-3">데이터를 불러오는 중...</td></tr>');
            
            $.get(url)
                .done(function(data) {                    
                    // 전역 변수에 데이터 저장
                    currentAttendanceData = data;
                    
                    // 예상 근무시간 데이터 로드 후 출근 기록 표시
                    $.get('/api/work-schedule/expect-total-hours')
                        .done(function(expectData) {                            
                            // 예상 근무시간 데이터를 attendanceId 기준으로 매핑
                            const expectMap = {};
                            expectData.forEach(function(item) {
                                expectMap[item.attendanceId] = item.expectTotalHours;
                            });
                            
                            // 출근 기록 데이터에 예상 근무시간 추가
                            if (data) {
                                data.forEach(function(item) {
                                    item.expectTotalHours = expectMap[item.attendanceId] || 0;
                                });
                                
                                // 데이터 표시
                                displayAttendance(data);
                                
                                // 데이터가 있으면 자동으로 출근시간 오름차순 정렬
                                if (data.length > 0) {
                                    sortAttendanceByCheckIn('asc', false);
                                }
                            }
                        })
                        .fail(function(error) {
                            console.error('예상 근무시간 데이터 로드 실패:', error);
                            
                            // 예상 근무시간 없이 출근 기록만 표시
                            if (data) {
                                // 전역 변수에 데이터 저장
                                currentAttendanceData = data;
                                displayAttendance(data);
                                
                                // 데이터가 있으면 자동으로 출근시간 오름차순 정렬
                                if (data.length > 0) {
                                    sortAttendanceByCheckIn('asc', false);
                                }
                            }
                        });
                })
                .fail(function(error) {
                    alert('데이터를 불러오는데 실패했습니다.');
                    console.error(error);
                });
        }

        // 결과 표시
        function displayAttendance(data) {
            const tbody = $('#attendanceList');
            tbody.empty();
            
            if (data.length === 0) {
                const row = $('<tr>');
                row.append($('<td colspan="10" class="text-center py-3">').text('조회된 출퇴근 기록이 없습니다.'));
                tbody.append(row);
                return;
            }

            data.forEach(function(item, index) {
                const row = $('<tr class="text-center">');
                row.append($('<td>').html('<input type="checkbox" class="form-check-input attendance-checkbox">'));
                row.append($('<td>').text(item.attendanceId));
                row.append($('<td>').text(item.employeeId));
                row.append($('<td>').text(item.name));
                row.append($('<td>').text(formatDateTime(item.checkIn)));
                row.append($('<td>').text(formatDateTime(item.checkOut)));
                row.append($('<td>').text(formatWorkHours(item.totalHours)));
                row.append($('<td>').text(formatWorkHours(item.actualWorkingHours)));
                row.append($('<td>').text(formatWorkHours(item.expectTotalHours)));
                
                // 수정 버튼 추가
                const actionCell = $('<td>');
                const actionButtons = $('<div class="action-buttons">');
                
                const editBtn = $('<button class="btn btn-sm btn-primary btn-action">').html('<i class="fas fa-edit"></i> 수정');
                editBtn.click(function() {
                    openEditModal(item);
                });
                
                // 삭제 버튼 추가
                const deleteBtn = $('<button class="btn btn-sm btn-danger btn-action">').html('<i class="fas fa-trash"></i> 삭제');
                deleteBtn.click(function() {
                    confirmDeleteAttendance(item.attendanceId);
                });
                
                actionButtons.append(editBtn);
                actionButtons.append(deleteBtn);
                actionCell.append(actionButtons);
                row.append(actionCell);
                
                tbody.append(row);
            });

            // 전체 선택 체크박스 이벤트
            $('#selectAll').change(function() {
                $('.attendance-checkbox').prop('checked', $(this).prop('checked'));
            });

            // 개별 체크박스 이벤트
            $('.attendance-checkbox').change(function() {
                const allChecked = $('.attendance-checkbox:checked').length === $('.attendance-checkbox').length;
                $('#selectAll').prop('checked', allChecked);
            });
        }

        // 체크된 항목들의 총 근무시간을 예상근무시간으로 변경
        function updateSelectedWorkHours() {
            const selectedRows = $('.attendance-checkbox:checked').closest('tr');
            if (selectedRows.length === 0) {
                alert('변경할 항목을 선택해주세요.');
                return;
            }

            // 모달 설정
            $('#successTitle').text('총 근무시간 변경');
            $('#successMessage').text('선택한 ' + selectedRows.length + '개 항목의 총 근무시간을 예상 근무시간으로 변경하시겠습니까?');
            
            // 취소 버튼 표시 및 이벤트 설정
            $('#cancelBtn').show().off('click').on('click', function() {
                $('#successModal').modal('hide');
            });
            
            // 확인 버튼에 이벤트 리스너 설정
            $('#confirmBtn').off('click').on('click', function() {
                processWorkHoursUpdate(selectedRows);
            });
            
            // 엔터 키 이벤트 처리
            $(document).off('keydown.successModal').on('keydown.successModal', function(e) {
                if (e.key === 'Enter' && $('#successModal').is(':visible')) {
                    processWorkHoursUpdate(selectedRows);
                }
            });
            
            // 모달이 닫힐 때 이벤트 리스너 제거
            $('#successModal').off('hidden.bs.modal').on('hidden.bs.modal', function() {
                $(document).off('keydown.successModal');
            });
            
            // 성공 모달 표시
            $('#successModal').modal('show');
        }
        
        // 체크된 항목들의 실제 근무시간을 예상근무시간으로 변경
        function updateActualWorkingHours() {
            const selectedRows = $('.attendance-checkbox:checked').closest('tr');
            if (selectedRows.length === 0) {
                alert('변경할 항목을 선택해주세요.');
                return;
            }

            // 모달 설정
            $('#successTitle').text('실제 근무시간 변경');
            $('#successMessage').text('선택한 ' + selectedRows.length + '개 항목의 실제 근무시간을 예상 근무시간으로 변경하시겠습니까?');
            
            // 취소 버튼 표시 및 이벤트 설정
            $('#cancelBtn').show().off('click').on('click', function() {
                $('#successModal').modal('hide');
            });
            
            // 확인 버튼에 이벤트 리스너 설정
            $('#confirmBtn').off('click').on('click', function() {
                processActualWorkingHoursUpdate(selectedRows);
            });
            
            // 엔터 키 이벤트 처리
            $(document).off('keydown.successModal').on('keydown.successModal', function(e) {
                if (e.key === 'Enter' && $('#successModal').is(':visible')) {
                    processActualWorkingHoursUpdate(selectedRows);
                }
            });
            
            // 모달이 닫힐 때 이벤트 리스너 제거
            $('#successModal').off('hidden.bs.modal').on('hidden.bs.modal', function() {
                $(document).off('keydown.successModal');
            });
            
            // 성공 모달 표시
            $('#successModal').modal('show');
        }

        // 근무시간 업데이트 처리 함수
        function processWorkHoursUpdate(selectedRows) {
            $('#successModal').modal('hide');
            
            // 업데이트할 데이터 배열
            const updatePromises = [];
            
            selectedRows.each(function() {
                const row = $(this);
                const attendanceId = row.find('td:eq(1)').text(); // 출근기록ID
                const expectHoursText = row.find('td:eq(7)').text(); // 예상근무시간
                
                // 시간 텍스트 파싱 ("3시간 30분" -> 3.5)
                let totalHours = 0;
                if (expectHoursText !== '-') {
                    const hourMatch = expectHoursText.match(/(\d+)시간/);
                    const minuteMatch = expectHoursText.match(/(\d+)분/);
                    
                    const hours = hourMatch ? parseInt(hourMatch[1]) : 0;
                    const minutes = minuteMatch ? parseInt(minuteMatch[1]) : 0;
                    
                    totalHours = hours + (minutes / 60);
                }
                
                // 실제 근무시간 셀 업데이트 (UI 바로 반영)
                row.find('td:eq(6)').text(expectHoursText);
                
                // API 호출하여 근무시간 업데이트
                const updatePromise = $.ajax({
                    url: `/api/attendance/modify/\${attendanceId}`,
                    type: 'PUT',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        attendanceId: attendanceId,
                        totalHours: totalHours
                    })
                });
                
                updatePromises.push(updatePromise);
            });
            
            // 모든 업데이트가 완료되면
            Promise.all(updatePromises)
                .then(function() {
                    // 체크박스 초기화
                    $('.attendance-checkbox').prop('checked', false);
                    $('#selectAll').prop('checked', false);
                    
                    // 성공 메시지 모달 표시 - 약간의 지연 후 표시
                    setTimeout(function() {
                        // 모달 설정
                        $('#successTitle').text('업데이트 완료');
                        $('#successMessage').text('선택한 항목의 근무시간이 업데이트되었습니다.');
                        
                        // 취소 버튼 숨기기
                        $('#cancelBtn').hide();
                        
                        // 확인 버튼에 이벤트 리스너 설정
                        $('#confirmBtn').off('click').on('click', function() {
                            $('#successModal').modal('hide');
                        });
                        
                        // 엔터 키 이벤트 처리
                        $(document).off('keydown.successModal').on('keydown.successModal', function(e) {
                            if (e.key === 'Enter' && $('#successModal').is(':visible')) {
                                $('#successModal').modal('hide');
                            }
                        });
                        
                        // 모달이 닫힐 때 이벤트 리스너 제거
                        $('#successModal').off('hidden.bs.modal').on('hidden.bs.modal', function() {
                            $(document).off('keydown.successModal');
                        });
                        
                        // 성공 모달 표시
                        $('#successModal').modal('show');
                    }, 150);
                })
                .catch(function(error) {
                    alert('근무시간 업데이트 중 오류가 발생했습니다.');
                    console.error('업데이트 오류:', error);
                });
        }
        
        // 실제 근무시간 업데이트 처리 함수
        function processActualWorkingHoursUpdate(selectedRows) {
            $('#successModal').modal('hide');
            
            // 업데이트할 데이터 배열
            const updateDtoList = [];
            
            selectedRows.each(function() {
                const row = $(this);
                const attendanceId = row.find('td:eq(1)').text(); // 출근기록ID
                const expectHoursText = row.find('td:eq(8)').text(); // 예상근무시간
                
                // 시간 텍스트 파싱 ("3시간 30분" -> 3.5)
                let actualWorkingHours = 0;
                if (expectHoursText !== '-') {
                    const hourMatch = expectHoursText.match(/(\d+)시간/);
                    const minuteMatch = expectHoursText.match(/(\d+)분/);
                    
                    const hours = hourMatch ? parseInt(hourMatch[1]) : 0;
                    const minutes = minuteMatch ? parseInt(minuteMatch[1]) : 0;
                    
                    actualWorkingHours = hours + (minutes / 60);
                }
                
                // 실제 근무시간 셀 업데이트 (UI 바로 반영)
                row.find('td:eq(7)').text(expectHoursText);
                
                // 업데이트할 데이터 추가
                updateDtoList.push({
                    attendanceId: parseInt(attendanceId),
                    actualWorkingHours: actualWorkingHours
                });
            });
            
            // 일괄 API 호출
            $.ajax({
                url: '/api/attendance/update-actual-working-hours',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(updateDtoList),
                success: function() {
                    // 체크박스 초기화
                    $('.attendance-checkbox').prop('checked', false);
                    $('#selectAll').prop('checked', false);
                    
                    // 성공 메시지 모달 표시 - 약간의 지연 후 표시
                    setTimeout(function() {
                        // 모달 설정
                        $('#successTitle').text('업데이트 완료');
                        $('#successMessage').text('선택한 항목의 실제 근무시간이 업데이트되었습니다.');
                        
                        // 취소 버튼 숨기기
                        $('#cancelBtn').hide();
                        
                        // 확인 버튼에 이벤트 리스너 설정
                        $('#confirmBtn').off('click').on('click', function() {
                            $('#successModal').modal('hide');
                        });
                        
                        // 엔터 키 이벤트 처리
                        $(document).off('keydown.successModal').on('keydown.successModal', function(e) {
                            if (e.key === 'Enter' && $('#successModal').is(':visible')) {
                                $('#successModal').modal('hide');
                            }
                        });
                        
                        // 모달이 닫힐 때 이벤트 리스너 제거
                        $('#successModal').off('hidden.bs.modal').on('hidden.bs.modal', function() {
                            $(document).off('keydown.successModal');
                        });
                        
                        // 성공 모달 표시
                        $('#successModal').modal('show');
                    }, 150);
                },
                error: function(error) {
                    alert('실제 근무시간 업데이트 중 오류가 발생했습니다.');
                    console.error('업데이트 오류:', error);
                }
            });
        }

        // 성공 메시지 모달 표시 함수
        function showSuccessMessage(title, message) {
            // 모달 설정
            $('#successTitle').text(title);
            $('#successMessage').text(message);
            
            // 취소 버튼 숨기기
            $('#cancelBtn').hide();
            
            // 확인 버튼에 이벤트 리스너 설정
            $('#confirmBtn').off('click').on('click', function() {
                $('#successModal').modal('hide');
            });
            
            // 엔터 키 이벤트 처리
            $(document).off('keydown.successModal').on('keydown.successModal', function(e) {
                if (e.key === 'Enter' && $('#successModal').is(':visible')) {
                    $('#successModal').modal('hide');
                }
            });
            
            // 모달이 닫힐 때 이벤트 리스너 제거
            $('#successModal').off('hidden.bs.modal').on('hidden.bs.modal', function() {
                $(document).off('keydown.successModal');
            });
            
            // 성공 모달 표시
            $('#successModal').modal('show');
        }

        // 출근 기록 삭제 확인
        function confirmDeleteAttendance(attendanceId) {
            // 모달 설정
            $('#successTitle').text('삭제 확인');
            $('#successMessage').text('정말로 이 출근 기록을 삭제하시겠습니까?\n삭제된 기록은 복구할 수 없습니다.');
            
            // 취소 버튼 표시 및 이벤트 설정
            $('#cancelBtn').show().off('click').on('click', function() {
                $('#successModal').modal('hide');
            });
            
            // 확인 버튼에 이벤트 리스너 설정
            $('#confirmBtn').off('click').on('click', function() {
                processDelete(attendanceId);
            });
            
            // 엔터 키 이벤트 처리
            $(document).off('keydown.successModal').on('keydown.successModal', function(e) {
                if (e.key === 'Enter' && $('#successModal').is(':visible')) {
                    processDelete(attendanceId);
                }
            });
            
            // 모달이 닫힐 때 이벤트 리스너 제거
            $('#successModal').off('hidden.bs.modal').on('hidden.bs.modal', function() {
                $(document).off('keydown.successModal');
            });
            
            // 모달 표시
            $('#successModal').modal('show');
        }
        
        // 삭제 처리 함수
        function processDelete(attendanceId) {
            $('#successModal').modal('hide');
            deleteAttendance(attendanceId);
        }
        
        // 출근 기록 삭제 API 호출
        function deleteAttendance(attendanceId) {
            $.ajax({
                url: `/api/attendance/delete/\${attendanceId}`,
                type: 'DELETE',
                success: function(response) {
                    // 성공 메시지 모달 표시 - 약간의 지연 후 표시
                    setTimeout(function() {
                        // 모달 설정
                        $('#successTitle').text('삭제 완료');
                        $('#successMessage').text(response || '출근 기록이 삭제되었습니다.');
                        
                        // 취소 버튼 숨기기
                        $('#cancelBtn').hide();
                        
                        // 확인 버튼에 이벤트 리스너 설정
                        $('#confirmBtn').off('click').on('click', function() {
                            $('#successModal').modal('hide');
                            searchAttendance(); // 현재 검색 조건으로 다시 검색
                        });
                        
                        // 엔터 키 이벤트 처리
                        $(document).off('keydown.successModal').on('keydown.successModal', function(e) {
                            if (e.key === 'Enter' && $('#successModal').is(':visible')) {
                                $('#successModal').modal('hide');
                                searchAttendance(); // 현재 검색 조건으로 다시 검색
                            }
                        });
                        
                        // 모달이 닫힐 때 이벤트 리스너 제거
                        $('#successModal').off('hidden.bs.modal').on('hidden.bs.modal', function() {
                            $(document).off('keydown.successModal');
                        });
                        
                        // 성공 모달 표시
                        $('#successModal').modal('show');
                    }, 150); // 50ms 지연
                },
                error: function(xhr, status, error) {
                    let errorMessage = '출근 기록 삭제에 실패했습니다.';
                    try {
                        const response = JSON.parse(xhr.responseText);
                        if (response.message) {
                            errorMessage = response.message;
                        }
                    } catch (e) {
                        console.error('응답 파싱 오류:', e);
                    }
                    alert(errorMessage);
                }
            });
        }

        // 편집 모달 열기
        function openEditModal(attendance) {
            // 모달 내용 설정
            $('#editAttendanceId').val(attendance.attendanceId);
            $('#editEmployeeId').val(attendance.employeeId);
            $('#editEmployeeName').val(attendance.name);
            
            // 날짜와 시간 분리
            if (attendance.checkIn) {
                const checkInDateTime = parseDateTime(attendance.checkIn);
                if (checkInDateTime) {
                    $('#editCheckInDate').val(checkInDateTime.date);
                    $('#editCheckInTime').val(checkInDateTime.time);
                }
            }
            
            if (attendance.checkOut) {
                const checkOutDateTime = parseDateTime(attendance.checkOut);
                if (checkOutDateTime) {
                    $('#editCheckOutDate').val(checkOutDateTime.date);
                    $('#editCheckOutTime').val(checkOutDateTime.time);
                }
            }
            
            // 총 근무 시간을 시간과 분으로 분리하여 설정
            if (attendance.totalHours) {
                const hours = Math.floor(attendance.totalHours);
                const minutes = Math.round((attendance.totalHours - hours) * 60);
                
                $('#editTotalHours').val(hours);
                $('#editTotalMinutes').val(minutes);
            } else {
                $('#editTotalHours').val(0);
                $('#editTotalMinutes').val(0);
            }
            
            // 실제 근무 시간을 시간과 분으로 분리하여 설정
            if (attendance.actualWorkingHours) {
                const hours = Math.floor(attendance.actualWorkingHours);
                const minutes = Math.round((attendance.actualWorkingHours - hours) * 60);
                
                $('#editActualHours').val(hours);
                $('#editActualMinutes').val(minutes);
            } else {
                $('#editActualHours').val(0);
                $('#editActualMinutes').val(0);
            }
            
            // 모달 표시
            $('#editAttendanceModal').modal('show');
        }
        
        // 날짜 시간 문자열을 날짜와 시간 부분으로 분리
        function parseDateTime(dateTimeStr) {
            try {
                // 다양한 형식을 처리하기 위한 로직
                let date = new Date();
                
                // 배열 형식 처리 [year, month, day, hour, minute, ...]
                if (Array.isArray(dateTimeStr)) {
                    const year = dateTimeStr[0];
                    const month = dateTimeStr[1];
                    const day = dateTimeStr[2];
                    const hour = dateTimeStr.length > 3 ? dateTimeStr[3] : 0;
                    const minute = dateTimeStr.length > 4 ? dateTimeStr[4] : 0;
                    
                    date = new Date(year, month - 1, day, hour, minute);
                }
                // 문자열 형식 처리
                else if (typeof dateTimeStr === 'string') {
                    date = new Date(dateTimeStr);
                }
                // 객체 형식 처리 (LocalDateTime JSON)
                else if (typeof dateTimeStr === 'object' && dateTimeStr.year !== undefined) {
                    date = new Date(
                        dateTimeStr.year, 
                        dateTimeStr.monthValue - 1, 
                        dateTimeStr.dayOfMonth, 
                        dateTimeStr.hour || 0, 
                        dateTimeStr.minute || 0
                    );
                }
                
                if (isNaN(date.getTime())) {
                    console.error('날짜 변환 실패:', dateTimeStr);
                    return null;
                }
                
                // YYYY-MM-DD 형식의 날짜
                const dateStr = date.getFullYear() + '-' + 
                              String(date.getMonth() + 1).padStart(2, '0') + '-' + 
                              String(date.getDate()).padStart(2, '0');
                
                // HH:MM 형식의 시간
                const timeStr = String(date.getHours()).padStart(2, '0') + ':' + 
                              String(date.getMinutes()).padStart(2, '0');
                
                return {
                    date: dateStr,
                    time: timeStr
                };
                
            } catch (e) {
                console.error('날짜 파싱 오류:', e);
                return null;
            }
        }
        
        // 출근 기록 수정 제출
        function submitEditAttendance() {
            const attendanceId = $('#editAttendanceId').val();
            const checkInDate = $('#editCheckInDate').val();
            const checkInTime = $('#editCheckInTime').val();
            const checkOutDate = $('#editCheckOutDate').val();
            const checkOutTime = $('#editCheckOutTime').val();
            const totalHours = parseInt($('#editTotalHours').val() || 0);
            const totalMinutes = parseInt($('#editTotalMinutes').val() || 0);
            const actualHours = parseInt($('#editActualHours').val() || 0);
            const actualMinutes = parseInt($('#editActualMinutes').val() || 0);
            
            // 유효성 검사
            if (!checkInDate || !checkInTime) {
                alert('출근 날짜와 시간은 필수입니다.');
                return;
            }
            
            // 수정할 데이터 준비
            const data = {
                attendanceId: attendanceId
            };
            
            // 출근 시간이 있는 경우만 포함
            if (checkInDate && checkInTime) {
                data.checkIn = `\${checkInDate}T\${checkInTime}:00`;
            }
            
            // 퇴근 시간이 있는 경우만 포함
            if (checkOutDate && checkOutTime) {
                data.checkOut = `\${checkOutDate}T\${checkOutTime}:00`;
            }
            
            // 총 근무시간 계산 (0이어도 전송)
            data.totalHours = totalHours + (totalMinutes / 60);
            
            // 실제 근무시간 계산 (0이어도 전송)
            data.actualWorkingHours = actualHours + (actualMinutes / 60);
            
            // API 호출
            $.ajax({
                url: `/api/attendance/modify/\${attendanceId}`,
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function(response) {
                    // 성공 모달 설정
                    $('#successTitle').text('수정 완료');
                    $('#successMessage').text('출퇴근 기록이 수정되었습니다.');
                    
                    // 취소 버튼 숨기기
                    $('#cancelBtn').hide();
                    
                    // 모달 닫기 및 새로고침 함수 정의
                    const refreshPage = function() {
                        $('#editAttendanceModal').modal('hide');
                        searchAttendance(); // 현재 검색 조건으로 다시 검색
                    };
                    
                    // 확인 버튼에 이벤트 리스너 설정
                    $('#confirmBtn').off('click').on('click', function() {
                        refreshPage();
                        $('#successModal').modal('hide');
                    });
                    
                    // 엔터 키 이벤트 처리
                    $(document).on('keydown.successModal', function(e) {
                        if (e.key === 'Enter' && $('#successModal').is(':visible')) {
                            refreshPage();
                            $('#successModal').modal('hide');
                            $(document).off('keydown.successModal');
                        }
                    });
                    
                    // 모달이 닫힐 때 이벤트 리스너 제거
                    $('#successModal').on('hidden.bs.modal', function() {
                        $(document).off('keydown.successModal');
                        refreshPage();
                    });
                    
                    // 성공 모달 표시
                    $('#successModal').modal('show');
                },
                error: function(xhr, status, error) {
                    let errorMessage = '출퇴근 기록 수정에 실패했습니다.';
                    try {
                        const response = JSON.parse(xhr.responseText);
                        if (response.message) {
                            errorMessage = response.message;
                        }
                    } catch (e) {
                        console.error('응답 파싱 오류:', e);
                    }
                    alert(errorMessage);
                }
            });
        }

        // 근무시간 포맷팅
        function formatWorkHours(hours) {
            if (!hours) return '-';
            
            // 소수점 시간을 시간과 분으로 변환
            const hourPart = Math.floor(hours); // 정수 부분 (시간)
            const minutePart = Math.round((hours - hourPart) * 60); // 소수점 부분을 분으로 변환
            
            // 시간만 있는 경우
            if (hourPart > 0 && minutePart === 0) {
                return `\${hourPart}시간`;
            }
            // 분만 있는 경우
            else if (hourPart === 0 && minutePart > 0) {
                return `\${minutePart}분`;
            }
            // 시간과 분 모두 있는 경우
            else {
                return `\${hourPart}시간 \${minutePart}분`;
            }
        }

        // 날짜 포맷팅
        function formatDateTime(dateTime) {
            if (!dateTime) return '-';
            
            try {
                // Jackson이 LocalDateTime을 배열로 직렬화하는 경우: [2023, 5, 15, 14, 30, 0]
                if (Array.isArray(dateTime)) {
                    if (dateTime.length >= 3) {
                        const year = dateTime[0];
                        const month = dateTime[1];
                        const day = dateTime[2];
                        const hour = dateTime.length > 3 ? dateTime[3] : 0;
                        const minute = dateTime.length > 4 ? dateTime[4] : 0;
                        
                        return `\${year}-\${String(month).padStart(2, '0')}-\${String(day).padStart(2, '0')} \${String(hour).padStart(2, '0')}:\${String(minute).padStart(2, '0')}`;
                    }
                    return '-';
                }
                
                // 타임스탬프 또는 ISO 문자열인 경우
                let date;
                
                // 문자열 형식 (ISO 8601 등)
                if (typeof dateTime === 'string') {
                    date = new Date(dateTime);
                } 
                // 타임스탬프(숫자) 형식
                else if (typeof dateTime === 'number') {
                    date = new Date(dateTime);
                } 
                // 객체 형식 (Java의 LocalDateTime이 JSON으로 변환된 경우)
                else if (dateTime && typeof dateTime === 'object') {
                    // {year: 2023, monthValue: 5, dayOfMonth: 15, hour: 14, minute: 30} 형식
                    if (dateTime.year !== undefined && dateTime.monthValue !== undefined && dateTime.dayOfMonth !== undefined) {
                        return `\${dateTime.year}-\${String(dateTime.monthValue).padStart(2, '0')}-\${String(dateTime.dayOfMonth).padStart(2, '0')} \${String(dateTime.hour || 0).padStart(2, '0')}:\${String(dateTime.minute || 0).padStart(2, '0')}`;
                    }
                    return '-';
                } else {
                    return '-';
                }
                
                // 유효한 날짜인지 확인
                if (isNaN(date.getTime())) {
                    return '-';
                }
                
                return date.getFullYear() + '-' + 
                       String(date.getMonth() + 1).padStart(2, '0') + '-' + 
                       String(date.getDate()).padStart(2, '0') + ' ' + 
                       String(date.getHours()).padStart(2, '0') + ':' + 
                       String(date.getMinutes()).padStart(2, '0');
            } catch (error) {
                return '-';
            }
        }

        // 관리자 출근 기록 추가 모달 열기
        function openAddAttendanceModal() {
            // 초기화
            $('#employeeSelect').val('');
            $('#addEmployeeId').val('');
            $('#addCheckInTime').val('09:00'); // 기본 출근 시간
            $('#addCheckOutTime').val(''); // 퇴근 시간 기본값 제거
            $('#addTotalHours').val('');
            $('#addTotalMinutes').val('');
            $('#addActualHours').val('');
            $('#addActualMinutes').val('');
            
            // 날짜 선택 초기화
            window.selectedDates = [];
            updateSelectedDatesDisplay();
            
            // 직원 목록 로드
            loadEmployeeList();
            
            // flatpickr 초기화
            initDatepicker();
            
            // 모달 표시
            $('#addAttendanceModal').modal('show');
        }
        
        // 직원 목록 로드 함수
        function loadEmployeeList() {
            $.get('/api/employees')
                .done(function(employees) {
                    const select = $('#employeeSelect');
                    select.empty();
                    select.append('<option value="">직원을 선택해주세요</option>');
                    
                    employees.forEach(function(employee) {
                        // 퇴직한 직원(isActive가 false인 경우)은 제외
                        if (employee.isActive) {
                            select.append(`<option value="\${employee.id}" data-name="\${employee.name}">\${employee.name} (\${employee.id})</option>`);
                        }
                    });
                    
                    // 직원 선택 시 addEmployeeId 필드에 값 설정
                    select.on('change', function() {
                        $('#addEmployeeId').val($(this).val());
                    });
                })
                .fail(function(error) {
                    console.error('직원 목록 로드 실패:', error);
                    alert('직원 목록을 불러오는데 실패했습니다.');
                });
        }

        // 날짜 선택 초기화
        function initDatepicker() {
            // 이미 존재하는 flatpickr 인스턴스 제거
            if (window.datepickerInstance) {
                window.datepickerInstance.destroy();
            }
            
            window.selectedDates = [];
            
            // flatpickr 설정
            window.datepickerInstance = flatpickr("#datepicker-container", {
                mode: "multiple",
                dateFormat: "Y-m-d",
                locale: "ko",
                inline: true,
                showMonths: 1,
                prevArrow: '<i class="fas fa-chevron-left"></i>',
                nextArrow: '<i class="fas fa-chevron-right"></i>',
                onChange: function(selectedDates, dateStr, instance) {
                    window.selectedDates = selectedDates.map(date => {
                        const year = date.getFullYear();
                        const month = String(date.getMonth() + 1).padStart(2, '0');
                        const day = String(date.getDate()).padStart(2, '0');
                        return `\${year}-\${month}-\${day}`;
                    });
                    updateSelectedDatesDisplay();
                }
            });
            
            // 요일별 선택 버튼 이벤트
            $('#selectAllMondays').off('click').on('click', function() { selectAllSpecificWeekdays(1); });
            $('#selectAllTuesdays').off('click').on('click', function() { selectAllSpecificWeekdays(2); });
            $('#selectAllWednesdays').off('click').on('click', function() { selectAllSpecificWeekdays(3); });
            $('#selectAllThursdays').off('click').on('click', function() { selectAllSpecificWeekdays(4); });
            $('#selectAllFridays').off('click').on('click', function() { selectAllSpecificWeekdays(5); });
            $('#selectAllSaturdays').off('click').on('click', function() { selectAllSpecificWeekdays(6); });
            $('#selectAllSundays').off('click').on('click', function() { selectAllSpecificWeekdays(0); });
            
            // 선택 초기화 버튼 이벤트
            $('#clearDateSelection').off('click').on('click', function() {
                window.datepickerInstance.clear();
                window.selectedDates = [];
                updateSelectedDatesDisplay();
            });
        }

        // 선택된 날짜 표시 업데이트
        function updateSelectedDatesDisplay() {
            const container = $('#selectedDates');
            container.empty();
            
            if (window.selectedDates.length === 0) {
                container.html('<div class="text-muted">선택된 날짜가 없습니다.</div>');
                return;
            }
            
            // 날짜 정렬
            window.selectedDates.sort();
            
            // 날짜 태그 생성
            window.selectedDates.forEach(dateStr => {
                const date = new Date(dateStr);
                const dayNames = ['일', '월', '화', '수', '목', '금', '토'];
                const dayName = dayNames[date.getDay()];
                
                // 4월 17일 (월) 형식으로 표시
                const formattedDate = `\${date.getMonth() + 1}월 \${date.getDate()}일 (\${dayName})`;
                
                const dateTag = $(`
                    <div class="selected-date-tag">
                        \${formattedDate}
                        <span class="remove-date" data-date="\${dateStr}"><i class="fas fa-times"></i></span>
                    </div>
                `);
                
                container.append(dateTag);
            });
            
            // 날짜 삭제 이벤트
            $('.remove-date').off('click').on('click', function() {
                const dateToRemove = $(this).data('date');
                
                // selectedDates 배열에서 제거
                const index = window.selectedDates.indexOf(dateToRemove);
                if (index !== -1) {
                    window.selectedDates.splice(index, 1);
                }
                
                // flatpickr 인스턴스 날짜 선택 업데이트
                window.datepickerInstance.setDate(window.selectedDates);
                
                // 표시 업데이트
                updateSelectedDatesDisplay();
            });
        }

        // 특정 요일의 모든 날짜 선택
        function selectAllSpecificWeekdays(dayOfWeek) {
            // 현재 flatpickr에 표시된 월 정보 가져오기
            const currentMonth = window.datepickerInstance.currentMonth;
            const currentYear = window.datepickerInstance.currentYear;
            
            // 해당 월의 모든 날짜 검색
            const lastDay = new Date(currentYear, currentMonth + 1, 0).getDate();
            const newDates = [];
            
            // 이미 선택된 날짜 가져오기 (Date 객체 배열로)
            if (window.datepickerInstance.selectedDates && window.datepickerInstance.selectedDates.length > 0) {
                for (const date of window.datepickerInstance.selectedDates) {
                    newDates.push(new Date(date));
                }
            }
            
            // 선택된 요일에 해당하는 날짜만 추가
            for (let day = 1; day <= lastDay; day++) {
                const currentDate = new Date(currentYear, currentMonth, day);
                
                // 요일이 일치하는 경우
                if (currentDate.getDay() === dayOfWeek) {
                    // 이미 선택된 날짜인지 확인
                    let isAlreadySelected = false;
                    
                    for (const selectedDate of newDates) {
                        if (selectedDate.getFullYear() === currentDate.getFullYear() &&
                            selectedDate.getMonth() === currentDate.getMonth() &&
                            selectedDate.getDate() === currentDate.getDate()) {
                            isAlreadySelected = true;
                            break;
                        }
                    }
                    
                    // 아직 선택되지 않은 경우 추가
                    if (!isAlreadySelected) {
                        newDates.push(new Date(currentDate));
                    }
                }
            }
            
            // flatpickr 날짜 선택 업데이트
            window.datepickerInstance.setDate(newDates, true);
            
            // 선택된 날짜 표시 업데이트
            window.selectedDates = newDates.map(date => {
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                return `\${year}-\${month}-\${day}`;
            });
            
            updateSelectedDatesDisplay();
        }

        // 관리자 출근 기록 추가 제출
        function submitAddAttendance() {
            // 선택한 직원 ID
            const employeeId = $('#employeeSelect').val();
            if (!employeeId) {
                alert('직원을 선택해주세요.');
                return;
            }
            
            // 선택한 날짜들
            if (!window.selectedDates || window.selectedDates.length === 0) {
                alert('적어도 하나 이상의 날짜를 선택해주세요.');
                return;
            }
            
            const checkInTime = $('#addCheckInTime').val();
            const checkOutTime = $('#addCheckOutTime').val();
            const totalHours = parseInt($('#addTotalHours').val() || 0);
            const totalMinutes = parseInt($('#addTotalMinutes').val() || 0);
            const actualHours = parseInt($('#addActualHours').val() || 0);
            const actualMinutes = parseInt($('#addActualMinutes').val() || 0);
            
            // 유효성 검사
            if (!checkInTime) {
                alert('출근 시간은 필수입니다.');
                return;
            }
            
            // 모든 선택된 날짜에 대한 출근 기록 생성
            const attendanceList = [];
            
            window.selectedDates.forEach(function(dateStr) {
                // 출근 시간 생성 (날짜 + 시간)
                const checkInDateTime = `\${dateStr}T\${checkInTime}:00`;
                
                // 데이터 준비
                const attendanceData = {
                    employeeId: Number(employeeId),
                    checkIn: checkInDateTime
                };
                
                // 퇴근 시간이 있는 경우
                if (checkOutTime) {
                    const checkOutDateTime = `\${dateStr}T\${checkOutTime}:00`;
                    attendanceData.checkOut = checkOutDateTime;
                }
                
                // 근무 시간이 입력된 경우
                if (totalHours > 0 || totalMinutes > 0) {
                    const totalHoursValue = totalHours + (totalMinutes / 60);
                    attendanceData.totalHours = totalHoursValue;
                }
                
                // 실제 근무시간이 입력된 경우
                if (actualHours > 0 || actualMinutes > 0) {
                    const actualHoursValue = actualHours + (actualMinutes / 60);
                    attendanceData.actualWorkingHours = actualHoursValue;
                }
                
                attendanceList.push(attendanceData);
            });
            
            // API 호출
            $.ajax({
                url: '/api/attendance/check-in/admin/multiple',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(attendanceList),
                success: function(response) {
                    // 성공 모달 설정
                    $('#successTitle').text('추가 완료');
                    $('#successMessage').text(`선택한 직원의 출근 기록이 \${window.selectedDates.length}일에 대해 추가되었습니다.`);
                    
                    // 취소 버튼 숨기기
                    $('#cancelBtn').hide();
                    
                    // 모달 닫기 및 새로고침 함수 정의
                    const refreshPage = function() {
                        $('#addAttendanceModal').modal('hide');
                        searchAttendance(); // 현재 검색 조건으로 다시 검색
                    };
                    
                    // 확인 버튼에 이벤트 리스너 설정
                    $('#confirmBtn').off('click').on('click', function() {
                        refreshPage();
                        $('#successModal').modal('hide');
                    });
                    
                    // 엔터 키 이벤트 처리
                    $(document).on('keydown.successModal', function(e) {
                        if (e.key === 'Enter' && $('#successModal').is(':visible')) {
                            refreshPage();
                            $('#successModal').modal('hide');
                            $(document).off('keydown.successModal');
                        }
                    });
                    
                    // 모달이 닫힐 때 이벤트 리스너 제거
                    $('#successModal').on('hidden.bs.modal', function() {
                        $(document).off('keydown.successModal');
                        refreshPage();
                    });
                    
                    // 성공 모달 표시
                    $('#successModal').modal('show');
                },
                error: function(xhr, status, error) {
                    let errorMessage = '출근 기록 추가에 실패했습니다.';
                    try {
                        const response = JSON.parse(xhr.responseText);
                        if (response.message) {
                            errorMessage = response.message;
                        }
                    } catch (e) {
                        console.error('응답 파싱 오류:', e);
                    }
                    alert(errorMessage);
                }
            });
        }

        // 출근시간 정렬 함수
        function sortAttendanceByCheckIn(order, showMessage = true) {
            if (!currentAttendanceData || currentAttendanceData.length === 0) {
                // 데이터가 없을 때는 조용히 종료 (알림 제거)
                return;
            }
            
            // 데이터 복사본 만들기
            const sortedData = [...currentAttendanceData];
            
            // 출근시간 기준 정렬
            sortedData.sort(function(a, b) {
                // 출근시간이 없는 경우 처리
                if (!a.checkIn && !b.checkIn) return 0;
                if (!a.checkIn) return 1;
                if (!b.checkIn) return -1;
                
                // 출근시간 비교
                let dateTimeA, dateTimeB;
                
                // JSON 형식에 따른 날짜 변환
                if (Array.isArray(a.checkIn)) {
                    dateTimeA = new Date(a.checkIn[0], a.checkIn[1] - 1, a.checkIn[2], a.checkIn[3] || 0, a.checkIn[4] || 0);
                } else if (typeof a.checkIn === 'string') {
                    dateTimeA = new Date(a.checkIn);
                } else if (a.checkIn && a.checkIn.year) {
                    dateTimeA = new Date(a.checkIn.year, a.checkIn.monthValue - 1, a.checkIn.dayOfMonth, a.checkIn.hour || 0, a.checkIn.minute || 0);
                } else {
                    dateTimeA = new Date(0); // 기본값
                }
                
                if (Array.isArray(b.checkIn)) {
                    dateTimeB = new Date(b.checkIn[0], b.checkIn[1] - 1, b.checkIn[2], b.checkIn[3] || 0, b.checkIn[4] || 0);
                } else if (typeof b.checkIn === 'string') {
                    dateTimeB = new Date(b.checkIn);
                } else if (b.checkIn && b.checkIn.year) {
                    dateTimeB = new Date(b.checkIn.year, b.checkIn.monthValue - 1, b.checkIn.dayOfMonth, b.checkIn.hour || 0, b.checkIn.minute || 0);
                } else {
                    dateTimeB = new Date(0); // 기본값
                }
                
                // 오름차순/내림차순 정렬
                if (order === 'asc') {
                    return dateTimeA - dateTimeB;
                } else {
                    return dateTimeB - dateTimeA;
                }
            });
            
            // 정렬된 데이터 표시
            displayAttendance(sortedData);
            
            // 정렬 완료 메시지 (필요한 경우에만 표시)
            if (showMessage) {
                showSuccessMessage('정렬 완료', 
                    order === 'asc' ? '출근시간 오름차순으로 정렬되었습니다.' : '출근시간 내림차순으로 정렬되었습니다.');
            }
        }
    </script>
</body>
</html> 