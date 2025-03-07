package egovframework.example.main.service.impl;

import java.util.List;

import egovframework.example.main.service.CommentVO;

// 댓글 CRUD 작업에 필요한 메서드를 정의한다.
public interface CommentMapper {
	// 특정 게시글의 댓글을 조회합니다.
	List<CommentVO> selectCommentList(int boardId) throws Exception;
	
	// 특정 댓글 조회
	CommentVO selectComment(int commentId) throws Exception;
    
    // 새로운 댓글을 등록합니다.
	void insertComment(CommentVO commentVO) throws Exception;
    
    // 댓글을 수정합니다.
	void updateComment(CommentVO commentVO) throws Exception;
    
    // 댓글을 삭제합니다.
	void deleteComment(int commentId) throws Exception;
    
    // 게시글에 달린 모든 댓글을 삭제합니다. (게시글 삭제시 사용)
	void deleteCommentsByBoardId(int boardId) throws Exception;
}
