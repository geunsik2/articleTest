package egovframework.example.main.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import egovframework.example.main.service.CommentService;
import egovframework.example.main.service.CommentVO;
import egovframework.example.main.service.MainDefaultVO;
import egovframework.example.main.service.MainService;
import egovframework.example.main.service.MainVO;

//@Controller: 클라이언트의 요청을 처리하고 응답을 반환하는 역할을 담당
@Controller
public class MainController {
    private static final Logger logger = LoggerFactory.getLogger(MainController.class);

    // @Autowired: Spring이 MainService, CommentService 타입의 빈을 찾아 자동으로 주입해줌
    @Autowired
    private MainService mainService;
    @Autowired
    private CommentService commentService;

    // 게시글 목록 페이지, 페이징, 검색
    @RequestMapping("/main.do")
    public String mainPage(Model model, @ModelAttribute("mainDefaultVO") MainDefaultVO mainDefaultVO) throws Exception {
        // page와 range 기본값 설정
        mainDefaultVO.setPage(Math.max(mainDefaultVO.getPage(), 1));
        mainDefaultVO.setRange(Math.max(mainDefaultVO.getRange(), 1));

        // 검색 조건 설정
        model.addAttribute("search", mainDefaultVO);

        // 전체 게시글 개수
        int listCnt = mainService.getBoardListCnt(mainDefaultVO);

        // 페이징 처리
        mainDefaultVO.pageInfo(mainDefaultVO.getPage(), mainDefaultVO.getRange(), listCnt);
        model.addAttribute("pagination", mainDefaultVO);

        // 게시글 목록 조회
        model.addAttribute("list", mainService.selectMain(mainDefaultVO));

        return "main";
    }

    // 게시글 상세 페이지
    @RequestMapping("/mainDetail.do")
    public String viewForm(Model model, @ModelAttribute("mainVO") MainVO mainVO) throws Exception {
        // 상세 정보 조회
    	model.addAttribute("vo", mainService.selectDetail(mainVO));
    	
    	// 댓글 목록 조회
        List<CommentVO> commentList = commentService.selectCommentList(mainVO.getTestId());
        model.addAttribute("commentList", commentList);

        return "mainDetail";
    }

    // 게시글 작성 페이지
    @RequestMapping("/mainRegister.do")
    public String mainRegister() {
        return "mainRegister";
    }

    // 게시글 작성
    @RequestMapping("/insertMain.do")
    public String write(@ModelAttribute("mainVO") MainVO mainVO) throws Exception {
        // 파일 업로드 처리
        String fileName = handleFileUpload(mainVO.getUploadFile());
        mainVO.setFileName(fileName);

        // 새 게시글 등록
        mainService.insertMain(mainVO);

        return "redirect:main.do";
    }

    // 게시글 수정
    @RequestMapping("/updateMain.do")
    public String updateMain(@ModelAttribute("mainVO") MainVO mainVO) throws Exception {
        // 파일 업로드 처리
        if (mainVO.getUploadFile() != null && !mainVO.getUploadFile().isEmpty()) {
            String fileName = handleFileUpload(mainVO.getUploadFile());
            mainVO.setFileName(fileName);
        }

        // 게시글 수정
        mainService.updateMain(mainVO);

        return "redirect:mainDetail.do?testId=" + mainVO.getTestId();
    }

    // 게시글 삭제
    @RequestMapping("/deleteMain.do")
    public String deleteMain(@ModelAttribute("mainVO") MainVO mainVO) throws Exception {
        // 게시글 삭제
        mainService.deleteMain(mainVO);

        return "redirect:main.do";
    }
    
    @RequestMapping("/deleteFile.do")
    @ResponseBody
    public String deleteFile(@ModelAttribute("mainVO") MainVO mainVO) {
        try {
            String fileName = mainVO.getFileName();

            // 운영체제에 따른 업로드 디렉토리 경로 설정
            String os = System.getProperty("os.name").toLowerCase();
            String uploadDirPath;

            if (os.contains("win")) {
                uploadDirPath = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\eGovTest\\articleTest";
            } else {
                uploadDirPath = "/home/gsyun/apache-tomcat-8.0.36/webapps/eGovTest/fileUpload";
            }

            File file = new File(uploadDirPath, fileName);
            
            // 데이터베이스에서 파일 정보 갱신
            boolean dbUpdateSuccess = mainService.deleteFile(mainVO);

            // 파일 존재 여부 확인 후 삭제
            if (file.exists() && file.delete()) {
                return "success";
            } else {
                return "fail";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    /**
     * 파일 업로드 처리 메서드
     */
    private String handleFileUpload(MultipartFile uploadFile) throws IOException {
        if (uploadFile == null || uploadFile.isEmpty()) {
            return null; // 업로드된 파일이 없으면 null 반환
        }

        String originalFileName = uploadFile.getOriginalFilename();
        String ext = FilenameUtils.getExtension(originalFileName); // 확장자 구하기
        UUID uuid = UUID.randomUUID(); // UUID 생성
        String fileName = uuid + "." + ext;

        // 업로드 디렉토리 경로 설정 (OS에 따라 다르게 처리)
        String os = System.getProperty("os.name").toLowerCase();
        String uploadDirPath;

        if (os.contains("win")) {
            uploadDirPath = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\eGovTest\\articleTest";
        } else {
            uploadDirPath = "/home/gsyun/apache-tomcat-8.0.36/webapps/eGovTest/fileUpload";
        }

        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // 디렉토리가 없으면 생성
        }

        // 파일 저장
        uploadFile.transferTo(new File(uploadDir, fileName));

        return fileName;
    }

    /**
     * 파일 다운로드 처리 메서드
     */
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
            
            logger.debug("파일 인코딩 완료: {}", filename);
            
            // 운영체제에 따른 경로 분기 처리
            String osName = System.getProperty("os.name").toLowerCase();
            String basePath;

            if (osName.contains("win")) {
                basePath = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\eGovTest\\articleTest\\";
            } else {
                basePath = "/home/gsyun/apache-tomcat-8.0.36/webapps/eGovTest/fileUpload/";
            }

            realFilename = basePath + filename;
            
            logger.debug("실제 파일 경로: {}", realFilename);

            File file = new File(realFilename);
            if (!file.exists()) {
                logger.error("파일이 존재하지 않습니다: {}", realFilename);
                return;
            }

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
            
        } catch (UnsupportedEncodingException e) {
            logger.debug("파일 인코딩 실패: {}", e);
            
            throw e; 
            
        }
    }
}
