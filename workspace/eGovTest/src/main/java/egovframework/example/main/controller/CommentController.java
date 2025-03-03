package egovframework.example.main.controller;

import java.util.List;

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

@Controller
public class CommentController {
    private static final Logger logger = LoggerFactory.getLogger(CommentController.class);

    @Autowired
    private CommentService commentService;

    // 댓글 목록 조회 (Ajax)
    @RequestMapping("/getCommentList.do")
    @ResponseBody
    public List<CommentVO> getCommentList(@RequestParam("testId") int testId) throws Exception {
        return commentService.selectCommentList(testId);
    }

    // 댓글 등록 (Ajax)
    @RequestMapping("/insertComment.do")
    @ResponseBody
    public String insertComment(@ModelAttribute("commentVO") CommentVO commentVO) throws Exception {
        try {
            commentService.insertComment(commentVO);
            return "success";
        } catch (Exception e) {
            logger.error("댓글 등록 실패: {}", e.getMessage());
            return "fail";
        }
    }

    // 댓글 수정 (Ajax)
    @RequestMapping("/updateComment.do")
    @ResponseBody
    public String updateComment(@ModelAttribute("commentVO") CommentVO commentVO) throws Exception {
        try {
            commentService.updateComment(commentVO);
            return "success";
        } catch (Exception e) {
            logger.error("댓글 수정 실패: {}", e.getMessage());
            return "fail";
        }
    }

    // 댓글 삭제 (Ajax)
    @RequestMapping("/deleteComment.do")
    @ResponseBody
    public String deleteComment(@RequestParam("commentId") int commentId) throws Exception {
        try {
            commentService.deleteComment(commentId);
            return "success";
        } catch (Exception e) {
            logger.error("댓글 삭제 실패: {}", e.getMessage());
            return "fail";
        }
    }
}
