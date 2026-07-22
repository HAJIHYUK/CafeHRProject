# ☕ CafeHR : 소규모 매장을 위한 인사 관리 솔루션
> **"복잡한 주휴수당 계산부터 출퇴근 관리까지, 사장님을 위한 가장 간편한 HR 매니저"**

[![Java](https://img.shields.io/badge/Java-17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)]()
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.4-6DB33F?style=for-the-badge&logo=spring&logoColor=white)]()
[![JSP](https://img.shields.io/badge/JSP-Jakarta_EE-000000?style=for-the-badge&logo=jakartaee&logoColor=white)]()
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)]()
[![JPA](https://img.shields.io/badge/Spring_Data_JPA-Hibernate-59666C?style=for-the-badge&logo=hibernate&logoColor=white)]()
[![Bootstrap](https://img.shields.io/badge/Bootstrap-5.2-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)]()

<br>

> 🚨 **잠깐만요! 코드를 보시기 전에 꼭 읽어주세요.** 
> 이 프로젝트는 제가 백엔드와 스프링 부트의 기초를 막 다지던 시기에 작성한 초기 포트폴리오입니다. 
> 지금 다시 객체지향 설계와 클린 아키텍처의 관점에서 보니 부족한 점이 너무나도 많이 보이지만, 당시 저의 치열했던 고민과 노력의 흔적이기에 원본 그대로 남겨두었습니다.
> 코드를 보시기 전에 하단의 **[💡 프로젝트 회고 및 리팩토링 계획](#-프로젝트-회고-및-리팩토링-계획)**을 먼저 읽어주시면 감사하겠습니다!

<br>

## 📱 프로젝트 소개
**CafeHR**은 카페 및 소규모 매장에서 빈번하게 발생하는 **근태 관리의 번거로움**과 **복잡한 급여 계산(주휴수당)** 문제를 해결하기 위해 개발된 통합 관리 시스템입니다. 
매장 내 태블릿/PC를 키오스크처럼 활용하여 직원은 간편하게 출퇴근을 찍고, 관리자는 대시보드를 통해 모든 현황을 한눈에 파악할 수 있습니다.

*   **타겟 사용자:** 카페 점주, 소규모 매장 관리자
*   **개발 기간:** 2025.03 ~ 2025.04
*   **주요 특징:** 별도 앱 설치 없이 웹 브라우저만으로 키오스크 모드와 관리자 모드를 모두 지원합니다.

<br>

## 💡 개발 전략 (Development Strategy)
본 프로젝트는 **정확성(Accuracy)**과 **편의성(Usability)**을 최우선 가치로 두었습니다.

*   **Robust Calculation Logic:** 금전과 관련된 **급여 계산**은 1원의 오차도 없어야 합니다. 이를 위해 `BigDecimal`을 전면 도입하여 부동소수점 오차를 원천 차단하고, 근로기준법에 의거한 **주휴수당 자동 산정 알고리즘**을 구현했습니다.
*   **Kiosk-Style UX:** 바쁜 매장 환경을 고려하여, 로그인이 필요 없는 **'사원번호 기반 즉시 체크인'** 시스템을 구축했습니다. 이는 직원의 동선을 최소화하고 사용성을 극대화합니다.

<br>

## ✨ 핵심 기능 (Key Features)

### 1. 🏠 메인 홈 & 키오스크 모드
매장 입구의 태블릿에 띄워두고 사용하는 화면입니다. 직원은 사원번호 입력만으로 **1초 만에 출근/퇴근/메모 확인**이 가능합니다. 불필요한 로그인 세션을 제거하여 접근성을 높였습니다.

![메인홈화면](doc/images/메인홈화면.png)
*직원용 키오스크 모드와 관리자 메뉴가 통합된 메인 대시보드*

<br>

### 2. 🔐 관리자 보안 & 직원 관리
민감한 직원 정보와 급여 내역은 관리자만 접근할 수 있도록 **Spring Security**로 철저히 보호됩니다. 직원의 시급, 역할, 입사일 등을 체계적으로 관리합니다.

<div style="display: flex; gap: 10px;">
    <img src="doc/images/관리자%20로그인%20화면.png" width="48%" alt="관리자 로그인">
    <img src="doc/images/직원%20목록%20페이지.png" width="48%" alt="직원 목록">
</div>
*좌: 관리자 인증 화면 / 우: 전체 직원 현황 조회*

<br>

![직원등록](doc/images/직원등록.png)
*직원 정보 등록 화면 - 시급 및 개인 메모 설정 가능*

<br>

### 3. 📅 스마트 근무 일정 관리
단순 정보 등록을 넘어, 요일별 고정 근무 시간을 설정할 수 있습니다. 이 데이터는 추후 **'예상 급여'**를 산출하는 기초 데이터로 활용됩니다.

<div style="display: flex; gap: 10px;">
    <img src="doc/images/직원등록후%20근무일정%20등록.png" width="48%" alt="근무일정등록">
    <img src="doc/images/직원%20목록%20페이지에서%20직원%20스케쥴관리.png" width="48%" alt="스케줄관리">
</div>
*좌: 직원 등록 시 근무 요일/시간 설정 / 우: 직원별 상세 스케줄 관리 및 수정*

<br>

### 4. ⏰ 출퇴근 기록 & 실시간 근태 모니터링
직원들의 출퇴근 기록이 실시간으로 서버에 저장됩니다. 관리자는 날짜별/직원별로 기록을 조회하고, 누락된 기록을 직관적인 UI에서 수정할 수 있습니다.

![출퇴근기록](doc/images/출퇴근%20기록%20관리%20페이지.png)
*관리자용 출퇴근 기록 조회 및 수정 페이지*

<br>

### 5. 💰 급여 정산 시스템 (Core Feature)
**CafeHR**의 기술력이 집약된 핵심 기능입니다. 단순 시급 계산을 넘어, **주휴수당** 조건(주 15시간 이상 근무)을 자동으로 판단하여 정확한 급여 명세서를 생성합니다.

![급여계산기메인](doc/images/급여계산기%20페이지.png)
*월별 급여 관리 대시보드*

<br>

![급여결과](doc/images/급여계산기%20페이지에서%20급여%20계산결과%20.png)
*기본급 + 주휴수당이 합산된 최종 급여 명세*

<br>

#### 5-1. 예상 급여 시뮬레이션
등록된 근무 스케줄을 바탕으로 이번 달 예상 지출 인건비를 미리 계산해 볼 수 있습니다.

![예상급여](doc/images/급여계산기%20페이지에서%20예상급여%20계산.png)
*근무 스케줄 기반 예상 급여 시뮬레이션 결과*

<br>

#### 5-2. 실제 급여 정산
실제 출퇴근 기록(`Attendance`)을 기반으로 급여를 확정합니다. 지각/조퇴가 반영된 **실 근무시간**을 기준으로 계산됩니다.

![실제급여계산](doc/images/급여%20계산기%20페이지에서%20실제%20급여%20내역조회(출퇴근%20기록으로%20실제%20근무한%20시간%20값만으로%20계산).png)
*실제 근무 기록에 기반한 정밀 급여 산출*

<br>

## 🛠 기술적 고도화 (Technical Deep Dive)

### 🚀 1. 정밀한 주휴수당 계산 알고리즘 (Holiday Bonus Logic)
*   **Problem:** 주휴수당은 '1주 동안 소정근로일수를 개근하고 15시간 이상 근무'해야 발생합니다. 하지만 월(Month)의 시작과 끝이 주(Week)의 중간에 걸쳐 있을 때, **월말/월초의 근무 시간을 어떻게 배분할지**가 복잡한 문제입니다.
*   **Solution:** `SalaryService`에 **주 단위 파싱 로직**을 직접 구현했습니다.
    *   `YearMonth`를 기반으로 해당 월의 모든 날짜를 순회하며 표준 주(월~일) 단위로 그룹핑합니다.
    *   이전 달에서 넘어온 주와 다음 달로 넘어가는 주의 근무 시간을 정확히 분리하여, **해당 월 귀속분**만 계산하거나 필요시 이월시키는 로직을 적용했습니다.
*   **Result:** 법적 기준에 부합하는 정확한 주휴수당 자동 산출 성공.

### ⚡ 2. 동시성 제어 및 데이터 무결성
*   **Problem:** 키오스크 모드 특성상 여러 직원이 빠르게 연속으로 출퇴근 버튼을 누르거나, 네트워크 지연으로 인해 **중복 출근 기록**이 생성될 위험이 있습니다.
*   **Solution:**
    *   **Application Level:** `AttendanceService`에서 `existsByEmployeeAndCheckInBetween` 메서드로 금일 기록 존재 여부를 선제적으로 체크합니다.
    *   **Business Logic:** '출근 상태에서만 퇴근 가능', '퇴근 후 재출근 불가(당일)' 등의 상태 전이(State Transition) 규칙을 엄격하게 적용하여 데이터 오염을 방지했습니다.

### 📊 3. 금융 데이터 정합성 (BigDecimal)
*   **Problem:** 자바의 `double`이나 `float` 타입을 사용할 경우, 시급 계산 시 미세한 소수점 오차가 누적되어 최종 급여액이 달라지는 치명적인 문제가 발생할 수 있습니다.
*   **Solution:** `Employee`의 시급, `Attendance`의 근무 시간, `Salary`의 최종 급여 등 모든 수치 데이터에 **`BigDecimal`** 타입을 적용했습니다. 나눗셈 연산 시 `RoundingMode.HALF_UP`(반올림) 정책을 명시하여 1원 단위까지 정확성을 보장했습니다.

<br>

## 💡 프로젝트 회고 및 리팩토링 계획

이 프로젝트는 복잡한 주휴수당 계산 로직을 직접 구현해보며 자바(Java)와 스프링(Spring)에 대한 이해도를 크게 높여준 뜻깊은 첫 결과물입니다. 하지만 이후 객체지향 설계와 아키텍처에 대해 지속적으로 공부하며 성장한 지금 다시 코드를 보니, 당시에는 미처 몰랐던 많은 설계적 결함들이 눈에 띕니다. 코드 전체를 다시 짜기보다는, 과거의 제가 어떤 부분에서 부족했고 이를 앞으로 어떻게 리팩토링할 것인지 남기고자 합니다.

### 1. 비대해진 Service 계층과 도메인 지식 누수
*   **아쉬운 점:** `SalaryService` 파일 하나가 무려 600줄에 달하며 SRP(단일 책임 원칙)를 크게 위반하고 있습니다. 주휴수당 계산 로직, 날짜를 주(Week) 단위로 쪼개는 로직, DB 조회 로직이 전부 한 곳에 얽혀 있어 유지보수가 극히 어렵습니다.
*   **리팩토링 계획:** 주휴수당 계산기(`HolidayBonusCalculator`)와 주 단위 파서(`WeekParser`) 등을 별도의 도메인 서비스로 분리하여, 서비스 클래스는 흐름(Flow)만 제어하도록 쪼갤 계획입니다.

### 2. 빈약한 도메인 모델(Anemic Domain Model)과 무분별한 Setter
*   **아쉬운 점:** `Employee`, `Salary` 등 엔티티 클래스에 `@Setter`가 전면 개방되어 있고, 엔티티 내부에는 비즈니스 로직이 전혀 없습니다. 엔티티가 단순한 DTO 역할만 하고 있습니다.
*   **리팩토링 계획:** 무분별한 `@Setter`를 닫고, 상태 변경이 필요한 곳에는 `calculateTotalSalary()`나 `updateWage()`처럼 의미 있는 엔티티 내부 메서드를 구현하여 캡슐화를 강화할 것입니다.

### 3. @Transactional의 잘못된 트랜잭션 경계 설정
*   **아쉬운 점:** 전체 직원 급여를 계산하는 `calculateAllSalariesForMonth()`를 보면 바깥쪽 메서드에도 `@Transactional`이 걸려 있고 안쪽에도 걸려 있는데, 반복문 안에서 예외를 단순히 `try-catch`로 무시하려 하고 있습니다. 이는 스프링에서 `UnexpectedRollbackException`을 유발할 수 있는 위험한 설계입니다.
*   **리팩토링 계획:** 트랜잭션 전파(Propagation) 속성에 대한 이해를 바탕으로, 개별 급여 계산이 실패해도 다른 직원 급여 계산에 영향을 주지 않도록 트랜잭션 경계를 명확히 분리할 계획입니다.

### 4. 중복 코드 (DRY 원칙 위반)
*   **아쉬운 점:** `SalaryService` 내부에 `calculateWeeklyHours`와 `calculateExpectedWeeklyHours`라는 두 메서드가 사실상 거의 동일한 반복문과 달력 파싱 로직을 중복으로 들고 있습니다.
*   **리팩토링 계획:** 공통된 날짜 계산 로직을 별도의 유틸리티나 도메인 객체로 추출하여 재사용성을 높이고 중복 코드를 제거할 것입니다.

### 5. REST API 설계 오류 (행위가 포함된 URL)
*   **아쉬운 점:** `AttendanceRestController`의 엔드포인트를 보면 `/api/attendance/modify/{id}`, `/api/attendance/delete/{id}` 처럼 URL에 행위(동사)가 포함되어 있습니다. 이는 자원(Resource) 중심의 RESTful 원칙에 어긋나는 전형적인 초보적 실수입니다.
*   **리팩토링 계획:** HTTP 메서드(PUT, DELETE 등)의 의미를 올바르게 활용하여 `/api/attendance/{id}` 처럼 명사 중심의 깔끔한 REST API로 재설계할 예정입니다.

### 6. Controller 계층의 예외 처리 중복 (`@RestControllerAdvice` 활용 미흡)
*   **아쉬운 점:** 컨트롤러 곳곳에 비즈니스 예외(`IllegalArgumentException` 등)를 잡기 위한 `try-catch` 블록이 중복되어 있으며, 에러를 `Map`에 담아 리턴하는 등 응답 포맷이 파편화되어 있습니다.
*   **리팩토링 계획:** `@RestControllerAdvice`를 활용해 전역 예외 처리기(Global Exception Handler)로 에러 핸들링 로직을 한 곳에 모으고, 커스텀 예외 클래스와 `CommonResponse` 공통 응답 봉투(Envelope)를 도입하여 프론트엔드와 일관된 규약으로 통신하도록 개선할 것입니다.

<br>

## 💻 실행 방법 & 계정 정보

### Prerequisites
*   JDK 17
*   MySQL 8.0+

### Installation
1.  **Clone Repository**
    ```bash
    git clone https://github.com/HAJIHYUK/CafeHRProject.git
    ```
2.  **Configure Database** (`src/main/resources/application.properties`)
    ```properties
    spring.datasource.url=jdbc:mysql://localhost:3306/cafeHR_db?createDatabaseIfNotExist=true
    spring.datasource.username=your_username
    spring.datasource.password=your_password
    ```
3.  **Build & Run**
    ```bash
    ./gradlew bootRun
    ```

### 🔐 초기 관리자 계정 (Admin Account)
프로젝트 실행 시, 아래 계정으로 **관리자 기능**에 접근할 수 있습니다.

| ID | Password | Role |
|:---:|:---:|:---:|
| **admin** | **admin** | **ADMIN** |

---

<div align="center">
  <p>Created by <b>HAJIHYUK</b> | Powered by Spring Boot 3 & JSP</p>
</div>
