<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb" autoFlush="true"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CafeHR - 직원 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/cafeHR.css" rel="stylesheet">
    <link href="/css/fontawesome.css" rel="stylesheet">
    <style>
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
            display: inline-block;
            white-space: nowrap;
        }

        .status-active {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .status-inactive {
            background-color: #ffebee;
            color: #c62828;
        }

        .role-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
        }

        .role-admin {
            background-color: #e3f2fd;
            color: #1565c0;
        }

        .role-manager {
            background-color: #f3e5f5;
            color: #7b1fa2;
        }

        .role-staff {
            background-color: #fff3e0;
            color: #ef6c00;
        }

        .memo-text {
            max-width: 150px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: pointer;
            display: inline-block;
        }
        
        .memo-edit-icon {
            cursor: pointer;
            margin-left: 5px;
            color: #6c757d;
        }
        
        .memo-edit-icon:hover {
            color: #0d6efd;
        }
        
        .memo-modal .modal-body textarea {
            min-height: 200px;
            font-size: 16px;
            line-height: 1.5;
            padding: 15px;
            resize: vertical;
            border-color: #ced4da;
        }
        
        .memo-modal .modal-body textarea:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(255, 127, 0, 0.25);
        }

        /* 추가된 스타일 */
        .schedule-day-row {
            background-color: #f8f9fa;
        }

        .schedule-time-badge {
            background-color: #e6f7ff;
            color: #0066cc;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 13px;
            margin-right: 5px;
            display: inline-block;
        }

        /* 요일 선택 버튼 스타일 */
        .day-button {
            border-radius: 8px;
            transition: all 0.2s;
            font-weight: 500;
            padding: 8px 16px;
            margin: 0 5px 5px 0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            min-width: 45px;
            cursor: pointer;
        }

        .day-button.active {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            font-weight: bold;
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(255, 153, 0, 0.3);
        }

        .day-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.15);
        }

        .schedule-item {
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            padding: 20px;
            background-color: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: all 0.3s;
            position: relative;
        }

        .schedule-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
            transform: translateY(-2px);
        }

        .schedule-item .card-title {
            font-size: 1.1rem;
            color: #343a40;
            font-weight: 600;
        }

        .schedule-item .btn-outline-danger {
            padding: 5px 10px;
            font-size: 0.8rem;
            border-radius: 6px;
        }

        #scheduleErrorContainer {
            margin-top: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(220, 53, 69, 0.2);
        }
        
        .schedule-section {
            background-color: #f9f9f9;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            border: 1px solid #eaeaea;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        
        .schedule-section:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .schedule-section-title {
            font-weight: 600;
            color: #343a40;
            margin-bottom: 15px;
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 8px;
            display: inline-block;
        }
        
        .day-selector {
            background-color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 1px 5px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        
        .day-selector:hover {
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
        }
        
        .schedule-table {
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .schedule-table thead th {
            font-weight: 600;
            background-color: #343a40;
            color: white;
            border: none;
        }
        
        .no-schedule-message {
            border-radius: 8px;
            font-weight: 500;
        }
        
        .delete-btn {
            transition: all 0.3s;
            border-radius: 6px;
            padding: 6px 12px;
        }
        
        .delete-btn:hover {
            background-color: #dc3545;
            color: white;
            transform: translateY(-2px);
        }
        
        .delete-btn:active {
            transform: translateY(0);
        }
        
        .time-input-group {
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border-radius: 8px;
            padding: 15px;
            background-color: #f8f9fa;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        
        .time-input-group:hover {
            box-shadow: 0 3px 6px rgba(0,0,0,0.15);
        }
        
        .schedule-days-selected {
            margin-top: 10px;
            background-color: #f0f8ff;
            border-radius: 8px;
            padding: 10px;
            border: 1px dashed #90caf9;
        }
        
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            display: flex;
                flex-direction: column;
            align-items: center;
            justify-content: center;
            z-index: 2000;
        }
        
        .loading-spinner {
            border: 6px solid #f3f3f3;
            border-top: 6px solid #ff9900;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin-bottom: 15px;
        }
        
        .loading-text {
            color: #ff9900;
            font-size: 16px;
            font-weight: 600;
            text-align: center;
            margin-top: 10px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* 고정 위치 홈 버튼 스타일 추가 */
        .floating-home-btn {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1000;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #ff7f00;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }
        
        .floating-home-btn:hover {
            background-color: #e67300;
            color: white;
        }

        /* 테이블 셀 너비 관리 - 메모 열만 제한 */
        .employee-table th, 
        .employee-table td {
            vertical-align: middle;
        }
        
        .employee-table .memo-col { 
            max-width: 150px; /* 메모 열만 제한 */
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>직원 목록</h1>
        
        <!-- 로딩 오버레이 -->
        <div id="pageLoadingOverlay" class="loading-overlay" style="display: none;">
            <div class="loading-spinner"></div>
        </div>
        
        <div class="form-section">
            <h2><i class="fas fa-filter"></i> 직원 필터링</h2>
            
            <div class="form-row">
                <div class="form-group">
                <label for="nameFilter">이름 검색</label>
                    <input type="text" id="nameFilter" placeholder="직원 이름으로 검색" class="form-control">
            </div>
            
                <div class="form-group">
                    <label for="statusFilter">근무 상태</label>
                    <select id="statusFilter" class="form-control">
                        <option value="all">모든 상태</option>
                        <option value="true">재직 중</option>
                        <option value="false">퇴직</option>
                </select>
                </div>
            </div>
            
            <div class="text-center mt-3">
                <button id="filterButton" class="btn btn-primary">
                    <i class="fas fa-search"></i> 검색
                </button>
                <a href="/employeeregistration" class="btn btn-success ms-2">
                    <i class="fas fa-user-plus"></i> 새 직원 등록
                </a>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-striped table-hover employee-table" id="employeeTable">
                <thead class="table-dark">
                    <tr>
                        <th class="id-col">사번</th>
                        <th class="name-col">이름</th>
                        <th class="role-col">직급</th>
                        <th class="wage-col">시급</th>
                        <th class="status-col">상태</th>
                        <th class="memo-col">메모</th>
                        <th class="action-col">관리</th>
                    </tr>
                </thead>
                <tbody id="employeeTableBody">
                    <!-- JavaScript로 동적 데이터 로드 -->
                </tbody>
            </table>
        </div>

        <div style="text-align: center; margin-top: 20px;">
            <a href="/home" class="home-link">
                <i class="fas fa-home"></i> 홈으로 돌아가기
            </a>
        </div>
    </div>

    <!-- 플로팅 홈 버튼 추가 -->
    <a href="/home" class="floating-home-btn" title="홈으로 이동">
        <i class="fas fa-home"></i>
    </a>

    <!-- 메모 모달 -->
    <div class="modal fade memo-modal" id="memoModal" tabindex="-1" aria-labelledby="memoModalLabel" aria-hidden="true">
        <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                    <h5 class="modal-title" id="memoModalLabel">직원 메모</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                    <textarea id="memoTextArea" class="form-control"></textarea>
                    <input type="hidden" id="memoEmployeeId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary" id="saveMemoBtn">저장</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 근무 스케줄 관리 모달 -->
    <div class="modal fade" id="scheduleModal" tabindex="-1" aria-labelledby="scheduleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title" id="scheduleModalLabel">근무 스케줄 관리</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info" id="scheduleInfo">
                        <i class="fas fa-user-clock me-2"></i><span id="scheduleEmployeeName"></span> 직원의 근무 스케줄을 관리합니다.
                    </div>
                    
                    <div id="scheduleSuccessMessage"></div>
                    
                    <div id="scheduleErrorContainer" style="display: none;" class="alert alert-danger">
                        <h5><i class="fas fa-exclamation-triangle me-2"></i>근무 일정 등록 오류</h5>
                        <div id="scheduleErrorMessage" class="mt-2" style="color: red; font-weight: bold;"></div>
                    </div>
                    
                    <div class="mb-4 day-selector">
                        <h5 class="schedule-section-title"><i class="fas fa-calendar-alt me-2"></i>근무 요일 선택</h5>
                        <p class="text-muted small mb-3">근무 일정을 등록할 요일을 선택해주세요.</p>
                        <div class="d-flex flex-wrap gap-2 mb-3">
                            <button type="button" class="btn btn-outline-secondary day-button" data-day="MONDAY">월</button>
                            <button type="button" class="btn btn-outline-secondary day-button" data-day="TUESDAY">화</button>
                            <button type="button" class="btn btn-outline-secondary day-button" data-day="WEDNESDAY">수</button>
                            <button type="button" class="btn btn-outline-secondary day-button" data-day="THURSDAY">목</button>
                            <button type="button" class="btn btn-outline-secondary day-button" data-day="FRIDAY">금</button>
                            <button type="button" class="btn btn-outline-secondary day-button" data-day="SATURDAY">토</button>
                            <button type="button" class="btn btn-outline-secondary day-button" data-day="SUNDAY">일</button>
                        </div>
                    </div>
                    
                    <div class="schedule-section">
                        <h5 class="schedule-section-title"><i class="fas fa-clock me-2"></i>근무 시간 설정</h5>
                        <p class="text-muted small mb-3">선택한 요일에 적용할 근무 시간을 설정하세요.</p>
                        <div id="scheduleList" class="mb-4">
                            <!-- 여기에 근무 일정이 추가됩니다 -->
                        </div>
                        
                        <div class="d-flex">
                            <button type="button" id="addScheduleBtn" class="btn btn-success me-2">
                                <i class="fas fa-plus me-2"></i>근무 시간 추가
                            </button>
                            <button type="button" class="btn btn-primary" id="saveWorkScheduleBtn">
                                <i class="fas fa-save me-2"></i>근무 일정 저장
                            </button>
                        </div>
                    </div>
                    
                    <div class="schedule-section">
                        <h5 class="schedule-section-title"><i class="fas fa-list-alt me-2"></i>현재 등록된 스케줄</h5>
                        <p class="text-muted small mb-3">이미 등록된 근무 일정을 확인하고 관리할 수 있습니다.</p>
                        <div class="table-responsive schedule-table">
                            <table class="table table-striped table-hover mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th class="text-center" style="width: 25%">요일</th>
                                        <th class="text-center" style="width: 25%">시작 시간</th>
                                        <th class="text-center" style="width: 25%">종료 시간</th>
                                        <th class="text-center" style="width: 25%">관리</th>
                                    </tr>
                                </thead>
                                <tbody id="scheduleTableBody">
                                    <!-- 스케줄 데이터가 여기에 로드됩니다 -->
                                </tbody>
                            </table>
                        </div>
                        <div id="noScheduleMessage" class="alert alert-warning no-schedule-message mt-3" style="display: none;">
                            <i class="fas fa-info-circle me-2"></i>등록된 근무 스케줄이 없습니다.
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-end">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 스케줄 추가 모달 -->
    <div class="modal fade" id="addScheduleModal" tabindex="-1" aria-labelledby="addScheduleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title" id="addScheduleModalLabel">근무 스케줄 추가</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="scheduleForm">
                        <input type="hidden" id="scheduleEmployeeId">
                        
                        <div class="mb-3">
                            <label for="workDay" class="form-label fw-bold">요일 <span class="text-danger">*</span></label>
                            <select class="form-select form-select-lg" id="workDay" required>
                                <option value="">요일 선택</option>
                                <option value="MONDAY">월요일</option>
                                <option value="TUESDAY">화요일</option>
                                <option value="WEDNESDAY">수요일</option>
                                <option value="THURSDAY">목요일</option>
                                <option value="FRIDAY">금요일</option>
                                <option value="SATURDAY">토요일</option>
                                <option value="SUNDAY">일요일</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="startTime" class="form-label fw-bold">시작 시간 <span class="text-danger">*</span></label>
                            <input type="time" class="form-control form-control-lg" id="startTime" value="09:00" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="endTime" class="form-label fw-bold">종료 시간 <span class="text-danger">*</span></label>
                            <input type="time" class="form-control form-control-lg" id="endTime" value="18:00" required>
                            <div class="form-text mt-2"><i class="fas fa-info-circle me-1"></i>종료 시간은 시작 시간보다 이후여야 합니다.</div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="saveScheduleBtn">
                        <i class="fas fa-save me-1"></i> 저장
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
        
        // 페이지 로드 시 직원 목록 로드
        $(document).ready(function() {
            // 상태 필터를 기본적으로 '재직 중'으로 설정
            $('#statusFilter').val('true');
            
            loadEmployees();
            
            // 검색 버튼 이벤트
            $('#filterButton').click(function() {
                loadEmployees();
            });
            
            // 엔터키 이벤트
            $('#nameFilter').keypress(function(e) {
                if (e.which === 13) {
                    loadEmployees();
                    return false;
                }
            });
            
            // 메모 저장 버튼 이벤트
            $('#saveMemoBtn').click(function() {
                const employeeId = $('#memoEmployeeId').val();
                const memoText = $('#memoTextArea').val();
                
                saveMemo(employeeId, memoText);
            });
            
            // 요일 버튼 클릭 이벤트
            $('.day-button').off('click').on('click', function() {
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
            
            // 일정 추가 버튼 이벤트
            $('#addScheduleBtn').off('click').on('click', function() {
                const activeDays = Object.keys(selectedDays);
                if (activeDays.length === 0) {
                    alert('먼저 근무 요일을 선택해주세요.');
                    return;
                }
                addScheduleForm();
            });

            // 근무 일정 저장 버튼 이벤트
            $('#saveWorkScheduleBtn').off('click').on('click', function() {
                const employeeId = $('#scheduleEmployeeId').val();
                registerWorkSchedule(employeeId);
            });
        });
        
        // 직원 목록 로드 함수
        function loadEmployees() {
            const nameFilter = $('#nameFilter').val();
            const statusFilter = $('#statusFilter').val();
            
            // 로딩 메시지 표시
            $('#employeeTableBody').html('<tr><td colspan="7" class="text-center">직원 정보를 불러오는 중...</td></tr>');
            
            $.ajax({
                url: '/api/employees',
                type: 'GET',
                success: function(data) {
                    // 필터링
                    let filteredData = data;
                    
                    if (nameFilter) {
                        filteredData = filteredData.filter(emp => 
                            emp.name.toLowerCase().includes(nameFilter.toLowerCase())
                        );
                    }
                    
                    if (statusFilter !== 'all') {
                        const isActive = statusFilter === 'true';
                        filteredData = filteredData.filter(emp => emp.isActive === isActive);
                    }
                    
                    // 재직 중인 직원이 먼저 나오도록 정렬
                    filteredData.sort((a, b) => {
                        if (a.isActive === b.isActive) return 0;
                        return a.isActive ? -1 : 1; // isActive가 true인 직원이 먼저 오도록
                    });
                    
                    displayEmployees(filteredData);
                },
                error: function(xhr, status, error) {
                    $('#employeeTableBody').html('<tr><td colspan="7" class="text-center text-danger">직원 정보를 불러오는데 실패했습니다.</td></tr>');
                    console.error('API 오류:', error);
                }
            });
        }
        
        // 직원 목록 표시 함수
        function displayEmployees(employees) {
            const tableBody = $('#employeeTableBody');
            tableBody.empty();
            
            if (employees.length === 0) {
                tableBody.html('<tr><td colspan="7" class="text-center">조회된 직원이 없습니다.</td></tr>');
                return;
            }
            
            employees.forEach(employee => {
                const row = $('<tr>');
                
                row.append($('<td>').text(employee.id));
                row.append($('<td>').text(employee.name));
                row.append($('<td>').append(createRoleBadge(employee.role)));
                row.append($('<td>').text(formatCurrency(employee.hourlyWage) + '원'));
                row.append($('<td>').append(createStatusBadge(employee.isActive)));
                
                // 메모 셀 추가
                const memoCell = $('<td class="memo-col">');
                const memoContent = $('<span class="memo-text">').text(employee.memo || '(메모 없음)');
                const memoEditIcon = $('<i class="fas fa-edit memo-edit-icon">');
                
                memoContent.click(function() {
                    openMemoModal(employee.id, employee.memo);
                });
                
                memoEditIcon.click(function() {
                    openMemoModal(employee.id, employee.memo);
                });
                
                memoCell.append(memoContent).append(memoEditIcon);
                row.append(memoCell);
                
                // 관리 버튼
                const actionCell = $('<td>');
                const editBtn = $('<button class="btn btn-sm btn-primary me-1">').html('<i class="fas fa-edit"></i>');
                editBtn.click(function() {
                    window.location.href = '/employeeedit/' + employee.id;
                });
                
                const scheduleBtn = $('<button class="btn btn-sm btn-info me-1">').html('<i class="fas fa-calendar-alt"></i>');
                scheduleBtn.click(function() {
                    openScheduleModal(employee.id, employee.name);
                });
                
                actionCell.append(editBtn);
                actionCell.append(scheduleBtn);
                row.append(actionCell);
                
                tableBody.append(row);
            });
        }
        
        // 메모 모달 열기 함수
        function openMemoModal(employeeId, memo) {
            $('#memoEmployeeId').val(employeeId);
            $('#memoTextArea').val(memo || '');
            $('#memoModal').modal('show');
        }
        
        // 메모 저장 함수
        function saveMemo(employeeId, memo) {
            $.ajax({
                url: '/api/employees/memo/' + employeeId,
                type: 'PATCH',
                contentType: 'application/json',
                data: JSON.stringify({ memo: memo }),
                success: function(response) {
                    $('#memoModal').modal('hide');
                    loadEmployees(); // 목록 새로고침
                },
                error: function(xhr, status, error) {
                    alert('메모 저장에 실패했습니다.');
                    console.error('API 오류:', error);
                }
            });
        }
        
        // 상태 배지 생성 함수
        function createStatusBadge(isActive) {
            if (isActive) {
                return $('<span class="status-badge status-active">').text('재직 중');
            } else {
                return $('<span class="status-badge status-inactive">').text('퇴직');
            }
        }
        
        // 역할 배지 생성 함수
        function createRoleBadge(role) {
            if (!role) return '-';
            
            let badgeClass = 'role-staff';
            let displayRole = role;
            
            // 영문 역할명 한글로 변환
            if (role === 'ADMIN' || role === 'OWNER') {
                badgeClass = 'role-admin';
                displayRole = role === 'ADMIN' ? '관리자' : '대표';
            } else if (role === 'MANAGER') {
                badgeClass = 'role-manager';
                displayRole = '매니저';
            } else if (role === 'STAFF') {
                displayRole = '직원';
            }
            
            return $('<span class="role-badge ' + badgeClass + '">').text(displayRole);
        }
        
        // 통화 포맷팅 함수
        function formatCurrency(amount) {
            if (!amount && amount !== 0) return '-';
            return parseInt(amount).toLocaleString('ko-KR');
        }
        
        // 스케줄 모달 열기 함수
        function openScheduleModal(employeeId, employeeName) {
            // 모달 초기화
            selectedDays = {};
            $('.day-button').removeClass('active');
            $('#scheduleList').empty();
            $('#scheduleErrorContainer').hide();
            $('#scheduleSuccessMessage').empty();
            
            $('#scheduleEmployeeId').val(employeeId);
            $('#scheduleEmployeeName').text(employeeName);
            
            // 직원 이름이 전달되었는지 검증
            if (!employeeName) {
                // 직원 정보 다시 가져오기
                $.get('/api/employees/' + employeeId)
                    .done(function(employee) {
                        $('#scheduleEmployeeName').text(employee.name);
                    })
                    .fail(function() {
                        console.error("직원 정보를 가져오는데 실패했습니다.");
                    });
            }
            
            loadEmployeeSchedules(employeeId);
            $('#scheduleModal').modal('show');
        }
        
        // 근무 일정 폼 추가 함수
        function addScheduleForm() {
            const scheduleId = 'schedule_' + Date.now();
            const activeDays = Object.keys(selectedDays);
            
            let scheduleHTML = '<div class="schedule-item" id="' + scheduleId + '">';
            scheduleHTML += '<div class="d-flex justify-content-between align-items-center mb-3">';
            scheduleHTML += '<h5 class="card-title"><i class="fas fa-clock me-2"></i>근무 시간</h5>';
            scheduleHTML += '<button type="button" class="btn btn-sm btn-outline-danger remove-schedule"><i class="fas fa-trash me-1"></i>삭제</button>';
            scheduleHTML += '</div>';
            
            scheduleHTML += '<div class="time-input-group">';
            scheduleHTML += '<div class="row">';
            scheduleHTML += '<div class="col-md-6">';
            scheduleHTML += '<div class="form-group mb-3">';
            scheduleHTML += '<label class="form-label fw-bold">시작 시간 <span class="text-danger">*</span></label>';
            scheduleHTML += '<input type="time" class="form-control form-control-lg schedule-start-time" value="09:00" required>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            
            scheduleHTML += '<div class="col-md-6">';
            scheduleHTML += '<div class="form-group mb-3">';
            scheduleHTML += '<label class="form-label fw-bold">종료 시간 <span class="text-danger">*</span></label>';
            scheduleHTML += '<input type="time" class="form-control form-control-lg schedule-end-time" value="18:00" required>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            
            scheduleHTML += '<div class="schedule-days-selected">';
            scheduleHTML += '<label class="form-label fw-bold"><i class="fas fa-calendar-day me-2"></i>적용 요일</label>';
            scheduleHTML += '<div class="d-flex flex-wrap gap-2 mt-2">';
            
            const dayNameMap = {
                'MONDAY': '월요일',
                'TUESDAY': '화요일',
                'WEDNESDAY': '수요일',
                'THURSDAY': '목요일',
                'FRIDAY': '금요일',
                'SATURDAY': '토요일',
                'SUNDAY': '일요일'
            };
            
            activeDays.forEach(day => {
                const dayName = dayNameMap[day] || day;
                scheduleHTML += '<span class="badge bg-primary p-2">' + dayName + '</span>';
            });
            
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            scheduleHTML += '</div>';
            
            $('#scheduleList').append(scheduleHTML);
            
            // 삭제 버튼 이벤트
            $('#' + scheduleId + ' .remove-schedule').click(function() {
                $(this).closest('.schedule-item').remove();
            });
        }
        
        // 직원 스케줄 조회 함수
        function loadEmployeeSchedules(employeeId) {
            // 직원 ID 검증
            if (!employeeId) {
                $('#scheduleTableBody').html('<tr><td colspan="4" class="text-center text-danger">직원 정보가 유효하지 않습니다.</td></tr>');
                $('#noScheduleMessage').show();
                return;
            }
            
            // 로딩 메시지 표시
            $('#scheduleTableBody').html('<tr><td colspan="4" class="text-center">스케줄을 불러오는 중...</td></tr>');
            $('#noScheduleMessage').hide();
            
            $.ajax({
                url: '/api/work-schedule/list/' + employeeId,
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    if (response && response.length > 0) {
                        displaySchedules(response);
                    } else {
                        $('#scheduleTableBody').html('<tr><td colspan="4" class="text-center">등록된 스케줄이 없습니다.</td></tr>');
                        $('#noScheduleMessage').show();
                    }
                },
                error: function(xhr, status, error) {
                    // 오류 발생 시 직원 정보 재확인 시도
                    tryVerifyEmployeeExists(employeeId, function(exists) {
                        if (exists) {
                            $('#scheduleTableBody').html('<tr><td colspan="4" class="text-center">등록된 스케줄이 없습니다.</td></tr>');
                            $('#noScheduleMessage').show();
                        } else {
                            $('#scheduleTableBody').html('<tr><td colspan="4" class="text-center text-danger">직원 정보를 찾을 수 없습니다.</td></tr>');
                            $('#noScheduleMessage').hide();
                        }
                    });
                }
            });
        }
        
        // 직원 정보 확인 함수
        function tryVerifyEmployeeExists(employeeId, callback) {
            $.ajax({
                url: '/api/employees/' + employeeId,
                type: 'GET',
                success: function(response) {
                    console.log('직원 정보 확인 성공:', response);
                    callback(true);
                },
                error: function() {
                    console.error('직원 정보 확인 실패');
                    callback(false);
                }
            });
        }
        
        // 스케줄 목록 표시 함수
        function displaySchedules(schedules) {
            const tableBody = $('#scheduleTableBody');
            tableBody.empty();
            
            if (!schedules || schedules.length === 0) {
                $('#noScheduleMessage').show();
                tableBody.html('<tr><td colspan="4" class="text-center">등록된 스케줄이 없습니다.</td></tr>');
                return;
            }
            
            $('#noScheduleMessage').hide();
            
            // 요일 순서대로 정렬
            const dayOrder = {
                'MONDAY': 1,
                'TUESDAY': 2,
                'WEDNESDAY': 3,
                'THURSDAY': 4,
                'FRIDAY': 5,
                'SATURDAY': 6,
                'SUNDAY': 7
            };
            
            // 요일 한글화
            const dayNames = {
                'MONDAY': '월요일',
                'TUESDAY': '화요일',
                'WEDNESDAY': '수요일',
                'THURSDAY': '목요일',
                'FRIDAY': '금요일',
                'SATURDAY': '토요일',
                'SUNDAY': '일요일'
            };
            
            try {
                // 정렬
                schedules.sort((a, b) => dayOrder[a.workDay] - dayOrder[b.workDay]);
                
                schedules.forEach(function(schedule) {
                    const row = $('<tr>');
                    
                    // 요일 - 배경색 추가
                    const dayName = dayNames[schedule.workDay] || schedule.workDay;
                    const dayBadge = $('<span class="badge bg-secondary p-2">').text(dayName);
                    const dayCell = $('<td class="text-center align-middle">').append(dayBadge);
                    row.append(dayCell);
                    
                    // 시작 시간 (문자열 확인 및 안전하게 처리)
                    const startTime = formatTimeDisplay(schedule.startTime);
                    const startTimeBadge = $('<span class="badge bg-primary">').text(startTime);
                    const startTimeCell = $('<td class="text-center align-middle">').append(startTimeBadge);
                    row.append(startTimeCell);
                    
                    // 종료 시간 (문자열 확인 및 안전하게 처리)
                    const endTime = formatTimeDisplay(schedule.endTime);
                    const endTimeBadge = $('<span class="badge bg-success">').text(endTime);
                    const endTimeCell = $('<td class="text-center align-middle">').append(endTimeBadge);
                    row.append(endTimeCell);
                    
                    // 관리 버튼
                    const actionCell = $('<td class="text-center align-middle">');
                    const deleteBtn = $('<button class="btn btn-outline-danger delete-btn">').html('<i class="fas fa-trash me-1"></i>삭제');
                    deleteBtn.click(function() {
                        if (confirm('정말로 이 스케줄을 삭제하시겠습니까?')) {
                            deleteSchedule(schedule.id);
                        }
                    });
                    
                    actionCell.append(deleteBtn);
                    row.append(actionCell);
                    
                    tableBody.append(row);
                });
            } catch (error) {
                console.error('스케줄 표시 오류:', error);
                $('#noScheduleMessage').show();
                tableBody.html('<tr><td colspan="4" class="text-center text-danger">스케줄 데이터 처리 중 오류가 발생했습니다.</td></tr>');
            }
        }
        
        // 시간 표시 형식 변환 함수
        function formatTimeDisplay(timeValue) {
            try {
                // timeValue가 배열인 경우 (예: [9, 0])
                if (Array.isArray(timeValue)) {
                    if (timeValue.length >= 2) {
                        const hour = timeValue[0];
                        const minute = timeValue[1];
                        return hour + ":" + (minute < 10 ? '0' + minute : minute);
                    }
                    return '시간 정보 없음';
                } 
                // timeValue가 문자열인 경우 (예: "9:00" 또는 "9,0")
                else if (typeof timeValue === 'string') {
                    if (timeValue.includes(',')) {
                        const [hour, minute] = timeValue.split(',').map(part => part.trim());
                        return hour + ":" + (minute < 10 && minute.length === 1 ? '0' + minute : minute);
                    } else if (timeValue.includes(':')) {
                        // 이미 HH:MM 형식인 경우
                        return timeValue;
                    } else {
                        return timeValue || '시간 정보 없음';
                    }
                }
                return timeValue?.toString() || '시간 정보 없음';
            } catch (e) {
                console.error('시간 형식 변환 오류:', e);
                return '시간 형식 오류';
            }
        }
        
        // 근무 일정 등록 함수
        function registerWorkSchedule(employeeId) {
            // 근무 일정 데이터 수집
            const workSchedules = [];
            
            // 요일 한글명 매핑 (오류 메시지 표시용)
            const dayKoreanMap = {
                'MONDAY': '월요일',
                'TUESDAY': '화요일',
                'WEDNESDAY': '수요일',
                'THURSDAY': '목요일',
                'FRIDAY': '금요일',
                'SATURDAY': '토요일',
                'SUNDAY': '일요일'
            };
            
            // 스케줄 아이템에서 시간 정보 추출
            $('.schedule-item').each(function() {
                const startTime = $(this).find('.schedule-start-time').val();
                const endTime = $(this).find('.schedule-end-time').val();
                
                // 기본 유효성 검사만 프론트엔드에서 수행
                if (!startTime || !endTime) {
                    alert('시작 시간과 종료 시간을 모두 입력해주세요.');
                    return false;
                }
                
                if (startTime >= endTime) {
                    alert('종료 시간은 시작 시간보다 이후여야 합니다.');
                    return false;
                }
                
                // 요일 버튼에서 선택된 모든 요일 사용
                Object.keys(selectedDays).forEach(day => {
                    workSchedules.push({
                        employeeId: parseInt(employeeId),
                        workDay: day,
                        startTime: startTime,
                        endTime: endTime
                    });
                });
            });
            
            // 스케줄이 없으면 함수 종료
            if (workSchedules.length === 0) {
                alert('등록할 근무 일정이 없습니다.');
                return;
            }
            
            console.log('등록할 스케줄:', workSchedules);
            
            // 근무 일정 등록 AJAX 요청 - 백엔드에서 모든 중복 체크 수행
            $.ajax({
                url: '/api/work-schedule',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(workSchedules),
                success: function(response) {
                    loadEmployeeSchedules(employeeId);
                    
                    // 성공 메시지 표시
                    const successHTML = 
                    '<div class="alert alert-success alert-dismissible fade show mt-3" role="alert">' +
                        '<strong><i class="fas fa-check-circle me-2"></i>근무 일정이 성공적으로 등록되었습니다.</strong>' +
                        '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                    '</div>';
                    
                    // 오류 메시지 컨테이너를 숨기고 성공 메시지 표시
                    $('#scheduleErrorContainer').hide();
                    $('#scheduleSuccessMessage').html(successHTML);
                    
                    // 입력 필드 초기화
                    selectedDays = {};
                    $('.day-button').removeClass('active');
                    $('#scheduleList').empty();
                    
                    // 스크롤 이동
                    $('#scheduleModal').scrollTop(0);
                },
                error: function(xhr, status, error) {
                    // 오류 메시지 처리
                    let errorMessage = '근무 스케줄 저장에 실패했습니다.';
                    
                    try {
                        // 응답이 JSON 형식인지 확인
                        if (xhr.responseText && xhr.getResponseHeader('content-type') && 
                            xhr.getResponseHeader('content-type').includes('application/json')) {
                            
                            const response = JSON.parse(xhr.responseText);
                            if (response.message) {
                                errorMessage = response.message;
                            }
                        } else {
                            // JSON이 아닌 경우 직접 정규식으로 추출
                            const pattern = /([월화수목금토일]요일에\s*이미\s*[\d:]+부터\s*[\d:]+까지\s*근무\s*일정이\s*존재합니다.*?겹치는\s*근무일정)/;
                            const match = xhr.responseText.match(pattern);
                            
                            if (match && match[1]) {
                                errorMessage = match[1];
                            } else {
                                // 두 번째 패턴 시도 - "같은 요청 내에서" 메시지 추출
                                const pattern2 = /(같은\s*요청\s*내에서\s*[월화수목금토일]요일에\s*[\d:]+부터\s*[\d:]+까지와\s*[\d:]+부터\s*[\d:]+까지\s*시간이\s*겹치는\s*근무\s*일정이\s*있습니다)/;
                                const match2 = xhr.responseText.match(pattern2);
                                
                                if (match2 && match2[1]) {
                                    errorMessage = match2[1];
                                }
                            }
                        }
                    } catch (e) {
                        console.error('응답 파싱 오류:', e);
                    }
                    
                    // 오류 메시지 표시
                    $('#scheduleErrorMessage').text(errorMessage);
                    $('#scheduleErrorContainer').show();
                    
                    // 스크롤 이동
                    $('#scheduleModal').scrollTop(0);
                }
            });
        }
        
        // 스케줄 삭제 함수
        function deleteSchedule(scheduleId) {
            const employeeId = $('#scheduleEmployeeId').val();
            
            // 로딩 효과 추가
            const loadingOverlay = $('<div class="loading-overlay"><div class="loading-spinner"></div><div class="loading-text">삭제 중...</div></div>');
            $('body').append(loadingOverlay);
            loadingOverlay.show();
            
            $.ajax({
                url: '/api/work-schedule/delete/id/' + scheduleId,
                type: 'DELETE',
                success: function(response) {
                    loadingOverlay.remove();
                    
                    // 성공 메시지 표시
                    const successHTML = 
                    '<div class="alert alert-success alert-dismissible fade show mt-3" role="alert">' +
                        '<strong><i class="fas fa-check-circle me-2"></i>근무 스케줄이 성공적으로 삭제되었습니다.</strong>' +
                        '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                    '</div>';
                    
                    $('#scheduleSuccessMessage').html(successHTML);
                    
                    // 스케줄 목록 새로고침
                    loadEmployeeSchedules(employeeId);
                    
                    // 스크롤 이동
                    $('#scheduleModal').scrollTop(0);
                },
                error: function(xhr, status, error) {
                    loadingOverlay.remove();
                    
                    // 상태 코드가 204(No Content)인 경우에도 성공으로 처리 
                    // (삭제 완료시 많은 API는 204를 반환)
                    if (xhr.status === 204) {
                        // 성공 메시지 표시
                        const successHTML = 
                        '<div class="alert alert-success alert-dismissible fade show mt-3" role="alert">' +
                            '<strong><i class="fas fa-check-circle me-2"></i>근무 스케줄이 성공적으로 삭제되었습니다.</strong>' +
                            '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                        '</div>';
                        
                        $('#scheduleSuccessMessage').html(successHTML);
                        
                        // 스케줄 목록 새로고침
                        loadEmployeeSchedules(employeeId);
                        
                        // 스크롤 이동
                        $('#scheduleModal').scrollTop(0);
                        return;
                    }
                    
                    // 오류 메시지 표시
                    const errorHTML = 
                    '<div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">' +
                        '<strong><i class="fas fa-exclamation-circle me-2"></i>근무 스케줄 삭제에 실패했습니다.</strong>' +
                        '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                    '</div>';
                    
                    $('#scheduleSuccessMessage').html(errorHTML);
                    
                    // 스크롤 이동
                    $('#scheduleModal').scrollTop(0);
                }
            });
        }

        function updateEndDate(employeeId, newEndDate) {
            if (!confirm('정말로 종료 날짜를 변경하시겠습니까?')) {
                return;
            }
            
            $.ajax({
                url: '/api/employees/' + employeeId + '/end-date',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify({ endDate: newEndDate }),
                success: function(response) {
                    alert('종료 날짜가 성공적으로 변경되었습니다.');
                    loadEmployees(); // 목록 새로고침
                },
                error: function(xhr, status, error) {
                    let errorMessage = '종료 날짜 변경 중 오류가 발생했습니다.';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMessage = xhr.responseJSON.message;
                    }
                    alert('종료 날짜 변경 실패: ' + errorMessage);
                }
            });
        }

        function deleteEmployee(employeeId) {
            if (!confirm('정말로 이 직원을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
                return;
            }
            
            $.ajax({
                url: '/api/employees/' + employeeId,
                type: 'DELETE',
                success: function(response) {
                    loadEmployees(); // 목록 새로고침
                },
                error: function(xhr, status, error) {
                    let errorMessage = '직원 삭제 중 오류가 발생했습니다.';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMessage = xhr.responseJSON.message;
                    }
                    alert('직원 삭제 실패: ' + errorMessage);
                }
            });
        }
    </script>
</body>
</html>