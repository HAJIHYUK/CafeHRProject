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
    <style>
        .search-box {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
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
                        <option value="employee">직원번호</option>
                        <option value="name">직원이름</option>
                    </select>
                </div>
                <div class="col-md-3" id="employeeNameBox" style="display:none;">
                    <label class="form-label fw-bold">직원 이름</label>
                    <input type="text" class="form-control" id="employeeName">
                </div>
                <div class="col-md-3" id="employeeIdBox" style="display:none;">
                    <label class="form-label fw-bold">직원 번호</label>
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
                <div class="col-md-12 text-center mt-3">
                    <button class="btn btn-primary px-4" onclick="searchAttendance()">
                        <i class="fas fa-search me-1"></i> 검색
                    </button>
                    <button class="btn btn-warning ms-2" id="updateSelectedButton">
                        <i class="fas fa-check-square"></i> 선택된 항목 근무시간 변경
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
                        <th>직원번호</th>
                        <th>이름</th>
                        <th>출근시간</th>
                        <th>퇴근시간</th>
                        <th>실제근무시간</th>
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
                            <label class="form-label">직원 번호</label>
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
                            <label class="form-label">근무 시간 직접 수정</label>
                            <div class="row">
                                <div class="col-6">
                                    <label class="form-label">시간</label>
                                    <input type="number" class="form-control" id="editHours" min="0" step="1">
                                </div>
                                <div class="col-6">
                                    <label class="form-label">분</label>
                                    <input type="number" class="form-control" id="editMinutes" min="0" max="59" step="1">
                                </div>
                            </div>
                            <div class="form-text">근무 시간을 직접 수정하면 출퇴근 시간에 관계없이 입력한 시간이 적용됩니다.</div>
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
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addAttendanceModalLabel">관리자 출근 기록 추가</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addAttendanceForm">
                        <div class="mb-3">
                            <label class="form-label">직원 번호 *</label>
                            <input type="number" class="form-control" id="addEmployeeId" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">출근 날짜 *</label>
                            <input type="date" class="form-control" id="addCheckInDate" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">출근 시간 *</label>
                            <input type="time" class="form-control" id="addCheckInTime" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">퇴근 날짜</label>
                            <input type="date" class="form-control" id="addCheckOutDate">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">퇴근 시간</label>
                            <input type="time" class="form-control" id="addCheckOutTime">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">근무 시간 직접 입력</label>
                            <div class="row">
                                <div class="col-6">
                                    <label class="form-label">시간</label>
                                    <input type="number" class="form-control" id="addHours" min="0" step="1">
                                </div>
                                <div class="col-6">
                                    <label class="form-label">분</label>
                                    <input type="number" class="form-control" id="addMinutes" min="0" max="59" step="1">
                                </div>
                            </div>
                            <div class="form-text">근무 시간을 직접 입력하면 출퇴근 시간에 관계없이 입력한 시간이 적용됩니다.</div>
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
        // 페이지 로드 시 전체 직원 출근 기록 조회
        $(document).ready(function() {
            loadAllAttendance();
            loadExpectTotalHours(); // 예상 근무시간 데이터 로드

            // 체크된 항목들의 실제근무시간을 예상근무시간으로 변경하는 버튼 이벤트 등록
            $("#updateSelectedButton").click(updateSelectedWorkHours);
        });
        
        // 전체 직원 출근 기록 로드
        function loadAllAttendance() {
            console.log('출근 기록 불러오기 시작');
            $.get('/api/attendance')
                .done(function(data) {
                    console.log('서버 응답 데이터:', data);
                    // 날짜 형식을 확인하는 코드
                    if (data.length > 0) {
                        console.log('첫 번째 항목 checkIn 타입:', typeof data[0].checkIn);
                        console.log('첫 번째 항목 checkIn 값:', data[0].checkIn);
                        console.log('첫 번째 항목 checkOut 타입:', typeof data[0].checkOut);
                        console.log('첫 번째 항목 checkOut 값:', data[0].checkOut);
                    }
                    
                    // 예상 근무시간 데이터 로드 후 출근 기록 표시
                    loadExpectTotalHours(data);
                })
                .fail(function(error) {
                    alert('데이터를 불러오는데 실패했습니다.');
                    console.error('API 오류:', error);
                });
        }
        
        // 예상 근무시간 데이터 로드
        function loadExpectTotalHours(attendanceData) {
            $.get('/api/work-schedule/expect-total-hours')
                .done(function(expectData) {
                    console.log('예상 근무시간 데이터:', expectData);
                    
                    // 예상 근무시간 데이터를 attendanceId 기준으로 매핑
                    const expectMap = {};
                    expectData.forEach(function(item) {
                        expectMap[item.attendanceId] = item.expectTotalHours;
                    });
                    
                    // 출근 기록 데이터에 예상 근무시간 추가
                    if (attendanceData) {
                        attendanceData.forEach(function(item) {
                            item.expectTotalHours = expectMap[item.attendanceId] || 0;
                        });
                        
                        // 데이터 표시
                        displayAttendance(attendanceData);
                    }
                })
                .fail(function(error) {
                    console.error('예상 근무시간 데이터 로드 실패:', error);
                    
                    // 예상 근무시간 없이 출근 기록만 표시
                    if (attendanceData) {
                        displayAttendance(attendanceData);
                    }
                });
        }

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
                        alert('직원 번호를 입력해주세요.');
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
                        alert('직원 번호를 입력해주세요.');
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
            $('#attendanceList').html('<tr><td colspan="9" class="text-center py-3">데이터를 불러오는 중...</td></tr>');
            
            $.get(url)
                .done(function(data) {
                    // 예상 근무시간 데이터 로드 후 출근 기록 표시
                    loadExpectTotalHours(data);
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
            
            console.log('받은 데이터:', data); // 디버깅용 로그 추가
            
            if (data.length === 0) {
                const row = $('<tr>');
                row.append($('<td colspan="9" class="text-center py-3">').text('조회된 출퇴근 기록이 없습니다.'));
                tbody.append(row);
                return;
            }

            data.forEach(function(item, index) {
                console.log(`데이터 항목 \${index}:`, item); // 각 항목 로그 추가
                const row = $('<tr class="text-center">');
                row.append($('<td>').html('<input type="checkbox" class="form-check-input attendance-checkbox">'));
                row.append($('<td>').text(item.attendanceId));
                row.append($('<td>').text(item.employeeId));
                row.append($('<td>').text(item.name));
                row.append($('<td>').text(formatDateTime(item.checkIn)));
                row.append($('<td>').text(formatDateTime(item.checkOut)));
                row.append($('<td>').text(formatWorkHours(item.totalHours)));
                row.append($('<td>').text(formatWorkHours(item.expectTotalHours)));
                
                // 수정 버튼 추가
                const actionCell = $('<td>');
                const editBtn = $('<button class="btn btn-sm btn-primary me-2">').html('<i class="fas fa-edit"></i> 수정');
                editBtn.click(function() {
                    openEditModal(item);
                });
                
                // 삭제 버튼 추가
                const deleteBtn = $('<button class="btn btn-sm btn-danger">').html('<i class="fas fa-trash"></i> 삭제');
                deleteBtn.click(function() {
                    confirmDeleteAttendance(item.attendanceId);
                });
                
                actionCell.append(editBtn);
                actionCell.append(deleteBtn);
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

        // 체크된 항목들의 실제근무시간을 예상근무시간으로 변경
        function updateSelectedWorkHours() {
            const selectedRows = $('.attendance-checkbox:checked').closest('tr');
            if (selectedRows.length === 0) {
                alert('변경할 항목을 선택해주세요.');
                return;
            }

            // 모달 설정
            $('#successTitle').text('근무시간 변경');
            $('#successMessage').text('선택한 ' + selectedRows.length + '개 항목의 실제 근무시간을 예상 근무시간으로 변경하시겠습니까?');
            
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
                    }, 150); // 50ms 지연
                })
                .catch(function(error) {
                    alert('근무시간 업데이트 중 오류가 발생했습니다.');
                    console.error('업데이트 오류:', error);
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
            
            // 근무 시간을 시간과 분으로 분리하여 설정
            if (attendance.totalHours) {
                const hours = Math.floor(attendance.totalHours);
                const minutes = Math.round((attendance.totalHours - hours) * 60);
                
                $('#editHours').val(hours);
                $('#editMinutes').val(minutes);
            } else {
                $('#editHours').val(0);
                $('#editMinutes').val(0);
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
            const hours = parseInt($('#editHours').val() || 0);
            const minutes = parseInt($('#editMinutes').val() || 0);
            
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
            
            // 항상 근무 시간 값 포함 (0이어도 전송)
            const totalHours = hours + (minutes / 60);
            data.totalHours = totalHours;
            
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
                    console.log('알 수 없는 날짜 형식:', dateTime);
                    return '-';
                }
                
                // 유효한 날짜인지 확인
                if (isNaN(date.getTime())) {
                    console.log('유효하지 않은 날짜:', dateTime);
                    return '-';
                }
                
                return date.getFullYear() + '-' + 
                       String(date.getMonth() + 1).padStart(2, '0') + '-' + 
                       String(date.getDate()).padStart(2, '0') + ' ' + 
                       String(date.getHours()).padStart(2, '0') + ':' + 
                       String(date.getMinutes()).padStart(2, '0');
            } catch (error) {
                console.log('날짜 포맷팅 오류:', error, dateTime);
                return '-';
            }
        }

        // 관리자 출근 기록 추가 모달 열기
        function openAddAttendanceModal() {
            // 초기화
            $('#addEmployeeId').val('');
            $('#addCheckInDate').val(new Date().toISOString().split('T')[0]); // 오늘 날짜
            $('#addCheckInTime').val('09:00'); // 기본 출근 시간
            $('#addCheckOutDate').val('');
            $('#addCheckOutTime').val('');
            $('#addHours').val('');
            $('#addMinutes').val('');
            
            // 모달 표시
            $('#addAttendanceModal').modal('show');
        }
        
        // 관리자 출근 기록 추가 제출
        function submitAddAttendance() {
            const employeeId = $('#addEmployeeId').val();
            const checkInDate = $('#addCheckInDate').val();
            const checkInTime = $('#addCheckInTime').val();
            const checkOutDate = $('#addCheckOutDate').val();
            const checkOutTime = $('#addCheckOutTime').val();
            const hours = parseInt($('#addHours').val() || 0);
            const minutes = parseInt($('#addMinutes').val() || 0);
            
            // 유효성 검사
            if (!employeeId || !checkInDate || !checkInTime) {
                alert('직원 번호, 출근 날짜와 시간은 필수입니다.');
                return;
            }
            
            // 데이터 준비
            const data = {
                employeeId: Number(employeeId),
                checkIn: `\${checkInDate}T\${checkInTime}:00`
            };
            
            // 퇴근 시간이 있는 경우만 포함
            if (checkOutDate && checkOutTime) {
                data.checkOut = `\${checkOutDate}T\${checkOutTime}:00`;
            }
            
            // 근무 시간이 입력된 경우 포함
            if (hours > 0 || minutes > 0) {
                const totalHours = hours + (minutes / 60);
                data.totalHours = totalHours;
            }
            
            console.log('전송할 데이터:', data);
            
            // API 호출
            $.ajax({
                url: '/api/attendance/check-in/admin',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function(response) {
                    // 성공 모달 설정
                    $('#successTitle').text('추가 완료');
                    $('#successMessage').text('출근 기록이 추가되었습니다.');
                    
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
    </script>
</body>
</html> 