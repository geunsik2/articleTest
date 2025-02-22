<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Board Detail</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
          crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css"
          integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp"
          crossorigin="anonymous">

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

    <!-- Bootstrap JS -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
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
                    <c:if test="${vo.fileName ne null}">
                        <tr>
                            <th>다운로드</th>
                            <td>
                                <a href="fileDownload.do?fileName=${vo.fileName}" class="btn btn-link">${vo.fileName}</a>
                                <button id="filedelete" type="button" class="btn btn-danger btn-sm pull-right">파일삭제</button>
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
                        <td colspan="2" class="text-right">
                            <button id="btn_previous" type="button" class="btn btn-default">이전</button>
                            <button id="btn_modify" type="button" class="btn btn-primary">수정</button>
                            <button id="btn_delete" type="button" class="btn btn-danger">삭제</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </div>

    <!-- JavaScript -->
    <script type="text/javascript">
        // 수정 버튼 클릭 이벤트
        $('#btn_modify').on('click', function () {
            if (confirm("정말 수정하시겠습니까?")) {
                $('#viewForm').submit();
            }
        });

        // 삭제 버튼 클릭 이벤트
        $('#btn_delete').on('click', function () {
            const testId = '${vo.testId}';
            if (confirm("정말 삭제하시겠습니까?")) {
                $('#viewForm').attr('action', 'deleteMain.do?testId=' + testId).submit();
            }
        });

        // 이전 버튼 클릭 이벤트
        $('#btn_previous').on('click', function () {
            $(location).attr('href', 'main.do');
        });

        // 파일 삭제 버튼 클릭 이벤트
        $('#filedelete').on('click', function () {
            $('#filename').val('');
        });
    </script>
</body>
</html>
