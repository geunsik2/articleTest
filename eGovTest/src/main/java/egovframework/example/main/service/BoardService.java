package egovframework.example.main.service;

import java.util.List;

public interface BoardService {

	/*
	 * BoardVO 객체를 매개변수로 받아 조건에 맞는 게시글 목록을 조회하는 메소드 조회된 결과를 List<BoardVO> 형태로 반환
	 */
	public List<BoardVO> selectBoard(BoardDefaultVO boardDefaultVO) throws Exception;

	/*
	 * 새로운 게시글 정보를 데이터베이스에 삽입하는 메소드 BoardVO 객체를 매개변수로 받아 해당 정보를 저장
	 */
	public void insertBoard(BoardVO boardVO) throws Exception;

	/*
	 * 특정 게시글의 상세 정보를 조회하는 메소드 boardId를 매개변수로 받아 해당 ID의 테스트 정보를 BoardVO 객체로 반환
	 */
	public BoardVO selectDetail(BoardVO boardVo) throws Exception;

	/*
	 * 기존 게시글을 수정하는 메소드 BoardVO 객체를 매개변수로 받아 해당 정보로 데이터베이스의 레코드를 업데이트
	 */
	public void updateBoard(BoardVO boardVO) throws Exception;

	/*
	 * 특정 게시글을 삭제하는 메소드 boardId를 매개변수로 받아 해당 ID의 게시글 정보를 데이터베이스에서 삭제
	 */
	public void deleteBoard(BoardVO boardVo) throws Exception;
	
	/*
	 * 게시글 목록의 총 개수를 조회하는 메소드
	 */
	public int getBoardListCnt(BoardDefaultVO boardDefaultVO) throws Exception;
	
	
	// 첨부 파일을 삭제하는 메소드
	public boolean deleteFile(BoardVO boardVo) throws Exception;
}
