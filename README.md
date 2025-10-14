# E-Commerce Project (test4)

## 1. 프로젝트 개요

본 프로젝트는 Gradle 멀티 모듈로 구성된 전자상거래 플랫폼입니다. 사용자(고객)를 위한 `shop` 모듈과 관리자를 위한 `admin` 모듈로 나뉘어 개발되었습니다. Spring Boot를 기반으로 하여 웹 애플리케이션을 구축하였으며, 다양한 기술 스택을 활용하여 안정적이고 확장 가능한 시스템을 목표로 합니다.

---

## 2. 모듈 구성

- **`shop`**: 고객이 상품을 보고, 검색하며, 구매하는 등 실제 쇼핑몰의 기능을 담고 있는 사용자용 애플리케이션입니다.
- **`admin`**: 상품, 고객, 주문 등을 관리하기 위한 관리자용 백오피스 애플리케이션입니다.

---

## 3. 주요 기능 (의존성 기반 추정)

- **보안**: Spring Security를 활용하여 사용자 인증 및 인가 기능을 구현합니다.
- **실시간 통신**: Spring WebSocket을 통해 실시간 채팅, 알림 등의 기능을 제공합니다.
- **데이터베이스**: MyBatis를 사용하여 데이터 영속성을 관리하며, MySQL 및 PostgreSQL 데이터베이스를 지원합니다.
- **암호화**: Jasypt 라이브러리를 통해 `application.yml`의 주요 설정(DB 정보 등)을 암호화하여 보안을 강화합니다.
- **페이징 처리**: PageHelper를 사용하여 대량의 데이터를 효율적으로 조회하고 화면에 표시합니다.
- **CSV 처리**: OpenCSV를 이용해 CSV 형식의 데이터를 가져오거나 내보내는 기능을 지원합니다.

---

## 4. 기술 스택

- **언어**: Java 17
- **프레임워크**: Spring Boot 3.4.10-SNAPSHOT
- **빌드 도구**: Gradle
- **데이터베이스**:
  - MyBatis
  - MySQL / PostgreSQL
- **보안**: Spring Security
- **실시간 통신**: Spring WebSocket, SockJS, STOMP
- **템플릿 엔진**: JSP, JSTL
- **서버**: Embedded Tomcat
- **기타 라이브러리**:
  - Lombok
  - Jasypt (설정 암호화)
  - PageHelper (페이징)
  - OpenCSV (CSV 처리)

---

## 5. 로컬 환경에서 실행하기

### 사전 요구사항

- Java 17
- Gradle
- MySQL 또는 PostgreSQL 데이터베이스

### 실행 절차

1.  **데이터베이스 설정**
    - 각 모듈의 `src/main/resources/application.yml` 또는 `application-dev.yml` 파일에 자신의 로컬 데이터베이스 환경에 맞게 접속 정보를 수정합니다.
    - Jasypt 암호화 키가 설정되어 있다면, 실행 환경 변수나 JVM 옵션에 해당 키를 추가해야 합니다.

2.  **애플리케이션 실행**
    - 프로젝트 루트 디렉토리에서 아래 명령어를 실행하여 각 모듈을 개별적으로 실행할 수 있습니다.

    ```bash
    # shop 모듈 실행
    ./gradlew :shop:bootRun

    # admin 모듈 실행
    ./gradlew :admin:bootRun
    ```

    **참고**: 두 모듈이 사용하는 포트 번호가 다를 수 있습니다. `application.yml` 파일에서 `server.port` 설정을 확인하세요.
