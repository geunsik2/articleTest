<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    
    <!-- jQuery -->
    <script src="js/jquery-3.7.1.min.js"></script>
    
    <!-- Bootstrap CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap JS -->
    <script src="js/bootstrap.min.js"></script>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 mt-5">
                <div class="card">
                    <div class="card-header">
                        <h3 class="text-center">로그인</h3>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty message}">
                            <div class="alert alert-danger">${message}</div>
                        </c:if>
                        <c:if test="${param.registrationSuccess eq 'true'}">
                            <div class="alert alert-success">회원가입이 완료되었습니다. 로그인해주세요.</div>
                        </c:if>
                        
                        <form action="login.do" method="post">
                            <div class="mb-3">
                                <label for="userId" class="form-label">아이디</label>
                                <input type="text" class="form-control" id="userId" name="userId" required>
                            </div>
                            <div class="mb-3">
                                <label for="userPw" class="form-label">비밀번호</label>
                                <input type="password" class="form-control" id="userPw" name="userPw" required>
                            </div>
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">로그인</button>
                                <a href="registerPage.do" class="btn btn-outline-secondary">회원가입</a>
                                <a href="board.do" class="btn btn-link">메인으로 돌아가기</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
