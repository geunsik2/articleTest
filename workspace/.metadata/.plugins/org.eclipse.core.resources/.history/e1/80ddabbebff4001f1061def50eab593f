package egovframework.example.main.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class FileDownloadController {
    private static final Logger logger = LoggerFactory.getLogger(FileDownloadController.class);

    @RequestMapping("fileDownload.do")
    public void fileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String filename = request.getParameter("fileName");
        String realFilename = "";
        logger.debug("파일 다운로드 시작: {}", filename);

        try {
            String browser = request.getHeader("User-Agent");

            // 파일 인코딩
            if (browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")) {
                filename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
            } else {
                filename = new String(filename.getBytes("UTF-8"), "ISO-8859-1");
            }
        } catch (UnsupportedEncodingException e) {
            logger.debug("파일 인코딩 실패: {}", e);
        }

        logger.debug("파일 인코딩 완료: {}", filename);

        // 운영체제에 따른 경로 분기 처리
        String osName = System.getProperty("os.name").toLowerCase(); // 변수명 변경
        String basePath;

        if (osName.contains("win")) {
            // Windows 환경
            basePath = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\eGovTest\\articleTest\\";
        } else {
            // Linux/Unix 환경
            basePath = "/home/gsyun/apache-tomcat-8.0.36/webapps/eGovTest/fileUpload/";
        }

        realFilename = basePath + filename;
        logger.debug("실제 파일 경로: {}", realFilename);

        File file = new File(realFilename);
        if (!file.exists()) {
            logger.error("파일이 존재하지 않습니다: {}", realFilename);
            return;
        }

        // 파일명 지정
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Transfer-Encoding", "binary");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        try (OutputStream os = response.getOutputStream(); FileInputStream fis = new FileInputStream(realFilename)) {

            int cnt;
            byte[] bytes = new byte[512];

            while ((cnt = fis.read(bytes)) != -1) {
                os.write(bytes, 0, cnt);
            }

            os.flush();
        } catch (Exception e) {
            logger.error("파일 다운로드 중 오류 발생: {}", e.getMessage());
            e.printStackTrace();
        }
    }
}
