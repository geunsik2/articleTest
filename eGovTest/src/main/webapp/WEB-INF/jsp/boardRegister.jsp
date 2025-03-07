<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 작성</title>

    <!-- jQuery 라이브러리 -->
    <script src="js/jquery-3.7.1.min.js"></script>

    <!-- Bootstrap CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap JavaScript -->
    <script src="js/bootstrap.min.js"></script>
</head>
<body>
	<!-- 네비게이션 바 추가 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="board.do">게시판</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="board.do">홈</a>
                    </li>
                </ul>
                
                <!-- 로그인 상태에 따른 메뉴 표시 -->
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${not empty loginUser}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                    ${loginUser.userName}님
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="myPage.do">내 정보</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="logout.do">로그아웃</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="loginPage.do">로그인</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="registerPage.do">회원가입</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container">
        <!-- 페이지 헤더 -->
        <h1 class="text-center">Board Write</h1>

        <!-- 게시글 작성 폼 -->
        <form id="form_board" action="insertBoard.do" method="post" enctype="multipart/form-data">
        	<!-- 작성자 ID 추가 -->
            <input type="hidden" name="userId" value="${loginUser.userId}">
            <input type="hidden" name="boardName" value="${loginUser.userName}">
            <table class="table table-bordered">
                <tbody>
                    <!-- 제목 입력 -->
                    <tr>
                        <th>제목</th>
                        <td>
                            <input type="text" name="boardTitle" class="form-control" placeholder="제목을 입력하세요." required />
                        </td>
                    </tr>

                    <!-- 내용 입력 -->
                    <tr>
                        <th>내용</th>
                        <td>
                            <textarea name="boardContent" class="form-control" placeholder="내용을 입력하세요." rows="8" required></textarea>
                        </td>
                    </tr>

                    <!-- 파일 업로드 -->
                    <tr>
                        <th>첨부파일</th>
                        <td><input type="file" name="uploadFile"></td>
                    </tr>

                    <!-- 버튼 섹션 -->
                    <tr>
                        <td colspan="2" class="text-end">
                            <button id="btn_previous" type="button" class="btn btn-outline-secondary">이전</button>
                            <button id="btn_register" type="button" class="btn btn-primary">등록</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </div>

    <!-- JavaScript -->
    <script type="text/javascript">
        // 등록 버튼 클릭 이벤트
        $("#btn_register").click(function register() {
            const title = $("input[name='boardTitle']").val().trim();
            const content = $("textarea[name='boardContent']").val().trim();

            // 폼 입력값 유효성 검사
            if (!title) {
                alert("제목을 입력하세요.");
                return;
            }
            if (!content) {
                alert("내용을 입력하세요.");
                return;
            }
            
            if (confirm("정말 등록하시겠습니까?")) {
                var formData = new FormData($('#form_board')[0]);
                
                $.ajax({
                    type: "POST",
                    url: "insertBoard.do",
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(response) {
                        document.open();
                        document.write(response);
                        document.close();
                    },
                    error: function(error) {
                        console.error("Error:", error);
                    }
                });
            }
        });

        // 이전 버튼 클릭 이벤트
        $("#btn_previous").click(function previous() {
            $.ajax({
                type: "POST",
                url: "board.do",
                success: function(response) {
                    document.open();
                    document.write(response);
                    document.close();
                },
                error: function(error) {
                    console.error("Error:", error);
                }
            });
        });
    </script>
</body>
</html>
