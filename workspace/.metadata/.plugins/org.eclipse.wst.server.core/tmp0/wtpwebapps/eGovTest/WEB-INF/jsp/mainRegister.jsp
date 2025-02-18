<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Board Write</title>
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
<script
    src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
    integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
    crossorigin="anonymous"></script>
</head>
<body>
<br/>
    <h1 class="text-center">Board Write</h1>
<br/>
<br/>
<div class="container">
        <!-- 게시글 작성 폼 -->
        <form id="form_main" action="insertMain.do" method="post"
            enctype="multipart/form-data">
            <table class="table table-bordered">
                <tbody>
                    <tr>
                        <th>제목</th>
                        <td><input type="text" placeholder="제목을 입력하세요."
                            name="testTitle" class="form-control" /></td>
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td><textarea placeholder="내용을 입력하세요 ." name="testContent"
                                class="form-control" style="height: 200px;"></textarea></td>
                    </tr>
                    <tr>
                    	<th>첨부파일</th>
                    	<td><input type="file" name="uploadFile"></td>
                   	</tr>
                    <tr>
                        <td colspan="2">
                            <button id="btn_register" type="button" class="btn btn-primary">등록</button>
                            <button id="btn_previous" type="button" class="btn btn-default">이전</button>
                        </td>
                    </tr>

                </tbody>
            </table>
        </form>
    </div>
</body>
<script type="text/javascript">
    // 글쓰기 버튼 클릭 이벤트
    $(document).on('click', '#btn_register', function(e) {
    	console.log($("input[name='testTitle']").val()); // 값 확인
        console.log($("textarea[name='testContent']").val()); // 값 확인
        $("#form_main").submit();
    });

    // 이전 버튼 클릭 이벤트
    $("#btn_previous").click(function previous() {
        $(location).attr('href', 'main.do');

    });
</script>
</html>