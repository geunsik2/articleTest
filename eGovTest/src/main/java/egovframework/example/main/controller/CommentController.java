package egovframework.example.main.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.main.service.CommentService;
import egovframework.example.main.service.CommentVO;
import egovframework.example.main.service.UserVO;

@Controller
public class CommentController {
    private static final Logger logger = LoggerFactory.getLogger(CommentController.class);

    @Autowired
    private CommentService commentService;

    // 댓글 목록 조회
    @RequestMapping("/getCommentList.do")
    @ResponseBody
    public List<CommentVO> getCommentList(@ModelAttribute("commentVO") CommentVO commentVO) throws Exception {
        return commentService.selectCommentList(commentVO.getBoardId());
    }

    // 댓글 등록
    @RequestMapping("/insertComment.do")
    @ResponseBody
    public String insertComment(@ModelAttribute("commentVO") CommentVO commentVO, HttpSession session) throws Exception {
        try {
            // 로그인 여부 확인
            UserVO loginUser = (UserVO) session.getAttribute("loginUser");
            if (loginUser == null) {
                return "login_required";
            }
            
            // 작성자 정보 설정
            commentVO.setUserId(loginUser.getUserId());
            // 이름이 지정되지 않은 경우 회원 이름으로 설정
            if (commentVO.getCommentName() == null || commentVO.getCommentName().trim().isEmpty()) {
                commentVO.setCommentName(loginUser.getUserName());
            }
            
            commentService.insertComment(commentVO);
            return "success";
        } catch (Exception e) {
            logger.error("댓글 등록 실패: {}", e.getMessage());
            return "fail";
        }
    }

    // 댓글 수정
    @RequestMapping("/updateComment.do")
    @ResponseBody
    public String updateComment(@ModelAttribute("commentVO") CommentVO commentVO, HttpSession session) throws Exception {
        try {
            // 로그인 여부 확인
            UserVO loginUser = (UserVO) session.getAttribute("loginUser");
            if (loginUser == null) {
                return "login_required";
            }
            
            // 해당 댓글 조회
            CommentVO original = commentService.getComment(commentVO.getCommentId());
            
            // 작성자 또는 관리자만 수정 가능
            if (!loginUser.getUserId().equals(original.getUserId()) && 
                !"ADMIN".equals(loginUser.getUserRole())) {
                return "unauthorized";
            }
            
            commentService.updateComment(commentVO);
            return "success";
        } catch (Exception e) {
            logger.error("댓글 수정 실패: {}", e.getMessage());
            return "fail";
        }
    }

    // 댓글 삭제
    @RequestMapping("/deleteComment.do")
    @ResponseBody
    public String deleteComment(@ModelAttribute("commentVO") CommentVO commentVO, HttpSession session) throws Exception {
        try {
            // 로그인 여부 확인
            UserVO loginUser = (UserVO) session.getAttribute("loginUser");
            if (loginUser == null) {
                return "login_required";
            }
            
            // 해당 댓글 조회
            CommentVO comment = commentService.getComment(commentVO.getCommentId());
            
            // 작성자 또는 관리자만 삭제 가능
            if (!loginUser.getUserId().equals(comment.getUserId()) && 
                !"ADMIN".equals(loginUser.getUserRole())) {
                return "unauthorized";
            }
            
            commentService.deleteComment(commentVO.getCommentId());
            return "success";
        } catch (Exception e) {
            logger.error("댓글 삭제 실패: {}", e.getMessage());
            return "fail";
        }
    }
}
