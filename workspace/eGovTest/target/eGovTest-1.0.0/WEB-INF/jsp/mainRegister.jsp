<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 작성</title>

    <!-- jQuery 라이브러리 -->
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
          crossorigin="anonymous">

    <!-- Bootstrap 테마 CSS -->
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css"
          integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp"
          crossorigin="anonymous">

    <!-- Bootstrap JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
</head>
<body>
    <div class="container">
        <!-- 페이지 헤더 -->
        <h1 class="text-center">Board Write</h1>

        <!-- 게시글 작성 폼 -->
        <form id="form_main" action="insertMain.do" method="post" enctype="multipart/form-data">
            <table class="table table-bordered">
                <tbody>
                    <!-- 제목 입력 -->
                    <tr>
                        <th>제목</th>
                        <td>
                            <input type="text" name="testTitle" class="form-control" placeholder="제목을 입력하세요." required />
                        </td>
                    </tr>

                    <!-- 내용 입력 -->
                    <tr>
                        <th>내용</th>
                        <td>
                            <textarea name="testContent" class="form-control" placeholder="내용을 입력하세요." rows="8" required></textarea>
                        </td>
                    </tr>

                    <!-- 파일 업로드 -->
                    <tr>
                        <th>첨부파일</th>
                        <td><input type="file" name="uploadFile"></td>
                    </tr>

                    <!-- 버튼 섹션 -->
                    <tr>
                        <td colspan="2" class="text-right">
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
		    const title = $("input[name='testTitle']").val().trim();
		    const content = $("textarea[name='testContent']").val().trim();
		
		    if (!title || !content) {
		        alert("제목과 내용을 입력하세요.");
		        return;
		    }
		
		    let formData = new FormData($('#form_main')[0]);
		
		    $.ajax({
		        url: 'insertMain.do',
		        type: 'POST',
		        data: formData,
		        processData: false,
		        contentType: false,
		        success: function(response) {
		            alert("등록되었습니다.");
		            location.href = 'main.do';
		        },
		        error: function(xhr, status, error) {
		            alert("등록 중 오류가 발생했습니다.");
		        }
		    });
		});
    </script>
</body>
</html>
