package egovframework.example.main.service;

// 댓글 데이터를 자바 객체로 다루기 위한 VO 클래스
// 댓글의 속성을 정의하며, 테이블의 각 컬럼에 대응된다.
public class CommentVO {
	private int commentId;        		// 댓글 ID
    private int boardId;           		// 연결된 게시글 ID
    private String commentContent; 		// 댓글 내용
    private String commentName;  		// 댓글 작성자
    private String commentDate;     	// 댓글 작성일
    private String userId;				// 작성자 ID
    
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getCommentId() {
		return commentId;
	}
	public void setCommentId(int commentId) {
		this.commentId = commentId;
	}
	public int getBoardId() {
		return boardId;
	}
	public void setBoardId(int boardId) {
		this.boardId = boardId;
	}
	public String getCommentContent() {
		return commentContent;
	}
	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}
	public String getCommentName() {
		return commentName;
	}
	public void setCommentName(String commentName) {
		this.commentName = commentName;
	}
	public String getCommentDate() {
		return commentDate;
	}
	public void setCommentDate(String commentDate) {
		this.commentDate = commentDate;
	}
    
	
}
