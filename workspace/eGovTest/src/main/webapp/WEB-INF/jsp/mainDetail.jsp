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
    <div class="container">
        <h1 class="text-center">Board Detail</h1>
        <form action="updateMain.do" id="viewForm" method="post" enctype="multipart/form-data">
            <table class="table table-bordered">
                <tbody>
                    <!-- 글번호 -->
                    <tr>
                        <th>글번호</th>
                        <td><input name="testId" type="text" value="${vo.testId}" class="form-control" readonly /></td>
                    </tr>

                    <!-- 제목 -->
                    <tr>
                        <th>제목</th>
                        <td><input type="text" name="testTitle" value="${vo.testTitle}" class="form-control" /></td>
                    </tr>

                    <!-- 내용 -->
                    <tr>
                        <th>내용</th>
                        <td><textarea name="testContent" class="form-control" style="height: 200px;">${vo.testContent}</textarea></td>
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
                            <button id="btn_modify" type="button" class="btn btn-primary">수정</button>
                            <button id="btn_delete" type="button" class="btn btn-danger">삭제</button>
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
		    
		    <!-- 댓글 입력 폼 -->
		    <div class="comment-form">
		        <form id="commentForm">
		            <input type="hidden" name="testId" value="${vo.testId}" />
		            <div class="form-group mb-2">
		                <label for="commentName">작성자</label>
		                <input type="text" class="form-control" id="commentName" name="commentName" required>
		            </div>
		            <div class="form-group mb-2">
		                <label for="commentContent">내용</label>
		                <textarea class="form-control" id="commentContent" name="commentContent" rows="3" required></textarea>
		            </div>
		            <button type="button" id="btn_comment_submit" class="btn btn-primary float-end">댓글 등록</button>
		        </form>
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
                    url: "updateMain.do",
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
            const testId = '${vo.testId}';
            if (confirm("정말 삭제하시겠습니까?")) {
                $.ajax({
                    type: "POST",
                    url: "deleteMain.do",
                    data: { testId: testId },
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
                url: "main.do",
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
			const testId = '${vo.testId}';
	        $.ajax({
	            type: "GET",
	            url: "getCommentList.do",
	            data: { testId: testId },
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
	        const writer = $('#commentName').val();
	        const content = $('#commentContent').val();
	        
	        if(!writer.trim()) {
	            alert("작성자를 입력하세요.");
	            return;
	        }
	        
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
		                    $('#commentName').val('');
		                    $('#commentContent').val('');
		                    refreshCommentList();
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
	    
	    // 댓글 수정
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
	    
	    // 댓글 삭제
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
