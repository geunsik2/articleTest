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
                            <button id="btn_previous" type="button" class="btn btn-default">이전</button>
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

            // 폼 입력값 유효성 검사
            if (!title) {
                alert("제목을 입력하세요.");
                return;
            }
            if (!content) {
                alert("내용을 입력하세요.");
                return;
            }

            $("#form_main").submit();
        });

        // 이전 버튼 클릭 이벤트
        $("#btn_previous").click(function previous() {
	        $(location).attr('href', 'main.do');
	    });
    </script>
</body>
</html>
