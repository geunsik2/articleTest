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
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import egovframework.example.main.service.CommentService;
import egovframework.example.main.service.CommentVO;
import egovframework.example.main.service.BoardDefaultVO;
import egovframework.example.main.service.BoardService;
import egovframework.example.main.service.BoardVO;
import egovframework.example.main.service.UserVO;

//@Controller: 클라이언트의 요청을 처리하고 응답을 반환하는 역할을 담당
@Controller
public class BoardController {
    private static final Logger logger = LoggerFactory.getLogger(BoardController.class);

    // @Autowired: Spring이 BoardService, CommentService 타입의 빈을 찾아 자동으로 주입해줌
    @Autowired
    private BoardService boardService;
    @Autowired
    private CommentService commentService;

    // 게시글 목록 페이지, 페이징, 검색
    @RequestMapping("/board.do")
    public String boardPage(Model model, @ModelAttribute("boardDefaultVO") BoardDefaultVO boardDefaultVO, HttpSession session) throws Exception {
        // page와 range 기본값 설정
    	boardDefaultVO.setPage(Math.max(boardDefaultVO.getPage(), 1));
        boardDefaultVO.setRange(Math.max(boardDefaultVO.getRange(), 1));

        // 검색 조건 설정
        model.addAttribute("search", boardDefaultVO);

        // 전체 게시글 개수
        int listCnt = boardService.getBoardListCnt(boardDefaultVO);

        // 페이징 처리
        boardDefaultVO.pageInfo(boardDefaultVO.getPage(), boardDefaultVO.getRange(), listCnt);
        model.addAttribute("pagination", boardDefaultVO);

        // 게시글 목록 조회
        model.addAttribute("list", boardService.selectBoard(boardDefaultVO));
        
        // 로그인 상태를 모델에 추가 (JSP에서 로그인 여부 확인용)
        model.addAttribute("loginUser", session.getAttribute("loginUser"));

        return "board";
    }

    // 게시글 상세 페이지
    @RequestMapping("/boardDetail.do")
    public String viewForm(Model model, @ModelAttribute("boardVO") BoardVO boardVO, HttpSession session) throws Exception {
        // 상세 정보 조회
        model.addAttribute("vo", boardService.selectDetail(boardVO));
        
        // 댓글 목록 조회
        List<CommentVO> commentList = commentService.selectCommentList(boardVO.getBoardId());
        model.addAttribute("commentList", commentList);
        
        // 로그인 상태를 모델에 추가
        model.addAttribute("loginUser", session.getAttribute("loginUser"));
        
        return "boardDetail";
    }

    // 게시글 작성 페이지
    @RequestMapping("/boardRegister.do")
    public String BoardRegister(HttpSession session) {
    	// 로그인 여부 확인
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            // 로그인되지 않은 경우 로그인 페이지로 리다이렉트
            return "redirect:/loginPage.do?returnUrl=boardRegister.do";
        }
        
        return "boardRegister";
    }

    // 게시글 작성
    @RequestMapping("/insertBoard.do")
    public String write(@ModelAttribute("boardVO") BoardVO boardVO, HttpSession session) throws Exception {
        // 로그인 여부 확인
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/loginPage.do";
        }
        
        // 작성자 정보 설정 (로그인한 회원 정보 이용)
        boardVO.setBoardName(loginUser.getUserName());
        boardVO.setUserId(loginUser.getUserId());
        
        // 파일 업로드 처리
        String fileName = handleFileUpload(boardVO.getUploadFile());
        boardVO.setFileName(fileName);

        // 새 게시글 등록
        boardService.insertBoard(boardVO);

        return "redirect:board.do";
    }

    // 게시글 수정
    @RequestMapping("/updateBoard.do")
    public String updateBoard(@ModelAttribute("boardVO") BoardVO boardVO, HttpSession session) throws Exception {
    	// 로그인 여부 확인
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/loginPage.do";
        }
        
        // 해당 게시글의 작성자 검증
        BoardVO originalPost = boardService.selectDetail(boardVO);
        if (!loginUser.getUserId().equals(originalPost.getUserId()) && 
            !"ADMIN".equals(loginUser.getUserRole())) {
            // 작성자나 관리자가 아닌 경우 권한 없음
            return "redirect:board.do";
        }
        
        // 파일 업로드 처리
        if (boardVO.getUploadFile() != null && !boardVO.getUploadFile().isEmpty()) {
            String fileName = handleFileUpload(boardVO.getUploadFile());
            boardVO.setFileName(fileName);
        }

        // 게시글 수정
        boardService.updateBoard(boardVO);

        return "redirect:boardDetail.do?boardId=" + boardVO.getBoardId();
    }

    // 게시글 삭제
    @RequestMapping("/deleteBoard.do")
    public String deleteBoard(@ModelAttribute("boardVO") BoardVO boardVO, HttpSession session) throws Exception {
        // 로그인 여부 확인
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/loginPage.do";
        }
        
        // 해당 게시글의 작성자 검증
        BoardVO originalPost = boardService.selectDetail(boardVO);
        if (!loginUser.getUserId().equals(originalPost.getUserId()) && 
            !"ADMIN".equals(loginUser.getUserRole())) {
            // 작성자나 관리자가 아닌 경우 권한 없음
            return "redirect:board.do";
        }
        
        // 게시글 삭제
        boardService.deleteBoard(boardVO);
        
        return "redirect:board.do";
    }
    
    // 파일 삭제
    @RequestMapping("/deleteFile.do")
    @ResponseBody
    public String deleteFile(@ModelAttribute("boardVO") BoardVO boardVO) {
        try {
            String fileName = boardVO.getFileName();

            // 운영체제에 따른 업로드 디렉토리 경로 설정
            String os = System.getProperty("os.name").toLowerCase();
            String uploadDirPath;

            if (os.contains("win")) {
                uploadDirPath = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\eGovTest\\fileUpload";
            } else {
                uploadDirPath = "/home/gsyun/apache-tomcat-8.0.36/webapps/eGovTest/fileUpload";
            }

            File file = new File(uploadDirPath, fileName);
            
            // 데이터베이스에서 파일 정보 갱신
            boolean dbUpdateSuccess = boardService.deleteFile(boardVO);

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

  
    // 파일 업로드 처리 메서드    
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
            uploadDirPath = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\eGovTest\\fileUpload";
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


    // 파일 다운로드 처리 메서드
    @RequestMapping("downloadFile.do")
    public void downloadFile(HttpServletRequest request, HttpServletResponse response) throws Exception {

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
                basePath = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\eGovTest\\fileUpload\\";
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
