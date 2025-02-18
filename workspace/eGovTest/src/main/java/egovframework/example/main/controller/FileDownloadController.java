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
			if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")) {
				filename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
			} else {
				filename = new String(filename.getBytes("UTF-8"), "ISO-8859-1");
			}
		} catch (UnsupportedEncodingException e) {
			logger.debug("파일 인코딩 실패: {}", e);
		}
		
		logger.debug("파일 인코딩 완료: {}", filename);
		
		realFilename = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\eGovTest\\articleTest\\" + filename;
		logger.debug(realFilename);
		
		File file = new File(realFilename);
		if (!file.exists()) {
			return;
		}
		
		// 파일명 지정
		response.setContentType("application/octer-stream");
		response.setHeader("Content-Transfer", "binary");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
		
		try {
			OutputStream os = response.getOutputStream();
			FileInputStream fis = new FileInputStream(realFilename);
			
			int cnt = 0;
			byte[] bytes = new byte[512];
			
			while ((cnt = fis.read(bytes)) != -1) {
				os.write(bytes, 0, cnt);
			}
			
			fis.close();
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
