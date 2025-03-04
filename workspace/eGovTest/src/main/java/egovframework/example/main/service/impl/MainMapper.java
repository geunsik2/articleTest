package egovframework.example.main.service.impl;

import java.util.List;

import egovframework.example.main.service.MainDefaultVO;
import egovframework.example.main.service.MainVO;

// Mapper namespace 와 ID를 연결할 Interface를 두어서 interface를 호출하는 방법.
// Mybatis 매핑XML에 기재된 SQL을 호출하기 위한 인터페이스이다.
// SQL id는 인터페이스에 정의된 메서드명과 동일하게 작성한다
public interface MainMapper {
	
	// 게시글 목록을 조회합니다.
    public List<MainVO> selectMain(MainDefaultVO mainDefaultVO) throws Exception;
 
    // 새로운 게시글을 등록합니다.
    public void insertMain(MainVO mainVO) throws Exception;
 
    // 특정 게시글의 상세 정보를 조회합니다.
    public MainVO selectDetail(MainVO mainVO) throws Exception;
 
    // 기존 게시글 정보를 수정합니다.
    public void updateMain(MainVO mainVO) throws Exception;
 
    // 특정 게시글을 삭제합니다.
    public void deleteMain(MainVO mainVO) throws Exception;
    
    // 게시글의 총 개수를 조회합니다.
    public int getBoardListCnt(MainDefaultVO mainDefaultVO) throws Exception;
    
    // 특정 게시글의 파일 정보를 null로 수정합니다.
    public int updateFileToNull(MainVO mainVO);
}
