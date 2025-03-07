# 게시판 서비스

## 개발환경

- 전자정부프레임워크 3.10.0
- maven repository 3.10.0
- jdk 1.8.202
- tomcat 8.0.36
- mysql 8.0.19

## 기능

- 게시글 리스트 조회
  - 게시글 검색
  - 페이징
- 게시글 작성
- 게시글 수정
- 게시글 삭제
- 파일 업로드/다운로드

## ERD

![Image](https://github.com/user-attachments/assets/1a452bb2-3a4d-4909-bea5-b8d705060a90)
![Image](https://github.com/user-attachments/assets/296de302-aca6-443d-af0f-d90871e2fd8e)
![Image](https://github.com/user-attachments/assets/8d752a78-9517-4e38-8be1-7c0f95215257)

## 클래스

### MainController.java -> HTTP 요청 처리 및 응답 반환

- 사용자 요청(HTTP)을 처리하고 적절한 서비스 계층 메서드를 호출한다.
- 요청에 따라 작업(생성, 조회, 수정, 삭제 등)을 수행하며, 결과를 뷰(JSP)로 전달한다.
- @RequestMapping 등의 어노테이션을 사용하여 URL과 메서드를 매핑한다.

### MainService.java -> 서비스 인터페이스로 메서드 규약 정의

- 비즈니스 로직을 정의하는 인터페이스
- 서비스 구현 클래스(MainServiceImpl)가 반드시 구현해야 하는 메서드를 정의한다.

### MainServieImpl.java -> 서비스 계층 구현체로 비즈니스 로직 처리 및 Mapper 호출

- 서비스 계층의 구현 클래스
- 비즈니스 로직을 처리하고, 필요한 경우 Mapper 인터페이스(MainMapper.java)를 호출하여 데이터베이스 작업을 수행한다.
- 컨트롤러에서 호출되는 메서드를 구현한다.

### MainVO.java -> 게시글 데이터를 담는 VO 클래스

- 게시글 데이터를 담는 데이터 객체
- DB에서 가져온 데이터를 저장하거나, 사용자가 입력한 데이터를 전달하는 데 사용된다.

### MainDefaultVO.java -> 페이징 및 검색 조건을 관리하는 VO 클래스

- 페이징 및 검색 관련 데이터를 담는 데이터 객체
- 페이징 처리를 위한 변수와 검색 조건을 포함한다.
- 페이징 계산 로직도 포함

### MainMapper.java -> MyBatis Mapper로 SQL 쿼리 실행

- MyBatis를 통해 SQL 쿼리를 실행하기 위한 인터페이스
- XML 매핑 파일에 작성된 SQL문을 호출한다.
- 메서드 이름은 SQL id와 동일하게 작성되며, 데이터베이스 작업(생성, 조회, 수정, 삭제)을 수행한다.
