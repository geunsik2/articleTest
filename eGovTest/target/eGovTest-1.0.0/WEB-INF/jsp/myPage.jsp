<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    
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
                        <h3 class="text-center">내 정보 관리</h3>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty message}">
                            <div class="alert alert-success">${message}</div>
                        </c:if>
                        
                        <form action="updateUser.do" method="post" id="updateForm">
                            <div class="mb-3 row">
                                <label class="col-sm-3 col-form-label">아이디</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control-plaintext" value="${userInfo.userId}" readonly>
                                </div>
                            </div>
                            
                            <div class="mb-3 row">
                                <label for="userPw" class="col-sm-3 col-form-label">새 비밀번호</label>
                                <div class="col-sm-9">
                                    <input type="password" class="form-control" id="userPw" name="userPw">
                                    <div class="form-text">비밀번호를 변경하지 않으려면 비워두세요.</div>
                                </div>
                            </div>
                            
                            <div class="mb-3 row">
                                <label for="confirmPw" class="col-sm-3 col-form-label">비밀번호 확인</label>
                                <div class="col-sm-9">
                                    <input type="password" class="form-control" id="confirmPw">
                                    <div id="pwFeedback" class="form-text"></div>
                                </div>
                            </div>
                            
                            <div class="mb-3 row">
                                <label for="userName" class="col-sm-3 col-form-label">이름</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="userName" name="userName" value="${userInfo.userName}" required>
                                </div>
                            </div>
                            
                            <div class="mb-3 row">
                                <label class="col-sm-3 col-form-label">이메일</label>
                                <div class="col-sm-9">
                                    <input type="email" class="form-control-plaintext" value="${userInfo.userEmail}" readonly>
                                </div>
                            </div>
                            
                            <div class="mb-3 row">
                                <label class="col-sm-3 col-form-label">가입일</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control-plaintext" value="${userInfo.userDate}" readonly>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary" id="btnUpdate">정보 수정</button>
                                <a href="board.do" class="btn btn-outline-secondary">메인으로 돌아가기</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        $(document).ready(function() {
            // 비밀번호 확인 체크
            $("#confirmPw").on("input", function() {
                const pw = $("#userPw").val();
                const confirmPw = $(this).val();
                
                if (!pw) {
                    $("#pwFeedback").html("비밀번호를 변경하지 않으려면 비워두세요").css("color", "gray");
                    return;
                }
                
                if (pw === confirmPw) {
                    $("#pwFeedback").html("비밀번호가 일치합니다").css("color", "green");
                } else {
                    $("#pwFeedback").html("비밀번호가 일치하지 않습니다").css("color", "red");
                }
            });
            
            // 폼 제출 시 유효성 검사
            $("#updateForm").submit(function(e) {
                const pw = $("#userPw").val();
                
                // 비밀번호를 입력한 경우
                if (pw) {
                    const confirmPw = $("#confirmPw").val();
                    
                    // 비밀번호 확인
                    if (pw !== confirmPw) {
                        e.preventDefault();
                        alert("비밀번호가 일치하지 않습니다");
                        return;
                    }
                    
                    // 비밀번호 복잡성 검사
                    const pwRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
                    if (!pwRegex.test(pw)) {
                        e.preventDefault();
                        alert("비밀번호는 8자 이상의 영문, 숫자, 특수문자 조합이어야 합니다");
                        return;
                    }
                }
            });
        });
    </script>
</body>
</html>
