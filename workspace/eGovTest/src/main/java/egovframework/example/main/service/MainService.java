package egovframework.example.main.service;

import java.util.List;

public interface MainService {

	/*
	 * MainVo 객체를 매개변수로 받아 조건에 맞는 게시글 목록을 조회하는 메소드 조회된 결과를 List<MainVo> 형태로 반환
	 */
	public List<MainVO> selectMain(MainDefaultVO mainDefaultVO) throws Exception;

	/*
	 * 새로운 게시글 정보를 데이터베이스에 삽입하는 메소드 MainVo 객체를 매개변수로 받아 해당 정보를 저장
	 */
	public void insertMain(MainVO mainVO) throws Exception;

	/*
	 * 특정 게시글의 상세 정보를 조회하는 메소드 testId를 매개변수로 받아 해당 ID의 테스트 정보를 MainVo 객체로 반환
	 */
	public MainVO selectDetail(MainVO mainVo) throws Exception;

	/*
	 * 기존 게시글을 수정하는 메소드 MainVo 객체를 매개변수로 받아 해당 정보로 데이터베이스의 레코드를 업데이트
	 */
	public void updateMain(MainVO mainVO) throws Exception;

	/*
	 * 특정 게시글을 삭제하는 메소드 testId를 매개변수로 받아 해당 ID의 게시글 정보를 데이터베이스에서 삭제
	 */
	public void deleteMain(MainVO mainVo) throws Exception;
	
	/*
	 * 게시글 목록의 총 개수를 조회하는 메소드
	 */
	public int getBoardListCnt(MainDefaultVO mainDefaultVO) throws Exception;
	
	
	// 첨부 파일을 삭제하는 메소드
	public boolean deleteFile(MainVO mainVo) throws Exception;
}
