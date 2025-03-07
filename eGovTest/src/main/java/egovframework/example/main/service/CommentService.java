package egovframework.example.main.service;

import java.util.List;

// 비즈니스 로직을 정의한다.
public interface CommentService {
	// 특정 게시글의 댓글 조회
	List<CommentVO> selectCommentList(int boardId) throws Exception;
	
	// 댓글 한 개 조회
	CommentVO getComment(int commentId) throws Exception;
    
    // 댓글 등록
	void insertComment(CommentVO commentVO) throws Exception;
    
    // 댓글 수정
	void updateComment(CommentVO commentVO) throws Exception;
    
    // 댓글 삭제
	void deleteComment(int commentId) throws Exception;
}
