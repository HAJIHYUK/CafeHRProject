<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CafeHR - 급여 계산기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/cafeHR.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .result-section {
            background-color: #f0f8ff;
            padding: 30px;
            border-radius: 10px;
            margin-top: 30px;
            display: none;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .result-section h2 {
            color: var(--primary-color);
            margin-bottom: 20px;
            border-bottom: 2px solid var(--primary-light);
            padding-bottom: 10px;
        }

        .result-row {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .result-label {
            font-weight: 500;
            color: var(--text-color);
        }

        .result-value {
            font-weight: 700;
            color: var(--primary-dark);
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 20px 0;
            border-top: 2px dashed var(--primary-light);
            margin-top: 15px;
            font-size: 1.2em;
        }

        .salary-result {
            margin-top: 20px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            display: none;
        }
        .result-detail {
            margin-top: 15px;
            border-top: 1px dashed #ccc;
            padding-top: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>급여 계산기</h1>
        
        <div class="form-section">
            <h2><i class="fas fa-calculator"></i> 급여 계산</h2>
            <p style="margin-bottom: 20px; color: var(--text-light);">
                실제 출퇴근 기록을 기반으로 직원의 급여를 계산합니다. 주 15시간 이상 근무 시 주휴수당이 자동으로 계산됩니다.
            </p>
            
            <div style="background-color: #f0f8ff; padding: 15px; border-radius: 8px; margin-bottom: 20px; border-left: 4px solid var(--primary-color);">
                <h3 style="margin-bottom: 10px; color: var(--primary-color);"><i class="fas fa-info-circle"></i> 급여 계산 방식</h3>
                <ul style="list-style-type: none; padding-left: 10px;">
                    <li style="margin-bottom: 5px;"><i class="fas fa-check-circle" style="color: var(--primary-color); margin-right: 8px;"></i>기본급 = 시급 × 총 근무 시간</li>
                    <li style="margin-bottom: 5px;"><i class="fas fa-check-circle" style="color: var(--primary-color); margin-right: 8px;"></i>주휴수당 = (주간 근무시간 × 8 ÷ 40) × 시급 (주 15시간 이상 근무 시)</li>
                    <li style="margin-bottom: 5px;"><i class="fas fa-check-circle" style="color: var(--primary-color); margin-right: 8px;"></i>최종 급여 = 기본급 + 주휴수당</li>
                </ul>
            </div>
            
            <!-- 탭 메뉴 추가 -->
            <ul class="nav nav-tabs" id="salaryTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="actual-tab" data-bs-toggle="tab" data-bs-target="#actual-content" type="button" role="tab" aria-controls="actual-content" aria-selected="true" style="background-color: #007bff; color: white;">
                        <i class="fas fa-file-invoice-dollar"></i> 실제 급여 계산
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="all-tab" data-bs-toggle="tab" data-bs-target="#all-content" type="button" role="tab" aria-controls="all-content" aria-selected="false" style="background-color: #f8f9fa; color: #495057;">
                        <i class="fas fa-users"></i> 전체 급여 일괄계산
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="expected-tab" data-bs-toggle="tab" data-bs-target="#expected-content" type="button" role="tab" aria-controls="expected-content" aria-selected="false" style="background-color: #f8f9fa; color: #495057;">
                        <i class="fas fa-chart-line"></i> 예상 급여 계산
                    </button>
                </li>
            </ul>
            
            <div class="tab-content pt-3" id="salaryTabsContent">
                <!-- 실제 급여 계산 탭 컨텐츠 -->
                <div class="tab-pane fade show active" id="actual-content" role="tabpanel" aria-labelledby="actual-tab">
                    <p class="alert alert-info">
                        <i class="fas fa-info-circle"></i> 실제 출퇴근 기록을 기반으로 급여를 계산합니다. 정확한 근무 시간과 주휴수당이 자동으로 계산됩니다.
                    </p>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="employeeSelect">직원 선택</label>
                            <select id="employeeSelect" class="form-control">
                                <option value="">직원을 선택해주세요</option>
                                <!-- 직원 목록은 JavaScript로 동적 로드됨 -->
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="yearMonth">연월 선택</label>
                            <input type="month" id="yearMonth" name="yearMonth" class="form-control">
                        </div>
                    </div>
                    
                    <button id="calculateBtn" class="btn btn-primary">
                        <i class="fas fa-calculator"></i> 급여 계산하기
                    </button>
                </div>
                
                <!-- 전체 급여 일괄계산 탭 컨텐츠 -->
                <div class="tab-pane fade" id="all-content" role="tabpanel" aria-labelledby="all-tab">
                    <p class="alert alert-info">
                        <i class="fas fa-info-circle"></i> 선택한 월의 모든 직원 급여를 실제 출퇴근 기록 기반으로 일괄 계산합니다.
                    </p>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="allYearMonth">연월 선택</label>
                            <input type="month" id="allYearMonth" name="allYearMonth" class="form-control">
                        </div>
                    </div>
                    
                    <button id="calculateAllBtn" class="btn btn-primary">
                        <i class="fas fa-calculator"></i> 전체 급여 일괄계산
                    </button>
                    
                    <div id="allCalculationResult" class="salary-result">
                        <h3><i class="fas fa-list"></i> 급여 계산 결과</h3>
                        <p id="allCalculationSummary"></p>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>직원명</th>
                                        <th>시급</th>
                                        <th>총 근무시간</th>
                                        <th>기본급</th>
                                        <th>주휴수당</th>
                                        <th>최종 급여</th>
                                    </tr>
                                </thead>
                                <tbody id="allCalculationTableBody">
                                    <!-- 계산 결과는 JavaScript로 동적 로드됨 -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <!-- 예상 급여 계산 탭 컨텐츠 -->
                <div class="tab-pane fade" id="expected-content" role="tabpanel" aria-labelledby="expected-tab">
                    <p class="alert alert-info">
                        <i class="fas fa-info-circle"></i> 근무 일정을 기반으로 예상 급여를 계산합니다. 실제 출근 기록이 없더라도 등록된 근무 일정으로 급여를 미리 예측할 수 있습니다.
                    </p>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="expectedEmployeeSelect">직원 선택</label>
                            <select id="expectedEmployeeSelect" class="form-control">
                                <option value="">직원을 선택해주세요</option>
                                <!-- 직원 목록은 JavaScript로 동적 로드됨 -->
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="expectedYearMonth">연월 선택</label>
                            <input type="month" id="expectedYearMonth" name="expectedYearMonth" class="form-control">
                        </div>
                    </div>
                    
                    <button id="calculateExpectedBtn" class="btn btn-primary">
                        <i class="fas fa-calculator"></i> 예상 급여 계산하기
                    </button>
                </div>
                
                <div id="loading" class="loading">
                    <i class="fas fa-spinner"></i> 계산 중...
                </div>
                
                <div id="errorMessage" class="error-message"></div>
            </div>
            
            <div id="resultSection" class="result-section">
                <h2>급여 계산 결과</h2>
                
                <!-- 실제 급여 결과 영역 -->
                <div id="actualResult">
                    <div class="result-row">
                        <span class="result-label">직원 이름</span>
                        <span id="resultName" class="result-value">-</span>
                    </div>
                    <div class="result-row">
                        <span class="result-label">계산 기간</span>
                        <span id="resultPeriod" class="result-value">-</span>
                    </div>
                    <div class="result-row">
                        <span class="result-label">시급</span>
                        <span id="resultHourlyWage" class="result-value">-</span>
                    </div>
                    <div class="result-row">
                        <span class="result-label">총 근무 시간</span>
                        <span id="resultTotalHours" class="result-value">-</span>
                    </div>
                    <div class="result-row">
                        <span class="result-label">기본급 (시급 × 근무시간)</span>
                        <span id="resultBaseSalary" class="result-value">-</span>
                    </div>
                    <div class="result-row">
                        <span class="result-label">주휴수당 (주 15시간 이상 근무 시)</span>
                        <span id="resultHolidayBonus" class="result-value">-</span>
                    </div>
                    <div class="total-row">
                        <span class="result-label">최종 급여</span>
                        <span id="resultTotalSalary" class="result-value">-</span>
                    </div>
                    
                    <!-- 예상 급여 정보 추가 -->
                    <div style="margin-top: 30px; border-top: 2px dashed #ccc; padding-top: 20px;">
                        <h4 style="color: #28a745; margin-bottom: 15px;"><i class="fas fa-chart-line"></i> 예상 급여 정보</h4>
                        
                        <div class="result-row" style="background-color: #f8fff8;">
                            <span class="result-label">예상 총 근무시간</span>
                            <span id="resultExpectedTotalHours" class="result-value">-</span>
                        </div>
                        <div class="result-row" style="background-color: #f8fff8;">
                            <span class="result-label">예상 기본급</span>
                            <span id="resultExpectedBaseSalary" class="result-value">-</span>
                        </div>
                        <div class="result-row" style="background-color: #f8fff8;">
                            <span class="result-label">예상 주휴수당</span>
                            <span id="resultExpectedHolidayBonus" class="result-value">-</span>
                        </div>
                        <div class="total-row" style="background-color: #f8fff8;">
                            <span class="result-label">예상 최종 급여</span>
                            <span id="resultExpectedTotalSalary" class="result-value">-</span>
                        </div>
                        <div class="alert alert-info mt-2" style="font-size: 0.9em;">
                            <i class="fas fa-info-circle"></i> 예상 정보는 근무 일정을 기반으로 계산되며, 실제 출퇴근 기록과 차이가 있을 수 있습니다.
                        </div>
                    </div>
                </div>
                
                <!-- 예상 급여 결과 영역 추가 -->
                <div id="expectedResult" style="display: none;">
                    <div class="result-row">
                        <span class="result-label">직원 이름</span>
                        <span id="expectedResultName" class="result-value">-</span>
                    </div>
                    <div class="result-row">
                        <span class="result-label">예상 기간</span>
                        <span id="expectedResultPeriod" class="result-value">-</span>
                    </div>
                    <div class="result-row">
                        <span class="result-label">시급</span>
                        <span id="expectedResultHourlyWage" class="result-value">-</span>
                    </div>
                    <div class="result-row">
                        <span class="result-label">예상 근무 시간</span>
                        <span id="expectedResultTotalHours" class="result-value">-</span>
                    </div>
                    <div class="result-row">
                        <span class="result-label">예상 기본급</span>
                        <span id="expectedResultBaseSalary" class="result-value">-</span>
                    </div>
                    <div class="result-row">
                        <span class="result-label">예상 주휴수당</span>
                        <span id="expectedResultHolidayBonus" class="result-value">-</span>
                    </div>
                    <div class="total-row">
                        <span class="result-label">예상 최종 급여</span>
                        <span id="expectedResultTotalSalary" class="result-value">-</span>
                    </div>
                    <div class="alert alert-warning mt-3">
                        <i class="fas fa-exclamation-triangle"></i> 이 결과는 근무 일정을 기반으로 한 예상치이며, 실제 출근 기록에 따라 달라질 수 있습니다.
                    </div>
                </div>
            </div>
        </div>
        
        <div class="form-section history-section">
            <h2><i class="fas fa-history"></i> 급여 내역</h2>
            <div class="alert alert-info" style="margin-bottom: 20px;">
                <i class="fas fa-info-circle"></i> 이전에 실제 계산된 급여 내역을 조회합니다. 모든 급여 기록은 실제 출퇴근 시간과 주휴수당 계산 결과를 포함합니다.
            </div>
            <div class="alert alert-warning" style="margin-bottom: 20px;">
                <i class="fas fa-exclamation-triangle"></i> <strong>주의사항:</strong> '실제 급여 계산' 또는 '전체 급여 일괄계산' 탭에서 계산을 실행해야 급여 데이터가 저장되고 이 목록에 표시됩니다. 계산되지 않은 급여는 조회되지 않습니다.
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="historySelect">조회 방식</label>
                    <select id="historySelect" class="form-control">
                        <option value="employee">직원별 조회</option>
                        <option value="month">월별 조회</option>
                    </select>
                </div>
                <div class="form-group" id="historyEmployeeGroup">
                    <label for="historyEmployee">직원 선택</label>
                    <select id="historyEmployee" class="form-control">
                        <option value="">직원을 선택해주세요</option>
                        <!-- 직원 목록은 JavaScript로 동적 로드됨 -->
                    </select>
                </div>
                <div class="form-group" id="historyMonthGroup" style="display: none;">
                    <label for="historyMonth">월 선택</label>
                    <input type="month" id="historyMonth" class="form-control">
                </div>
            </div>
            
            <button id="searchHistoryBtn" class="btn btn-primary">
                <i class="fas fa-search"></i> 내역 조회
            </button>
            
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>직원명</th>
                            <th>급여 월</th>
                            <th>총 근무시간</th>
                            <th>기본급</th>
                            <th>주휴수당</th>
                            <th>최종 급여</th>
                            <th>마지막 계산일</th>
                        </tr>
                    </thead>
                    <tbody id="historyTableBody">
                        <!-- 조회 결과는 JavaScript로 동적 로드됨 -->
                    </tbody>
                </table>
            </div>
        </div>
        
        <div style="text-align: center; margin-top: 20px;">
            <a href="/home" class="home-link"><i class="fas fa-home"></i> 홈으로 돌아가기</a>
        </div>
    </div>
    
    <!-- 플로팅 홈 버튼 추가 -->
    <a href="/home" class="floating-home-btn" title="홈으로 이동">
        <i class="fas fa-home"></i>
    </a>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 직원 목록 조회
        async function fetchEmployees() {
            try {
                const response = await fetch('/api/employees');
                if (!response.ok) throw new Error('직원 정보를 불러오는데 실패했습니다.');
                
                const employees = await response.json();
                
                // 직원 선택 드롭다운 업데이트
                const employeeSelect = document.getElementById('employeeSelect');
                const historyEmployee = document.getElementById('historyEmployee');
                const expectedEmployeeSelect = document.getElementById('expectedEmployeeSelect');
                
                // 기존 옵션 삭제 (첫 번째 옵션 유지)
                while (employeeSelect.options.length > 1) employeeSelect.remove(1);
                while (historyEmployee.options.length > 1) historyEmployee.remove(1);
                while (expectedEmployeeSelect.options.length > 1) expectedEmployeeSelect.remove(1);
                
                // 근무 중인 직원만 필터링
                const activeEmployees = employees.filter(emp => emp.isActive);
                
                // 직원 옵션 추가 - 이름(사번) 형식으로 표시
                activeEmployees.forEach(employee => {
                    const displayText = `\${employee.name} (\${employee.id})`;
                    employeeSelect.add(new Option(displayText, employee.id));
                    historyEmployee.add(new Option(displayText, employee.id));
                    expectedEmployeeSelect.add(new Option(displayText, employee.id));
                });
            } catch (error) {
                console.error('직원 정보 로딩 오류:', error);
                showError('직원 정보를 불러오는데 실패했습니다.');
            }
        }
        
        // 급여 계산하기
        async function calculateSalary() {
            const employeeId = document.getElementById('employeeSelect').value;
            const yearMonth = document.getElementById('yearMonth').value;
            
            if (!employeeId || !yearMonth) {
                showError('직원과 급여 계산 월을 선택해주세요.');
                return;
            }
            
            // 로딩 표시 시작
            document.getElementById('loading').style.display = 'block';
            document.getElementById('errorMessage').style.display = 'none';
            
            try {
                // 실제 급여 계산 API 호출
                const response = await fetch('/api/salary/calculate', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        employeeId: employeeId,
                        month: yearMonth,
                    })
                });
                
                if (!response.ok) {
                    const errorData = await response.json();
                    throw new Error(errorData.message || '급여 계산 중 오류가 발생했습니다.');
                }
                
                const salary = await response.json();
                
                // 예상 급여 정보도 함께 가져오기
                let expectedSalary = null;
                try {
                    const expectedResponse = await fetch('/api/salary/expected', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            employeeId: employeeId,
                            month: yearMonth
                        })
                    });
                    
                    if (expectedResponse.ok) {
                        expectedSalary = await expectedResponse.json();
                    }
                } catch (expectedError) {
                    // 예상 급여 오류는 무시하고 계속 진행
                }
                
                // 결과 영역 설정
                document.getElementById('actualResult').style.display = 'block';
                document.getElementById('expectedResult').style.display = 'none';
                
                displaySalaryResult(salary, expectedSalary);
                
            } catch (error) {
                console.error('급여 계산 오류:', error);
                showError(error.message || '급여 계산 중 오류가 발생했습니다.');
            } finally {
                // 로딩 표시 종료
                document.getElementById('loading').style.display = 'none';
            }
        }
        
        // 예상 급여 계산
        async function calculateExpectedSalary() {
            const employeeId = document.getElementById('expectedEmployeeSelect').value;
            const yearMonth = document.getElementById('expectedYearMonth').value;
            
            // 입력값 검증
            if (!employeeId || employeeId === '') {
                showError('직원을 선택해주세요.');
                return;
            }
            
            if (!yearMonth || yearMonth === '') {
                showError('급여 계산 월을 선택해주세요.');
                return;
            }
            
            // 로딩 표시 시작
            document.getElementById('loading').style.display = 'block';
            document.getElementById('errorMessage').style.display = 'none';
            
            try {
                // employeeId를 숫자로 변환
                const numericEmployeeId = parseInt(employeeId, 10);
                if (isNaN(numericEmployeeId)) {
                    throw new Error('유효하지 않은 직원 ID입니다.');
                }
                
                // 예상 급여 계산 API 호출
                const expectedResponse = await fetch('/api/salary/expected', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        employeeId: numericEmployeeId,
                        month: yearMonth
                    })
                });
                
                if (!expectedResponse.ok) {
                    let errorMessage = '예상 급여 계산 중 오류가 발생했습니다.';
                    try {
                        const errorData = await expectedResponse.json();
                        errorMessage = errorData.message || errorMessage;
                    } catch (e) {
                        console.error('예상 급여 API 오류 응답 파싱 실패:', e);
                    }
                    throw new Error(errorMessage);
                }
                
                const expectedSalary = await expectedResponse.json();
                
                // 결과 영역 설정
                document.getElementById('actualResult').style.display = 'none';
                document.getElementById('expectedResult').style.display = 'block';
                
                displayExpectedSalaryResult(expectedSalary);
                
            } catch (error) {
                console.error('예상 급여 계산 오류:', error);
                showError(error.message || '예상 급여 계산 중 오류가 발생했습니다.');
            } finally {
                // 로딩 표시 종료
                document.getElementById('loading').style.display = 'none';
            }
        }
        
        // 급여 결과 표시
        function displaySalaryResult(salary, expectedSalary = null) {
            // 직원 정보 표시 (이름과 사번)
            const employeeSelect = document.getElementById('employeeSelect');
            const selectedOption = employeeSelect.options[employeeSelect.selectedIndex];
            const employeeName = selectedOption.text; // 이미 "이름 (사번)" 형식으로 표시됨
            
            // 결과 필드 업데이트
            document.getElementById('resultName').textContent = employeeName;
            document.getElementById('resultPeriod').textContent = formatYearMonth(salary.month);
            document.getElementById('resultHourlyWage').textContent = formatCurrency(salary.employee.hourlyWage) + '원';
            document.getElementById('resultTotalHours').textContent = formatNumber(salary.totalHours) + '시간';
            document.getElementById('resultBaseSalary').textContent = formatCurrency(salary.baseSalary) + '원';
            document.getElementById('resultHolidayBonus').textContent = formatCurrency(salary.holidayBonus) + '원';
            document.getElementById('resultTotalSalary').textContent = formatCurrency(salary.totalSalary) + '원';
            
            // 주휴수당이 0원인 경우 안내 메시지 추가
            const holidayBonusElement = document.getElementById('resultHolidayBonus');
            if (salary.holidayBonus && salary.holidayBonus == 0) {
                holidayBonusElement.innerHTML = '0원 <small style="font-size: 12px; color: #888;">(주 15시간 미만 근무)</small>';
            }
            
            // 예상 급여 정보가 있으면 표시
            if (expectedSalary) {
                document.getElementById('resultExpectedTotalHours').textContent = formatNumber(expectedSalary.totalHours) + '시간';
                document.getElementById('resultExpectedBaseSalary').textContent = formatCurrency(expectedSalary.baseSalary) + '원';
                document.getElementById('resultExpectedHolidayBonus').textContent = formatCurrency(expectedSalary.holidayBonus) + '원';
                document.getElementById('resultExpectedTotalSalary').textContent = formatCurrency(expectedSalary.totalSalary) + '원';
                
                // 주휴수당이 0원인 경우 안내 메시지 추가
                if (!expectedSalary.holidayBonus || expectedSalary.holidayBonus == 0) {
                    document.getElementById('resultExpectedHolidayBonus').innerHTML = '0원 <small style="font-size: 12px; color: #888;">(주 15시간 미만 근무)</small>';
                }
            } else {
                // 예상 정보가 없는 경우 '-' 표시
                document.getElementById('resultExpectedTotalHours').textContent = '-';
                document.getElementById('resultExpectedBaseSalary').textContent = '-';
                document.getElementById('resultExpectedHolidayBonus').textContent = '-';
                document.getElementById('resultExpectedTotalSalary').textContent = '-';
            }
            
            // 결과 섹션 표시
            document.getElementById('resultSection').style.display = 'block';
            
            // 결과 영역으로 자동 스크롤
            setTimeout(() => {
                document.getElementById('resultSection').scrollIntoView({ behavior: 'smooth', block: 'start' });
            }, 100);
        }
        
        // 예상 급여 결과 표시
        function displayExpectedSalaryResult(expectedSalary) {
            // 직원 정보 표시 (이름과 사번)
            const employeeSelect = document.getElementById('expectedEmployeeSelect');
            const selectedOption = employeeSelect.options[employeeSelect.selectedIndex];
            const employeeName = selectedOption.text; // 이미 "이름 (사번)" 형식으로 표시됨
            
            // 결과 필드 업데이트 (서버에서 온 이름 대신 선택된 옵션의 텍스트 사용)
            document.getElementById('expectedResultName').textContent = employeeName;
            document.getElementById('expectedResultPeriod').textContent = formatYearMonth(expectedSalary.month);
            document.getElementById('expectedResultHourlyWage').textContent = formatCurrency(expectedSalary.hourlyWage) + '원';
            document.getElementById('expectedResultTotalHours').textContent = formatNumber(expectedSalary.totalHours) + '시간';
            document.getElementById('expectedResultBaseSalary').textContent = formatCurrency(expectedSalary.baseSalary) + '원';
            document.getElementById('expectedResultHolidayBonus').textContent = formatCurrency(expectedSalary.holidayBonus) + '원';
            document.getElementById('expectedResultTotalSalary').textContent = formatCurrency(expectedSalary.totalSalary) + '원';
            
            // 주휴수당이 0원인 경우 안내 메시지 추가
            if (!expectedSalary.holidayBonus || expectedSalary.holidayBonus == 0) {
                document.getElementById('expectedResultHolidayBonus').innerHTML = '0원 <small style="font-size: 12px; color: #888;">(주 15시간 미만 근무)</small>';
            }
            
            // 결과 섹션 표시
            document.getElementById('resultSection').style.display = 'block';
            
            // 결과 영역으로 자동 스크롤
            setTimeout(() => {
                document.getElementById('resultSection').scrollIntoView({ behavior: 'smooth', block: 'start' });
            }, 100);
        }
        
        // 급여 내역 조회
        async function searchSalaryHistory() {
            const historyType = document.getElementById('historySelect').value;
            
            if (historyType === 'employee') {
                const employeeId = document.getElementById('historyEmployee').value;
                if (!employeeId) {
                    showError('직원을 선택해주세요.');
                    return;
                }
                const url = `/api/salary/employee/\${employeeId}`;
                
                try {
                    const response = await fetch(url);
                    if (!response.ok) throw new Error('급여 내역을 불러오는데 실패했습니다.');
                    
                    const salaries = await response.json();
                    displaySalaryHistory(salaries, false);
                } catch (error) {
                    console.error('급여 내역 조회 오류:', error);
                    showError(error.message);
                }
            } else {
                const month = document.getElementById('historyMonth').value;
                if (!month || month.trim() === '') {
                    showError('월을 선택해주세요.');
                    return;
                }
                
                // 월 형식 검증 (YYYY-MM)
                if (!/^\d{4}-\d{2}$/.test(month)) {
                    showError('올바른 월 형식(YYYY-MM)을 선택해주세요.');
                    return;
                }
                
                const url = `/api/salary/month/\${month}`;
                
                try {
                    // 로딩 표시 추가
                    document.getElementById('historyTableBody').innerHTML = '<tr><td colspan="7" class="text-center"><i class="fas fa-spinner fa-spin"></i> 데이터를 불러오는 중...</td></tr>';
                    
                    // 1. 월별 급여 내역 조회
                    const response = await fetch(url);
                    if (!response.ok) {
                        const errorData = await response.json().catch(() => ({}));
                        throw new Error(errorData.message || '급여 내역을 불러오는데 실패했습니다.');
                    }
                    
                    const salaries = await response.json();
                    
                    // 2. 월별 급여 합계 조회
                    if (salaries.length > 0) {
                        const totalResponse = await fetch(`/api/salary/total/\${month}`);
                        if (totalResponse.ok) {
                            const totalSalary = await totalResponse.json();
                            displaySalaryHistory(salaries, true, month, totalSalary);
                            return;
                        }
                    }
                    
                    // 합계를 가져오지 못한 경우 기본 표시
                    displaySalaryHistory(salaries, false);
                } catch (error) {
                    console.error('급여 내역 조회 오류:', error);
                    showError(error.message);
                }
            }
        }
        
        // 급여 내역 표시
        function displaySalaryHistory(salaries, isMonthly = false, month = null, totalSalary = null) {
            const tableBody = document.getElementById('historyTableBody');
            tableBody.innerHTML = '';
            
            if (!salaries || salaries.length === 0) {
                tableBody.innerHTML = '<tr><td colspan="7" style="text-align: center;">조회된 급여 내역이 없습니다.</td></tr>';
                return;
            }
            
            salaries.forEach(salary => {
                const row = document.createElement('tr');
                
                // 주휴수당 표시 처리
                let holidayBonusDisplay = `\${formatCurrency(salary.holidayBonus)}원`;
                if (salary.holidayBonus == 0) {
                    holidayBonusDisplay = `0원 <small style="font-size: 12px; color: #888;">(미지급)</small>`;
                }
                
                // 계산 일자 추출
                let calculationDate = '-';
                
                // 가능한 모든 날짜 필드 확인
                const dateField = salary.updatedAt || salary.updateDate || salary.lastModifiedDate || salary.calculationDate || salary.createdAt || null;
                
                if (dateField) {
                    try {
                        // 날짜가 배열 형태로 오는 경우 ([연, 월, 일, 시, 분, 초, 나노초])
                        if (Array.isArray(dateField) && dateField.length >= 3) {
                            const year = dateField[0];
                            const month = dateField[1] - 1; 
                            const day = dateField[2];
                            const hour = dateField.length > 3 ? dateField[3] : 0;
                            const minute = dateField.length > 4 ? dateField[4] : 0;
                            
                            const dateObj = new Date(year, month, day, hour, minute);
                            if (!isNaN(dateObj.getTime())) {
                                calculationDate = dateObj.toLocaleString('ko-KR', {
                                    year: 'numeric',
                                    month: 'long',
                                    day: 'numeric',
                                    hour: '2-digit',
                                    minute: '2-digit'
                                });
                            }
                        } else {
                            // 문자열 형태의 날짜인 경우
                            const dateObj = new Date(dateField);
                            if (!isNaN(dateObj.getTime())) {
                                calculationDate = dateObj.toLocaleString('ko-KR', {
                                    year: 'numeric',
                                    month: 'long',
                                    day: 'numeric',
                                    hour: '2-digit',
                                    minute: '2-digit'
                                });
                            }
                        }
                    } catch (e) {
                        console.error('날짜 변환 오류:', e);
                    }
                }
                
                row.innerHTML = `
                    <td>\${salary.employee.name}</td>
                    <td>\${formatYearMonth(salary.month)}</td>
                    <td>\${formatNumber(salary.totalHours)}시간</td>
                    <td>\${formatCurrency(salary.baseSalary)}원</td>
                    <td>\${holidayBonusDisplay}</td>
                    <td>\${formatCurrency(salary.totalSalary)}원</td>
                    <td>\${calculationDate}</td>
                `;
                
                tableBody.appendChild(row);
            });
            
            // 월별 조회일 때만 합계 행 추가
            if (isMonthly && totalSalary !== null) {
                // 월 표시가 없는 경우 첫 번째 급여 기록에서 월 정보 가져오기
                const displayMonth = month || (salaries.length > 0 ? salaries[0].month : '');
                
                // 간격을 위한 빈 행 추가
                const spacerRow = document.createElement('tr');
                spacerRow.style.height = '30px';
                tableBody.appendChild(spacerRow);
                
                const totalRow = document.createElement('tr');
                totalRow.style.backgroundColor = '#f5f5f5';
                totalRow.style.borderTop = '2px solid #dee2e6';
                totalRow.style.borderBottom = '2px solid #dee2e6';
                
                totalRow.innerHTML = `
                    <td colspan="4" style="text-align: right; color: #495057; font-weight: 600; font-size: 0.95em; padding: 8px 12px;">【 \${formatYearMonth(displayMonth)} 급여 합계 】</td>
                    <td colspan="3" style="font-weight: 700; color: #0d6efd; font-size: 1.05em; padding: 8px 12px;">\${formatCurrency(totalSalary)}원</td>
                `;
                
                tableBody.appendChild(totalRow);
            }
            
            // 검색 결과 테이블로 자동 스크롤
            setTimeout(() => {
                document.getElementById('historyTableBody').scrollIntoView({ behavior: 'smooth', block: 'start' });
            }, 100);
        }
        
        // 조회 방식 변경 이벤트 핸들러
        function handleHistoryTypeChange() {
            const historyType = document.getElementById('historySelect').value;
            
            if (historyType === 'employee') {
                document.getElementById('historyEmployeeGroup').style.display = 'block';
                document.getElementById('historyMonthGroup').style.display = 'none';
            } else {
                document.getElementById('historyEmployeeGroup').style.display = 'none';
                document.getElementById('historyMonthGroup').style.display = 'block';
            }
        }
        
        // 오류 메시지 표시
        function showError(message) {
            const errorElement = document.getElementById('errorMessage');
            errorElement.textContent = message;
            errorElement.style.display = 'block';
        }
        
        // 유틸리티 함수
        function formatNumber(number) {
            return parseFloat(number).toFixed(2).replace(/\.00$/, '');
        }
        
        function formatCurrency(amount) {
            return parseInt(amount).toLocaleString('ko-KR');
        }
        
        function formatYearMonth(yearMonth) {
            if (!yearMonth) return '-';
            
            const [year, month] = yearMonth.split('-');
            return `\${year}년 \${month}월`;
        }
        
        // 전체 직원 급여 일괄 계산
        async function calculateAllSalaries() {
            const yearMonth = document.getElementById('allYearMonth').value;
            
            if (!yearMonth) {
                showError('급여 계산 월을 선택해주세요.');
                return;
            }
            
            // 로딩 표시 시작
            document.getElementById('loading').style.display = 'block';
            document.getElementById('errorMessage').style.display = 'none';
            document.getElementById('allCalculationResult').style.display = 'none';
            
            try {
                // 전체 급여 일괄 계산 API 호출
                const response = await fetch(`/api/salary/calculate-all/\${yearMonth}`, {
                    method: 'POST'
                });
                
                let result;
                try {
                    result = await response.json();
                    console.log('API 응답:', result); // 디버깅용 로그
                } catch (jsonError) {
                    console.error('JSON 파싱 오류:', jsonError);
                    throw new Error('응답 데이터를 처리할 수 없습니다.');
                }
                
                if (!response.ok) {
                    const errorMessage = result.message || '급여 일괄 계산 중 오류가 발생했습니다.';
                    throw new Error(errorMessage);
                }
                
                // 성공 메시지 표시 및 테이블 업데이트
                const summaryElement = document.getElementById('allCalculationSummary');
                const tableBody = document.getElementById('allCalculationTableBody');
                
                // 응답 데이터 구조 처리
                let salaryData;
                
                // ApiResponse 형태인 경우
                if (result.success !== undefined && Array.isArray(result.data)) {
                    salaryData = result.data;
                } 
                // 직접 배열인 경우
                else if (Array.isArray(result)) {
                    salaryData = result;
                }
                // 다른 형태의 응답
                else {
                    console.error('예상치 못한 응답 형식:', result);
                    throw new Error('응답 데이터 형식이 올바르지 않습니다.');
                }
                
                console.log('처리할 데이터:', salaryData); // 디버깅용 로그
                
                if (salaryData.length > 0) {
                    // 결과 요약 표시
                    summaryElement.textContent = `\${formatYearMonth(yearMonth)} 기준 총 \${salaryData.length}명의 직원 급여가 성공적으로 계산되었습니다.`;
                    
                    // 테이블 내용 초기화
                    tableBody.innerHTML = '';
                    
                    // 결과 테이블에 각 직원 데이터 추가
                    for (let i = 0; i < salaryData.length; i++) {
                        const employee = salaryData[i];
                        console.log('직원 데이터:', employee); // 디버깅용 로그
                        const row = document.createElement('tr');
                        
                        // 직원 이름 추출 로직 - 다양한 응답 형식 대응
                        let employeeName = '알 수 없음';
                        if (employee.employeeName) {
                            employeeName = employee.employeeName; // SalarySimpleDto 형식
                        } else if (employee.employee && employee.employee.name) {
                            employeeName = employee.employee.name; // Salary 엔티티 형식
                        }
                        
                        // 시급 추출
                        let hourlyWage = 0;
                        if (employee.hourlyWage) {
                            hourlyWage = employee.hourlyWage;
                        } else if (employee.employee && employee.employee.hourlyWage) {
                            hourlyWage = employee.employee.hourlyWage;
                        }

                        // 급여 정보 추출
                        let totalHours = employee.totalHours || 0;
                        let baseSalary = employee.baseSalary || 0;
                        let holidayBonus = employee.holidayBonus || 0;
                        let totalSalary = employee.totalSalary || 0;
                        
                        row.innerHTML = `
                            <td>\${employeeName}</td>
                            <td>\${formatCurrency(hourlyWage)}원</td>
                            <td>\${formatNumber(totalHours)}시간</td>
                            <td>\${formatCurrency(baseSalary)}원</td>
                            <td>\${formatCurrency(holidayBonus)}원</td>
                            <td>\${formatCurrency(totalSalary)}원</td>
                        `;
                        
                        tableBody.appendChild(row);
                    }
                    
                    // 결과 표시
                    document.getElementById('allCalculationResult').style.display = 'block';
                    
                    // 결과 영역으로 자동 스크롤
                    setTimeout(() => {
                        document.getElementById('allCalculationResult').scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }, 100);
                } else {
                    showError('계산된 급여 데이터가 없습니다.');
                }
            } catch (error) {
                console.error('급여 일괄 계산 오류:', error);
                showError(error.message || '급여 일괄 계산 중 오류가 발생했습니다.');
            } finally {
                // 로딩 표시 종료
                document.getElementById('loading').style.display = 'none';
            }
        }
        
        // 이벤트 리스너 등록
        document.addEventListener('DOMContentLoaded', function() {
            // 초기 데이터 로드
            fetchEmployees();
            
            // 현재 월 설정
            const now = new Date();
            const currentYearMonth = `\${now.getFullYear()}-\${String(now.getMonth() + 1).padStart(2, '0')}`;
            document.getElementById('yearMonth').value = currentYearMonth;
            document.getElementById('historyMonth').value = currentYearMonth;
            document.getElementById('expectedYearMonth').value = currentYearMonth;
            document.getElementById('allYearMonth').value = currentYearMonth;
            
            // 폼 제출 방지를 위한 이벤트 처리
            document.querySelectorAll('form').forEach(form => {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();
                    return false;
                });
            });
            
            // 버튼 이벤트 리스너
            document.getElementById('calculateBtn').addEventListener('click', calculateSalary);
            document.getElementById('calculateExpectedBtn').addEventListener('click', calculateExpectedSalary);
            document.getElementById('calculateAllBtn').addEventListener('click', calculateAllSalaries);
            document.getElementById('searchHistoryBtn').addEventListener('click', searchSalaryHistory);
            
            // 조회 방식 변경 이벤트
            document.getElementById('historySelect').addEventListener('change', handleHistoryTypeChange);
            
            // 초기 조회 방식 상태 설정
            handleHistoryTypeChange();
            
            // 월 입력 필드 검증
            document.getElementById('historyMonth').addEventListener('change', function() {
                const value = this.value;
                if (!value || value.trim() === '') {
                    this.value = currentYearMonth; // 값이 비어있으면 현재 연월로 설정
                }
            });
            
            // 탭 변경 시 결과 영역 초기화 및 탭 스타일 변경
            document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(tab => {
                tab.addEventListener('shown.bs.tab', function (e) {
                    // 결과 영역 숨기기
                    document.getElementById('resultSection').style.display = 'none';
                    
                    // 에러 메시지 숨기기
                    document.getElementById('errorMessage').style.display = 'none';
                    
                    // 일괄 계산 결과 숨기기
                    document.getElementById('allCalculationResult').style.display = 'none';
                    
                    // 모든 탭 스타일 초기화
                    document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(t => {
                        t.style.backgroundColor = '#f8f9fa';
                        t.style.color = '#495057';
                    });
                    
                    // 활성화된 탭 스타일 설정
                    e.target.style.backgroundColor = '#007bff';
                    e.target.style.color = 'white';
                    
                    // 직원 선택값 동기화
                    if (e.target.id === 'expected-tab') {
                        // 실제 급여 계산 탭 -> 예상 급여 계산 탭으로 전환 시
                        const selectedEmployeeId = document.getElementById('employeeSelect').value;
                        if (selectedEmployeeId) {
                            document.getElementById('expectedEmployeeSelect').value = selectedEmployeeId;
                        }
                        
                        // 연월 값도 동기화
                        const selectedYearMonth = document.getElementById('yearMonth').value;
                        if (selectedYearMonth) {
                            document.getElementById('expectedYearMonth').value = selectedYearMonth;
                        }
                    } else if (e.target.id === 'actual-tab') {
                        // 예상 급여 계산 탭 -> 실제 급여 계산 탭으로 전환 시
                        const selectedEmployeeId = document.getElementById('expectedEmployeeSelect').value;
                        if (selectedEmployeeId) {
                            document.getElementById('employeeSelect').value = selectedEmployeeId;
                        }
                        
                        // 연월 값도 동기화
                        const selectedYearMonth = document.getElementById('expectedYearMonth').value;
                        if (selectedYearMonth) {
                            document.getElementById('yearMonth').value = selectedYearMonth;
                        }
                    } else if (e.target.id === 'all-tab') {
                        // 다른 탭에서 전체 계산 탭으로 전환 시 연월 값 동기화
                        const activeTab = document.querySelector('.tab-pane.active');
                        if (activeTab.id === 'actual-content') {
                            const selectedYearMonth = document.getElementById('yearMonth').value;
                            if (selectedYearMonth) {
                                document.getElementById('allYearMonth').value = selectedYearMonth;
                            }
                        } else if (activeTab.id === 'expected-content') {
                            const selectedYearMonth = document.getElementById('expectedYearMonth').value;
                            if (selectedYearMonth) {
                                document.getElementById('allYearMonth').value = selectedYearMonth;
                            }
                        }
                    }
                });
            });
        });
    </script>
</body>
</html> 