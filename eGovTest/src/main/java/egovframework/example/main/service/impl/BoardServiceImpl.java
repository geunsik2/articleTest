package egovframework.example.main.service.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.example.main.service.BoardDefaultVO;
import egovframework.example.main.service.BoardService;
import egovframework.example.main.service.BoardVO;

// @Service: 이 클래스가 비즈니스 로직을 처리하는 서비스 계층의 컴포넌트임을 나타냄
@Service
public class BoardServiceImpl implements BoardService {
	
	// @Autowired: SqlSession 빈을 자동으로 주입받음
    @Autowired
    private SqlSession sqlSession;
    
    // 게시글 목록 조회
    @Override
    public List<BoardVO> selectBoard(BoardDefaultVO boardDefaultVO) throws Exception {
        
    	return sqlSession.getMapper(BoardMapper.class).selectBoard(boardDefaultVO);
    }
 
    // 게시글 등록
    @Override
    public void insertBoard(BoardVO boardVO) throws Exception {
    	
    	sqlSession.getMapper(BoardMapper.class).insertBoard(boardVO);
    }
 
    // 게시글 상세 정보 조회
    @Override
    public BoardVO selectDetail(BoardVO boardVO) throws Exception {
        
    	return sqlSession.getMapper(BoardMapper.class).selectDetail(boardVO);
    }
 
    // 게시글 정보 업데이트
    @Override
    public void updateBoard(BoardVO boardVO) throws Exception {
        
    	sqlSession.getMapper(BoardMapper.class).updateBoard(boardVO);
    }
 
    // 게시글 삭제
    @Override
    public void deleteBoard(BoardVO boardVO) throws Exception {
    	// 게시글에 달린 댓글 먼저 삭제
    	sqlSession.getMapper(CommentMapper.class).deleteCommentsByBoardId(boardVO.getBoardId());
        // 게시글 삭제
    	sqlSession.getMapper(BoardMapper.class).deleteBoard(boardVO);
    }
	
    // 전체 게시글 개수 조회
    @Override
    public int getBoardListCnt(BoardDefaultVO boardDefaultVO) throws Exception {
    	
    	return sqlSession.getMapper(BoardMapper.class).getBoardListCnt(boardDefaultVO);
    }
    
    // 게시글 내 파일 삭제
    @Override
    public boolean deleteFile(BoardVO boardVO) throws Exception {
    	
        // 해당 파일명을 가진 게시글을 찾아 fileName 필드를 null로 설정
    	return sqlSession.getMapper(BoardMapper.class).updateFileToNull(boardVO) > 0;
    }
}
