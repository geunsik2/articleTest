<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Board Detail</title>
    
    <!-- jQuery -->
    <script src="js/jquery-3.7.1.min.js"></script>
    
    <!-- Bootstrap CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap JS -->
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
        <h1 class="text-center">Board Detail</h1>
        <form action="updateBoard.do" id="viewForm" method="post" enctype="multipart/form-data">
            <table class="table table-bordered">
                <tbody>
                    <!-- 글번호 -->
                    <tr>
                        <th>글번호</th>
                        <td><input name="boardId" type="text" value="${vo.boardId}" class="form-control" readonly /></td>
                    </tr>

                    <!-- 제목 -->
                    <tr>
                        <th>제목</th>
                        <td>
                            <!-- 작성자나 관리자만 수정 가능하도록 -->
                            <c:choose>
                                <c:when test="${loginUser.userId eq vo.userId || loginUser.userRole eq 'ADMIN'}">
                                    <input type="text" name="boardTitle" value="${vo.boardTitle}" class="form-control" />
                                </c:when>
                                <c:otherwise>
                                    <input type="text" name="boardTitle" value="${vo.boardTitle}" class="form-control" readonly />
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <!-- 내용 -->
                    <tr>
                        <th>내용</th>
                        <td>
                            <!-- 작성자나 관리자만 수정 가능하도록 -->
                            <c:choose>
                                <c:when test="${loginUser.userId eq vo.userId || loginUser.userRole eq 'ADMIN'}">
                                    <textarea name="boardContent" class="form-control" style="height: 200px;">${vo.boardContent}</textarea>
                                </c:when>
                                <c:otherwise>
                                    <textarea name="boardContent" class="form-control" style="height: 200px;" readonly>${vo.boardContent}</textarea>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <!-- 다운로드 -->
                    <c:if test="${not empty vo.fileName}">
                        <tr>
                            <th>다운로드</th>
                            <td>
                                <a href="fileDownload.do?fileName=${vo.fileName}" class="btn btn-link">${vo.fileName}</a>
                                <button id="filedelete" type="button" class="btn btn-danger btn-sm float-end">파일삭제</button>
                            </td>
                        </tr>
                    </c:if>
                    
                    <!-- 첨부파일 -->
                    <tr>
                        <th>첨부파일</th>
                        <td><input type="file" name="uploadFile"></td>
                    </tr>

                    <!-- 버튼 -->
                    <tr>
                        <td colspan="2" class="text-end">
                            <button id="btn_previous" type="button" class="btn btn-outline-secondary">이전</button>
                            
                            <!-- 작성자나 관리자만 수정/삭제 버튼 표시 -->
                            <c:if test="${loginUser.userId eq vo.userId || loginUser.userRole eq 'ADMIN'}">
                                <button id="btn_modify" type="button" class="btn btn-primary">수정</button>
                                <button id="btn_delete" type="button" class="btn btn-danger">삭제</button>
                            </c:if>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
        <!-- 댓글 영역 -->
		<div class="comment-section mt-5">
		    <h3>댓글</h3>
		    
		    <!-- 댓글 목록 -->
		    <div id="commentList" class="mb-4">
		        <c:choose>
		            <c:when test="${empty commentList}">
		                <p class="text-center">등록된 댓글이 없습니다.</p>
		            </c:when>
		            <c:otherwise>
		                <c:forEach items="${commentList}" var="comment">
		                    <div class="card mb-2">
		                        <div class="card-body">
		                            <div class="d-flex justify-content-between">
		                                <h5 class="card-title">${comment.commentName}</h5>
		                                <small class="text-muted">${comment.commentDate}</small>
		                            </div>
		                            <p class="card-text">${comment.commentContent}</p>
		                            <div class="text-end">
		                                <button type="button" class="btn btn-sm btn-outline-primary btn-edit-comment" data-comment-id="${comment.commentId}">수정</button>
		                                <button type="button" class="btn btn-sm btn-outline-danger btn-delete-comment" data-comment-id="${comment.commentId}">삭제</button>
		                            </div>
		                        </div>
		                    </div>
		                </c:forEach>
		            </c:otherwise>
		        </c:choose>
		    </div>
		    
		    <!-- 댓글 입력 폼 - 로그인한 경우에만 표시 -->
            <div class="comment-form">
                <c:choose>
                    <c:when test="${not empty loginUser}">
                        <form id="commentForm">
                            <input type="hidden" name="boardId" value="${vo.boardId}" />
                            <input type="hidden" name="userId" value="${loginUser.userId}" />
                            <div class="form-group mb-2">
                                <label for="commentName">작성자</label>
                                <input type="text" class="form-control" id="commentName" name="commentName" value="${loginUser.userName}" readonly>
                            </div>
                            <div class="form-group mb-2">
                                <label for="commentContent">내용</label>
                                <textarea class="form-control" id="commentContent" name="commentContent" rows="3" required></textarea>
                            </div>
                            <button type="button" id="btn_comment_submit" class="btn btn-primary float-end">댓글 등록</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info">
                        	댓글을 작성하려면 <a href="loginPage.do">로그인</a>이 필요합니다.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
		</div>
    </div>

    <!-- JavaScript -->
    <script type="text/javascript">
	 	// 수정 버튼 클릭 이벤트
	    $('#btn_modify').on('click', function () {
	        if (confirm("정말 수정하시겠습니까?")) {
	            var formData = new FormData($('#viewForm')[0]);
	            
	            $.ajax({
	                type: "POST",
	                url: "updateBoard.do",
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

        // 삭제 버튼 클릭 이벤트
        $('#btn_delete').on('click', function () {
            const boardId = '${vo.boardId}';
            if (confirm("정말 삭제하시겠습니까?")) {
                $.ajax({
                    type: "POST",
                    url: "deleteBoard.do",
                    data: { boardId: boardId },
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
        $('#btn_previous').on('click', function () {
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
        
		// 파일 삭제 버튼 클릭 이벤트
		$('#filedelete').on('click', function () {
		    const fileName = '${vo.fileName}'; // 현재 첨부된 파일 이름
		
		    if (confirm("정말로 이 파일을 삭제하시겠습니까?")) {
		        $.ajax({
		            type: "POST",
		            url: "deleteFile.do", // 파일 삭제를 처리할 서버 엔드포인트
		            data: { fileName: fileName }, // 서버로 전송할 데이터
		            success: function (response) {
		                if (response === 'success') {
		                    alert("파일이 성공적으로 삭제되었습니다.");
		                    $('#filedelete').closest('tr').remove(); // 첨부파일 행 제거
		                } else {
		                    alert("파일 삭제에 실패했습니다.");
		                }
		            },
		            error: function (error) {
		                console.error("Error:", error);
		                alert("파일 삭제 중 오류가 발생했습니다.");
		            }
		        });
		    }
		});
		
		// 댓글 목록 새로고침 함수
	    function refreshCommentList() {
			const boardId = '${vo.boardId}';
	        $.ajax({
	            type: "GET",
	            url: "getCommentList.do",
	            data: { boardId: boardId },
	            dataType: "json",
	            success: function(commentList) {
	                let html = '';
	                
	                if(commentList.length === 0) {
	                    html = '<p class="text-center">등록된 댓글이 없습니다.</p>';
	                } else {
	                    for(let i = 0; i < commentList.length; i++) {
	                        let comment = commentList[i];
	                        html += '<div class="card mb-2">';
	                        html += '  <div class="card-body">';
	                        html += '    <div class="d-flex justify-content-between">';
	                        html += '      <h5 class="card-title">' + comment.commentName + '</h5>';
	                        html += '      <small class="text-muted">' + comment.commentDate + '</small>';
	                        html += '    </div>';
	                        html += '    <p class="card-text">' + comment.commentContent + '</p>';
	                        html += '    <div class="text-end">';
	                        html += '      <button type="button" class="btn btn-sm btn-outline-primary btn-edit-comment" data-comment-id="' + comment.commentId + '">수정</button>';
	                        html += '      <button type="button" class="btn btn-sm btn-outline-danger btn-delete-comment" data-comment-id="' + comment.commentId + '">삭제</button>';
	                        html += '    </div>';
	                        html += '  </div>';
	                        html += '</div>';
	                    }
	                }
	                $('#commentList').html(html); // HTML 삽입
	            },
	            error: function(error) {
	                console.error("Error:", error);
	            }
	        });
	    }
	    
	 	// 댓글 등록
        $('#btn_comment_submit').on('click', function () {
            const content = $('#commentContent').val();
            
            if(!content.trim()) {
                alert("댓글 내용을 입력하세요.");
                return;
            }
            
            if(confirm("정말 등록하시겠습니까?")) {
                $.ajax({
                    type: "POST",
                    url: "insertComment.do",
                    data: $('#commentForm').serialize(),
                    success: function(response) {
                        if(response === 'success') {
                            alert("댓글이 등록되었습니다.");
                            $('#commentContent').val('');
                            refreshCommentList();
                        } else if(response === 'login_required') {
                            alert("로그인이 필요한 기능입니다.");
                            window.location.href = "loginPage.do";
                        } else {
                            alert("댓글 등록에 실패했습니다.");
                        }
                    },
                    error: function(error) {
                        console.error("Error:", error);
                        alert("댓글 등록 중 오류가 발생했습니다.");
                    }
                });
            }
        });
	    
     	// 댓글 수정 - 권한 검사 추가
        $(document).on('click', '.btn-edit-comment', function() {
            const commentId = $(this).data('comment-id');
            const commentText = $(this).closest('.card-body').find('.card-text').text();
            
            const newContent = prompt("댓글을 수정해주세요:", commentText);
            
            if(newContent !== null && newContent.trim() !== '') {
                $.ajax({
                    type: "POST",
                    url: "updateComment.do",
                    data: {
                        commentId: commentId,
                        commentContent: newContent
                    },
                    success: function(response) {
                        if(response === 'success') {
                            alert("댓글이 수정되었습니다.");
                            refreshCommentList();
                        } else if(response === 'login_required') {
                            alert("로그인이 필요한 기능입니다.");
                            window.location.href = "loginPage.do";
                        } else if(response === 'unauthorized') {
                            alert("댓글 수정 권한이 없습니다.");
                        } else {
                            alert("댓글 수정에 실패했습니다.");
                        }
                    },
                    error: function(error) {
                        console.error("Error:", error);
                        alert("댓글 수정 중 오류가 발생했습니다.");
                    }
                });
            }
        });
	    
     	// 댓글 삭제 - 권한 검사 추가
        $(document).on('click', '.btn-delete-comment', function() {
            const commentId = $(this).data('comment-id');
            
            if(confirm("정말 이 댓글을 삭제하시겠습니까?")) {
                $.ajax({
                    type: "POST",
                    url: "deleteComment.do",
                    data: { commentId: commentId },
                    success: function(response) {
                        if(response === 'success') {
                            alert("댓글이 삭제되었습니다.");
                            refreshCommentList();
                        } else if(response === 'login_required') {
                            alert("로그인이 필요한 기능입니다.");
                            window.location.href = "loginPage.do";
                        } else if(response === 'unauthorized') {
                            alert("댓글 삭제 권한이 없습니다.");
                        } else {
                            alert("댓글 삭제에 실패했습니다.");
                        }
                    },
                    error: function(error) {
                        console.error("Error:", error);
                        alert("댓글 삭제 중 오류가 발생했습니다.");
                    }
                });
            }
        });
    </script>
</body>
</html>
