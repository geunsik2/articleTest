<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Board List</title>
    
    <!-- jQuery -->
    <script src="js/jquery-3.7.1.min.js"></script>
    
    <!-- Bootstrap CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS -->
    <script src="js/bootstrap.bundle.min.js"></script>
    
    <style>
        a { text-decoration: none; }
        .row > * { width: auto; }
        .search-bar { margin-top: 100px; }
    </style>
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
                        <a class="nav-link active" href="board.do">홈</a>
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
    <div class="container mt-4">
        <!-- 페이지 제목 -->
        <h1 class="text-center">Board List</h1>
        
        <div class="d-flex align-items-center justify-content-between mb-4 search-bar">
        	<!-- 검색 기능 -->
	        <form id="searchForm" class="d-flex align-items-center">
	            <!-- 검색 유형 선택 -->
	            <div class="col-auto" style="padding-right: 10px">
	                <select class="form-select form-select-sm" name="searchType" id="searchType">
	                    <option value="boardTitle">제목</option>
	                    <option value="boardContent">내용</option>
	                    <option value="boardName">작성자</option>
	                </select>
	            </div>
	
	            <!-- 검색어 입력 -->
	            <div class="col-auto" style="padding-right: 10px">
	                <input type="text" class="form-control form-control-sm" name="keyword" id="keyword" placeholder="검색어 입력">
	            </div>
	
	            <!-- 검색 버튼 -->
	            <div class="col-auto">
	                <button type="button" id="btnSearch" class="btn btn-primary btn-sm">검색</button>
	            </div>
	        </form>
	        
	        <!-- 글쓰기 버튼 - 로그인 상태에 따라 표시 -->
            <c:choose>
                <c:when test="${not empty loginUser}">
                    <a class="btn btn-outline-info" href="boardRegister.do">글쓰기</a>
                </c:when>
                <c:otherwise>
                    <a class="btn btn-outline-info" href="loginPage.do?returnUrl=boardRegister.do" onclick="alert('로그인이 필요한 기능입니다.')">글쓰기</a>
                </c:otherwise>
            </c:choose>
        </div>        
        
        <!-- 게시글 목록 테이블 -->
        <table class="table table-hover table-striped text-center border mt-4">
            <colgroup>
                <col width="10%">
                <col width="50%">
                <col width="20%">
                <col width="20%">
            </colgroup>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>등록일자</th>
                </tr>
            </thead>
            <tbody>
                <!-- 게시글이 없으면 예외 메시지 출력 -->
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="4">표시할 게시글이 없습니다.</td>
                    </tr>
                </c:if>

                <!-- JSTL을 사용하여 게시글 반복 출력 -->
                <c:forEach items="${list}" var="result">
                    <tr>
                        <td>${result.boardId}</td>
                        <td><a href="boardDetail.do?boardId=${result.boardId}">${result.boardTitle}</a></td>
                        <td>${result.boardName}</td>
                        <td>${result.boardDate}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- 페이지네이션 -->
        <div id="paginationBox" class="pagination justify-content-center my-4">
            <!-- 이전 페이지 버튼 -->
            <c:if test="${pagination.prev}">
                <li class="page-item"><a class="page-link" href="#" onClick="fn_prev('${pagination.page}', '${pagination.range}', '${pagination.rangeSize}', '${pagination.listSize}', '${search.searchType}', '${search.keyword}')">이전</a></li>
            </c:if>

            <!-- 페이지 번호 버튼 -->
            <c:forEach begin="${pagination.startPage}" end="${pagination.endPage}" var="boardId">
                <li class="page-item ${pagination.page == boardId ? 'active' : ''}">
                    <a class="page-link" href="#" onClick="fn_pagination('${boardId}', '${pagination.range}', '${pagination.rangeSize}', '${pagination.listSize}', '${search.searchType}', '${search.keyword}')">${boardId}</a>
                </li>
            </c:forEach>

            <!-- 다음 페이지 버튼 -->
            <c:if test="${pagination.next}">
                <li class="page-item"><a class="page-link" href="#" onClick="fn_next('${pagination.page}', '${pagination.range}', '${pagination.rangeSize}', '${pagination.listSize}', '${search.searchType}', '${search.keyword}')">다음</a></li>
            </c:if>
        </div>
    </div>
</body>
<script type="text/javascript">
    // 이전 버튼 이벤트
	function fn_prev(page, range, rangeSize, listSize, searchType, keyword) {
	    page = ((range - 2) * rangeSize) + 1;
	    range = range - 1;
	
	    var data = {
	        page: page,
	        range: range,
	        listSize: listSize,
	        searchType: searchType,
	        keyword: keyword
	    };
	
	    $.ajax({
	        type: "POST",
	        url: "board.do",
	        data: data,
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
    
	// 다음 버튼 이벤트
	function fn_next(page, range, rangeSize, listSize, searchType, keyword) {
	    page = parseInt(range * rangeSize) + 1;
	    range = parseInt(range) + 1;
	
	    var data = {
	        page: page,
	        range: range,
	        listSize: listSize,
	        searchType: searchType,
	        keyword: keyword
	    };
	
	    $.ajax({
	        type: "POST",
	        url: "board.do",
	        data: data,
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

    // 페이지 번호 클릭
    function fn_pagination(page, range, rangeSize, listSize, searchType, keyword) {
        var data = {
            page: page,
            range: range,
            listSize: listSize,
            searchType: searchType,
            keyword: keyword
        };

        $.ajax({
            type: "POST",
            url: "board.do",
            data: data,
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
 
    // 검색 수행 함수
    function searchArticle() {
        var data = {
            searchType: $("#searchType").val(),
            keyword: $("#keyword").val()
        };

        $.ajax({
            type: "POST",
            url: "board.do",
            data: data,
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

    // 검색
    $(document).on("click", "#btnSearch", function (e) {
    	e.preventDefault();
    	searchArticle(); // 검색 수행 함수 호출
    });
    
 	// 검색어 입력 후 엔터키 이벤트
    $(document).on("keypress", "#keyword", function (e) {
        if (e.key === "Enter") {
            e.preventDefault();
            searchArticle();
        }
    });
</script>
</html>
