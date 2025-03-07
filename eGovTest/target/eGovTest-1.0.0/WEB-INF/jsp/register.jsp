<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    
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
            <div class="col-md-8 mt-5">
                <div class="card">
                    <div class="card-header">
                        <h3 class="text-center">회원가입</h3>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty message}">
                            <div class="alert alert-danger">${message}</div>
                        </c:if>
                        
                        <form action="register.do" method="post" id="registerForm">
                            <div class="mb-3 row">
                                <label for="userId" class="col-sm-3 col-form-label">아이디 *</label>
                                <div class="col-sm-9">
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="userId" name="userId" required>
                                        <button type="button" class="btn btn-outline-secondary" id="btnCheckId">중복확인</button>
                                    </div>
                                    <div id="idFeedback" class="form-text"></div>
                                </div>
                            </div>
                            
                            <div class="mb-3 row">
                                <label for="userPw" class="col-sm-3 col-form-label">비밀번호 *</label>
                                <div class="col-sm-9">
                                    <input type="password" class="form-control" id="userPw" name="userPw" required>
                                    <div class="form-text">8자 이상의 영문, 숫자, 특수문자 조합</div>
                                </div>
                            </div>
                            
                            <div class="mb-3 row">
                                <label for="confirmPw" class="col-sm-3 col-form-label">비밀번호 확인 *</label>
                                <div class="col-sm-9">
                                    <input type="password" class="form-control" id="confirmPw" required>
                                    <div id="pwFeedback" class="form-text"></div>
                                </div>
                            </div>
                            
                            <div class="mb-3 row">
                                <label for="userName" class="col-sm-3 col-form-label">이름 *</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="userName" name="userName" required>
                                </div>
                            </div>
                            
                            <div class="mb-3 row">
                                <label for="userEmail" class="col-sm-3 col-form-label">이메일 *</label>
                                <div class="col-sm-9">
                                    <div class="input-group">
                                        <input type="email" class="form-control" id="userEmail" name="userEmail" required>
                                        <button type="button" class="btn btn-outline-secondary" id="btnCheckEmail">중복확인</button>
                                    </div>
                                    <div id="emailFeedback" class="form-text"></div>
                                </div>
                            </div>
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary" id="btnRegister">회원가입</button>
                                <a href="loginPage.do" class="btn btn-link">이미 계정이 있으신가요? 로그인하기</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        $(document).ready(function() {
            let idChecked = false;
            let emailChecked = false;
            
            // 아이디 중복 확인
            $("#btnCheckId").click(function() {
                const userId = $("#userId").val().trim();
                
                if (!userId) {
                    $("#idFeedback").html("아이디를 입력해주세요").css("color", "red");
                    return;
                }
                
                // 아이디 형식 검사 (영문, 숫자 4~12자)
                const idRegex = /^[a-zA-Z0-9]{4,12}$/;
                if (!idRegex.test(userId)) {
                    $("#idFeedback").html("아이디는 4~12자의 영문, 숫자만 가능합니다").css("color", "red");
                    return;
                }
                
                $.ajax({
                    type: "POST",
                    url: "checkId.do",
                    data: { userId: userId },
                    success: function(response) {
                        if (response === "available") {
                            $("#idFeedback").html("사용 가능한 아이디입니다").css("color", "green");
                            idChecked = true;
                        } else {
                            $("#idFeedback").html("이미 사용 중인 아이디입니다").css("color", "red");
                            idChecked = false;
                        }
                    },
                    error: function(error) {
                        $("#idFeedback").html("서버 오류가 발생했습니다").css("color", "red");
                        idChecked = false;
                    }
                });
            });
            
            // 이메일 중복 확인
            $("#btnCheckEmail").click(function() {
                const userEmail = $("#userEmail").val().trim();
                
                if (!userEmail) {
                    $("#emailFeedback").html("이메일을 입력해주세요").css("color", "red");
                    return;
                }
                
                // 이메일 형식 검사
                const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
                if (!emailRegex.test(userEmail)) {
                    $("#emailFeedback").html("유효한 이메일 형식이 아닙니다").css("color", "red");
                    return;
                }
                
                $.ajax({
                    type: "POST",
                    url: "checkEmail.do",
                    data: { userEmail: userEmail },
                    success: function(response) {
                        if (response === "available") {
                            $("#emailFeedback").html("사용 가능한 이메일입니다").css("color", "green");
                            emailChecked = true;
                        } else {
                            $("#emailFeedback").html("이미 사용 중인 이메일입니다").css("color", "red");
                            emailChecked = false;
                        }
                    },
                    error: function(error) {
                        $("#emailFeedback").html("서버 오류가 발생했습니다").css("color", "red");
                        emailChecked = false;
                    }
                });
            });
            
            // 비밀번호 확인 체크
            $("#confirmPw").on("input", function() {
                const userPw = $("#userPw").val();
                const confirmPw = $(this).val();
                
                if (userPw === confirmPw) {
                    $("#pwFeedback").html("비밀번호가 일치합니다").css("color", "green");
                } else {
                    $("#pwFeedback").html("비밀번호가 일치하지 않습니다").css("color", "red");
                }
            });
            
            // 폼 제출 시 유효성 검사
            $("#registerForm").submit(function(e) {
                // 아이디 중복 확인 여부
                if (!idChecked) {
                    e.preventDefault();
                    alert("아이디 중복 확인을 해주세요");
                    return;
                }
                
                // 이메일 중복 확인 여부
                if (!emailChecked) {
                    e.preventDefault();
                    alert("이메일 중복 확인을 해주세요");
                    return;
                }
                
                // 비밀번호 확인
                const userPw = $("#userPw").val();
                const confirmPw = $("#confirmPw").val();
                
                if (userPw !== confirmPw) {
                    e.preventDefault();
                    alert("비밀번호가 일치하지 않습니다");
                    return;
                }
                
                // 비밀번호 복잡성 검사
                const pwRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
                if (!pwRegex.test(userPw)) {
                    e.preventDefault();
                    alert("비밀번호는 8자 이상의 영문, 숫자, 특수문자 조합이어야 합니다");
                    return;
                }
            });
            
            // 아이디 변경 시 중복 확인 초기화
            $("#userId").on("input", function() {
                idChecked = false;
                $("#idFeedback").html("중복 확인이 필요합니다").css("color", "gray");
            });
            
            // 이메일 변경 시 중복 확인 초기화
            $("#userEmail").on("input", function() {
                emailChecked = false;
                $("#emailFeedback").html("중복 확인이 필요합니다").css("color", "gray");
            });
        });
    </script>
</body>
</html>
