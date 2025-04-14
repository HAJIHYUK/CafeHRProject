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
            
            <ul class="nav nav-tabs" id="salaryTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="actual-tab" data-bs-toggle="tab" data-bs-target="#actual-content" type="button" role="tab" aria-controls="actual-content" aria-selected="true" style="background-color: #007bff; color: white;">
                        <i class="fas fa-file-invoice-dollar"></i> 실제 급여 계산
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="expected-tab" data-bs-toggle="tab" data-bs-target="#expected-content" type="button" role="tab" aria-controls="expected-content" aria-selected="false" style="background-color: #f8f9fa; color: #495057;">
                        <i class="fas fa-chart-line"></i> 예상 급여 계산
                    </button>
                </li>
            </ul>
            <div class="tab-content pt-3" id="salaryTabsContent">
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
            </div>
            
            <div id="loading" class="loading">
                <i class="fas fa-spinner"></i> 계산 중...
            </div>
            
            <div id="errorMessage" class="error-message"></div>
        </div>
        
        <div id="resultSection" class="result-section">
            <h2>급여 계산 결과</h2>
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
                    <span class="result-label">예상 주휴수당</span>
                    <span id="resultExpectedHolidayBonus" class="result-value">-</span>
                </div>
                <div class="result-row">
                    <span class="result-label">주휴수당 (주 15시간 이상 근무 시)</span>
                    <span id="resultHolidayBonus" class="result-value">-</span>
                </div>
                <div class="result-row">
                    <span class="result-label">예상 최종급여</span>
                    <span id="resultExpectedTotalSalary" class="result-value">-</span>
                </div>
                <div class="total-row">
                    <span class="result-label">최종 급여</span>
                    <span id="resultTotalSalary" class="result-value">-</span>
                </div>
            </div>
            
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
        
        <div class="form-section history-section">
            <h2><i class="fas fa-history"></i> 급여 내역</h2>
            <p style="margin-bottom: 20px; color: var(--text-light);">
                이전에 계산된 급여 내역을 조회합니다. 모든 급여 기록은 실제 출퇴근 시간과 주휴수당 계산 결과를 포함합니다.
            </p>
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
                while (employeeSelect.options.length > 1) {
                    employeeSelect.remove(1);
                }
                
                while (historyEmployee.options.length > 1) {
                    historyEmployee.remove(1);
                }
                
                while (expectedEmployeeSelect.options.length > 1) {
                    expectedEmployeeSelect.remove(1);
                }
                
                // 근무 중인 직원만 필터링
                const activeEmployees = employees.filter(emp => emp.isActive);
                
                // 직원 옵션 추가
                activeEmployees.forEach(employee => {
                    const option = new Option(`\${employee.name} (\${employee.id})`, employee.id);
                    const historyOption = new Option(`\${employee.name} (\${employee.id})`, employee.id);
                    const expectedOption = new Option(`\${employee.name} (\${employee.id})`, employee.id);
                    
                    employeeSelect.add(option);
                    historyEmployee.add(historyOption);
                    expectedEmployeeSelect.add(expectedOption);
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
                console.log(`실제 급여 계산 요청: employeeId=${employeeId}, month=${yearMonth}`);
                
                // 1. 실제 급여 계산 API 호출
                const response = await fetch('/api/salary/calculate', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
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
                console.log("실제 급여 계산 결과:", salary);
                
                // 2. 예상 급여 계산 API 호출 - 실제 급여 계산과 동일한 직원/월 정보로 호출
                console.log(`예상 급여 계산 요청: employeeId=${employeeId}, month=${yearMonth}`);
                const expectedResponse = await fetch(`/api/salary/expected/${employeeId}/${yearMonth}`);
                
                if (!expectedResponse.ok) {
                    console.error("예상 급여 계산 API 오류:", await expectedResponse.text());
                    throw new Error('예상 급여 계산 중 오류가 발생했습니다.');
                }
                
                const expectedData = await expectedResponse.json();
                console.log("예상 급여 계산 결과:", expectedData);
                
                // 실제 급여 결과 표시 (예상 급여 데이터도 함께 전달)
                document.getElementById('actualResult').style.display = 'block';
                document.getElementById('expectedResult').style.display = 'none';
                
                displaySalaryResult(salary, expectedData);
                
            } catch (error) {
                console.error('급여 계산 오류:', error);
                showError(error.message || '급여 계산 중 오류가 발생했습니다.');
            } finally {
                // 로딩 표시 종료
                document.getElementById('loading').style.display = 'none';
            }
        }
        
        // 예상 급여 계산하기
        async function calculateExpectedSalary() {
            const employeeId = document.getElementById('expectedEmployeeSelect').value;
            const yearMonth = document.getElementById('expectedYearMonth').value;
            
            if (!employeeId || !yearMonth) {
                showError('직원과 급여 계산 월을 선택해주세요.');
                return;
            }
            
            // 로딩 표시 시작
            document.getElementById('loading').style.display = 'block';
            document.getElementById('errorMessage').style.display = 'none';
            
            try {
                console.log(`예상 급여 계산 요청: employeeId=${employeeId}, month=${yearMonth}`);
                const response = await fetch(`/api/salary/expected/${employeeId}/${yearMonth}`);
                
                if (!response.ok) {
                    const errorData = await response.json();
                    throw new Error(errorData.message || '예상 급여 계산 중 오류가 발생했습니다.');
                }
                
                const expectedSalary = await response.json();
                console.log("예상 급여 계산 결과:", expectedSalary);
                
                // 예상 급여 결과 표시
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
        function displaySalaryResult(salary, expectedData) {
            // 직원 이름 조회
            const employeeSelect = document.getElementById('employeeSelect');
            const selectedOption = employeeSelect.options[employeeSelect.selectedIndex];
            const employeeName = selectedOption.text;
            
            // 결과 필드 업데이트
            document.getElementById('resultName').textContent = employeeName;
            document.getElementById('resultPeriod').textContent = formatYearMonth(salary.month);
            document.getElementById('resultHourlyWage').textContent = formatCurrency(salary.employee.hourlyWage) + '원';
            document.getElementById('resultTotalHours').textContent = formatNumber(salary.totalHours) + '시간';
            document.getElementById('resultBaseSalary').textContent = formatCurrency(salary.baseSalary) + '원';
            
            // 예상 급여 데이터를 직접 사용
            if (expectedData) {
                // 예상 주휴수당 표시
                document.getElementById('resultExpectedHolidayBonus').textContent = formatCurrency(expectedData.holidayBonus) + '원';
                
                // 예상 주휴수당이 0원인 경우 안내 메시지 추가
                if (expectedData.holidayBonus == 0) {
                    document.getElementById('resultExpectedHolidayBonus').innerHTML = '0원 <small style="font-size: 12px; color: #888;">(주 15시간 미만 근무)</small>';
                }
                
                // 예상 최종 급여 표시
                document.getElementById('resultExpectedTotalSalary').textContent = formatCurrency(expectedData.totalSalary) + '원';
            } else {
                // 예상 데이터가 없는 경우 기본값 표시
                document.getElementById('resultExpectedHolidayBonus').textContent = '0원';
                document.getElementById('resultExpectedTotalSalary').textContent = '0원';
            }
            
            // 주휴수당 업데이트
            document.getElementById('resultHolidayBonus').textContent = formatCurrency(salary.holidayBonus) + '원';
            
            // 주휴수당이 0원인 경우 안내 메시지 추가
            const holidayBonusElement = document.getElementById('resultHolidayBonus');
            if (!salary.holidayBonus || salary.holidayBonus == 0) {
                holidayBonusElement.innerHTML = '0원 <small style="font-size: 12px; color: #888;">(주 15시간 미만 근무)</small>';
            }
            
            // 최종 급여 업데이트
            document.getElementById('resultTotalSalary').textContent = formatCurrency(salary.totalSalary) + '원';
            
            // 결과 섹션 표시
            document.getElementById('resultSection').style.display = 'block';
        }
        
        // 예상 급여 결과 표시
        function displayExpectedSalaryResult(expectedSalary) {
            console.log("예상 급여 표시 함수 호출됨:", expectedSalary);
            
            // 결과 필드 업데이트
            document.getElementById('expectedResultName').textContent = expectedSalary.employeeName;
            document.getElementById('expectedResultPeriod').textContent = formatYearMonth(expectedSalary.month);
            document.getElementById('expectedResultHourlyWage').textContent = formatCurrency(expectedSalary.hourlyWage) + '원';
            document.getElementById('expectedResultTotalHours').textContent = formatNumber(expectedSalary.totalHours) + '시간';
            document.getElementById('expectedResultBaseSalary').textContent = formatCurrency(expectedSalary.baseSalary) + '원';
            document.getElementById('expectedResultHolidayBonus').textContent = formatCurrency(expectedSalary.holidayBonus) + '원';
            document.getElementById('expectedResultTotalSalary').textContent = formatCurrency(expectedSalary.totalSalary) + '원';
            
            // 주휴수당이 0원인 경우 안내 메시지 추가
            const holidayBonusElement = document.getElementById('expectedResultHolidayBonus');
            if (expectedSalary.holidayBonus && expectedSalary.holidayBonus == 0) {
                holidayBonusElement.innerHTML = '0원 <small style="font-size: 12px; color: #888;">(주 15시간 미만 근무)</small>';
            }
            
            // 결과 섹션 표시
            document.getElementById('resultSection').style.display = 'block';
        }
        
        // 급여 내역 조회
        async function searchSalaryHistory() {
            const historyType = document.getElementById('historySelect').value;
            let url;
            
            if (historyType === 'employee') {
                const employeeId = document.getElementById('historyEmployee').value;
                if (!employeeId) {
                    showError('직원을 선택해주세요.');
                    return;
                }
                url = `/api/salary/employee/\${employeeId}`;
                
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
                if (!month) {
                    showError('월을 선택해주세요.');
                    return;
                }
                url = `/api/salary/month/\${month}`;
                
                try {
                    // 1. 월별 급여 내역 조회
                    const response = await fetch(url);
                    if (!response.ok) throw new Error('급여 내역을 불러오는데 실패했습니다.');
                    
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
            
            // 디버깅을 위해 첫 번째 급여 데이터 출력
            console.log('급여 데이터 샘플:', salaries[0]);
            
            salaries.forEach(salary => {
                const row = document.createElement('tr');
                
                // 주휴수당 표시 처리
                let holidayBonusDisplay = `\${formatCurrency(salary.holidayBonus)}원`;
                if (salary.holidayBonus == 0) {
                    holidayBonusDisplay = `0원 <small style="font-size: 12px; color: #888;">(미지급)</small>`;
                }
                
                // 계산 일자 추출 - 날짜가 배열로 오는 경우 처리
                let calculationDate = '-';
                
                // 가능한 모든 날짜 필드 확인
                const dateField = salary.updatedAt || salary.updateDate || salary.lastModifiedDate || salary.calculationDate || salary.createdAt || null;
                
                if (dateField) {
                    try {
                        // 날짜가 배열 형태로 오는 경우 ([연, 월, 일, 시, 분, 초, 나노초])
                        if (Array.isArray(dateField) && dateField.length >= 3) {
                            // JavaScript에서 월은 0부터 시작하므로 1을 빼줌
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
                        console.error('날짜 변환 오류:', e, dateField);
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
                
                // 인라인 스타일로 직접 적용
                totalRow.innerHTML = `
                    <td colspan="4" style="text-align: right; color: #495057; font-weight: 600; font-size: 0.95em; padding: 8px 12px;">【 \${formatYearMonth(displayMonth)} 급여 합계 】</td>
                    <td colspan="3" style="font-weight: 700; color: #0d6efd; font-size: 1.05em; padding: 8px 12px;">\${formatCurrency(totalSalary)}원</td>
                `;
                
                tableBody.appendChild(totalRow);
            }
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
        
        // 유틸리티: 숫자 포맷팅
        function formatNumber(number) {
            return parseFloat(number).toFixed(2).replace(/\.00$/, '');
        }
        
        // 유틸리티: 통화 포맷팅
        function formatCurrency(amount) {
            return parseInt(amount).toLocaleString('ko-KR');
        }
        
        // 유틸리티: 연월 포맷팅
        function formatYearMonth(yearMonth) {
            if (!yearMonth) return '-';
            
            const [year, month] = yearMonth.split('-');
            return `\${year}년 \${month}월`;
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
            
            // 버튼 이벤트 리스너
            document.getElementById('calculateBtn').addEventListener('click', calculateSalary);
            document.getElementById('calculateExpectedBtn').addEventListener('click', calculateExpectedSalary);
            document.getElementById('searchHistoryBtn').addEventListener('click', searchSalaryHistory);
            
            // 조회 방식 변경 이벤트
            document.getElementById('historySelect').addEventListener('change', handleHistoryTypeChange);
            
            // 탭 변경 시 결과 영역 초기화 및 탭 스타일 변경
            document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(tab => {
                tab.addEventListener('shown.bs.tab', function (e) {
                    // 결과 영역 숨기기
                    document.getElementById('resultSection').style.display = 'none';
                    // 에러 메시지 숨기기
                    document.getElementById('errorMessage').style.display = 'none';
                    
                    // 모든 탭 스타일 초기화
                    document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(t => {
                        t.style.backgroundColor = '#f8f9fa';
                        t.style.color = '#495057';
                    });
                    
                    // 활성화된 탭 스타일 설정
                    e.target.style.backgroundColor = '#007bff';
                    e.target.style.color = 'white';
                });
            });
        });
    </script>
</body>
</html> 