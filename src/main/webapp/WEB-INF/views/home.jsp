<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DieuMonde HR - 홈페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/cafeHR.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .menu-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .menu-link {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 30px;
            background: linear-gradient(135deg, var(--primary-light) 0%, var(--primary-color) 100%);
            color: white;
            text-decoration: none;
            border-radius: 16px;
            font-weight: bold;
            transition: var(--transition);
            text-align: center;
            box-shadow: 0 4px 10px rgba(255, 122, 0, 0.2);
            height: 180px;
        }
        
        .menu-link i {
            font-size: 3rem;
            margin-bottom: 15px;
        }
        
        .menu-link:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(255, 122, 0, 0.3);
            color: white;
        }
        
        .check-in-container {
            margin-bottom: 25px;
            padding: 25px;
            background-color: #f9f9f9;
            border-radius: 16px;
            box-shadow: var(--shadow);
        }
        
        .check-in-title {
            color: var(--primary-color);
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .check-in-form {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .check-in-input {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            font-size: 16px;
            transition: var(--transition);
        }
        
        .check-in-input:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 122, 0, 0.1);
        }
        
        .check-in-btn {
            background: linear-gradient(to right, #4CAF50, #45a049);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 25px;
            font-weight: bold;
            cursor: pointer;
            transition: var(--transition);
            white-space: nowrap;
        }
        
        .check-in-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(76, 175, 80, 0.3);
        }
        
        .check-out-btn {
            background: linear-gradient(to right, #2196F3, #1976D2);
        }
        
        .check-out-btn:hover {
            box-shadow: 0 4px 8px rgba(33, 150, 243, 0.3);
        }
        
        .memo-btn {
            background: linear-gradient(to right, #FFA000, #FF8F00);
        }
        
        .memo-btn:hover {
            box-shadow: 0 4px 8px rgba(255, 160, 0, 0.3);
        }
        
        @media (max-width: 768px) {
            .check-in-form {
                flex-direction: column;
            }
            
            .check-in-btn {
                width: 100%;
            }
        }
        
        .logo {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin-bottom: 5px;
            margin-top: -70px;
            text-align: center;
            position: relative;
        }
        
        .logo-text {
            font-size: 2.5rem;
            color: var(--primary-color);
            font-weight: bold;
            margin-top: 0;
            position: relative;
            z-index: 1;
            transform: translateY(0);
        }
        
        .logo-image {
            height: 300px;
            width: auto;
            object-fit: contain;
            object-position: center bottom;
        }
        
        h1 {
            margin-top: -5px;
            margin-bottom: 15px;
        }
        
        /* 로그아웃 버튼 스타일 */
        .logout-btn {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 15px;
            font-weight: bold;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            z-index: 1000;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        
        .logout-btn:hover {
            background-color: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .logout-btn i {
            font-size: 16px;
        }
    </style>
</head>
<body>
    <!-- 로그인 상태일 때만 로그아웃 버튼 표시 -->
    <c:if test="${isLoggedIn}">
        <form action="/logout" method="post" style="margin: 0; padding: 0;">
            <button type="submit" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> 로그아웃 (${username})
            </button>
        </form>
    </c:if>
    
    <div class="container">
        <div class="logo">
            <div style="position: relative; height: 390px; margin-bottom: 10px; margin-top: -30px; width: 100%;">
                <img src="/image/DieumondeLog4.png" alt="DieuMonde Logo" class="logo-image" style="position: absolute; top: 0; left: 50%; transform: translateX(-50%); height: 450px; width: 700px; object-fit: contain;">
            </div>
        </div>
        
        <div class="row" style="margin-top: -10px;">
            <div class="col-md-4 mb-4">
                <div class="check-in-container">
                    <h2 class="check-in-title"><i class="fas fa-sign-in-alt"></i> 출근 체크</h2>
                    <p>사원번호 입력 후 출근 체크</p>
                    <div class="check-in-form">
                        <input type="text" id="employeeCode" class="check-in-input" placeholder="사원번호 입력">
                        <button id="checkInBtn" class="check-in-btn">출근</button>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="check-in-container">
                    <h2 class="check-in-title" style="color: #2196F3;"><i class="fas fa-sign-out-alt"></i> 퇴근 체크</h2>
                    <p>사원번호 입력 후 퇴근 체크</p>
                    <div class="check-in-form">
                        <input type="text" id="checkOutEmployeeCode" class="check-in-input" placeholder="사원번호 입력">
                        <button id="checkOutBtn" class="check-in-btn check-out-btn">퇴근</button>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="check-in-container">
                    <h2 class="check-in-title" style="color: #FFA000;"><i class="fas fa-sticky-note"></i> 메모 확인</h2>
                    <p>사원번호 입력 후 메모 확인</p>
                    <div class="check-in-form">
                        <input type="text" id="memoEmployeeCode" class="check-in-input" placeholder="사원번호 입력">
                        <button id="checkMemoBtn" class="check-in-btn memo-btn">메모</button>
                    </div>
                </div>
            </div>
        </div>
        
        <h1>직원 관리 시스템</h1>
        
        <div class="menu-container">
            <a href="/employeeregistration" class="menu-link">
                <i class="fas fa-user-plus"></i>
                <span>직원 등록</span>
            </a>
            <a href="/employeelist" class="menu-link">
                <i class="fas fa-users"></i>
                <span>직원 목록</span>
            </a>
            <a href="/attendancelist" class="menu-link">
                <i class="fas fa-clipboard-list"></i>
                <span>출근 기록</span>
            </a>
            <a href="/salary" class="menu-link">
                <i class="fas fa-money-bill-wave"></i>
                <span>급여 계산기</span>
            </a>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('checkInBtn').addEventListener('click', async function() {
            const employeeCode = document.getElementById('employeeCode').value;
            
            if (!employeeCode) {
                alert('사원번호를 입력해주세요.');
                return;
            }
            
            try {
                console.log('출근 체크 시작:', employeeCode);
                
                const response = await fetch(`/api/attendance/check-in/\${employeeCode}`, {
                    method: 'POST'
                });
                
                if (!response.ok) {
                    const errorData = await response.json();
                    if (errorData && errorData.message) {
                        alert(errorData.message);
                        document.getElementById('employeeCode').value = '';
                        return;
                    }
                    throw new Error(`출근 체크 중 오류가 발생했습니다. (상태: \${response.status})`);
                }
                
                const data = await response.json();
                console.log('출근 체크 응답 데이터:', data);
                
                // 출근 시간 구하기 (현재 시간 사용)
                const now = new Date();
                const hours = now.getHours().toString().padStart(2, '0');
                const minutes = now.getMinutes().toString().padStart(2, '0');
                const seconds = now.getSeconds().toString().padStart(2, '0');
                const checkInTime = `\${hours}시 \${minutes}분 \${seconds}초`;
                
                alert(`\${data.name}님 \${checkInTime}에 출근하셨습니다.`);
                document.getElementById('employeeCode').value = '';
                
            } catch (error) {
                console.error('출근 체크 오류:', error);
                alert(error.message);
            }
        });
        
        document.getElementById('checkOutBtn').addEventListener('click', async function() {
            const employeeCode = document.getElementById('checkOutEmployeeCode').value;
            
            if (!employeeCode) {
                alert('사원번호를 입력해주세요.');
                return;
            }
            
            try {
                console.log('퇴근 체크 시작:', employeeCode);
                
                const response = await fetch(`/api/attendance/check-out/\${employeeCode}`, {
                    method: 'PUT'
                });
                
                if (!response.ok) {
                    const errorData = await response.json();
                    if (errorData && errorData.message) {
                        alert(errorData.message);
                        document.getElementById('checkOutEmployeeCode').value = '';
                        return;
                    }
                    throw new Error(`퇴근 체크 중 오류가 발생했습니다. (상태: \${response.status})`);
                }
                
                const data = await response.json();
                console.log('퇴근 체크 응답 데이터:', data);
                
                // 퇴근 시간 구하기 (현재 시간 사용)
                const now = new Date();
                const hours = now.getHours().toString().padStart(2, '0');
                const minutes = now.getMinutes().toString().padStart(2, '0');
                const seconds = now.getSeconds().toString().padStart(2, '0');
                const checkOutTime = `\${hours}시 \${minutes}분 \${seconds}초`;
                
                alert(`\${data.name}님 \${checkOutTime}에 퇴근하셨습니다.`);
                document.getElementById('checkOutEmployeeCode').value = '';
                
            } catch (error) {
                console.error('퇴근 체크 오류:', error);
                alert(error.message);
            }
        });
        
        // 메모 확인 버튼 기능
        document.getElementById('checkMemoBtn').addEventListener('click', async function() {
            const employeeCode = document.getElementById('memoEmployeeCode').value;
            
            if (!employeeCode) {
                alert('사원번호를 입력해주세요.');
                return;
            }
            
            try {
                const response = await fetch(`/api/employees/memo/\${employeeCode}`);
                if (!response.ok) {
                    const errorData = await response.json();
                    throw new Error(errorData.message || '직원 정보를 찾을 수 없습니다.');
                }
                
                const employeeMemo = await response.json();
                window.location.href = `/employeememo/\${employeeMemo.id}`;
                
            } catch (error) {
                alert(error.message);
                console.error('오류 발생:', error);
            }
        });
    </script>
</body>
</html>