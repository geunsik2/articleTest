package egovframework.example.main.service.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.example.main.service.CommentService;
import egovframework.example.main.service.CommentVO;

// 서비스 구현 클래스는 실제 비즈니스 로직을 처리하며, SqlSession을 통해 매퍼와 상호작용한다.
@Service
public class CommentServiceImpl implements CommentService {
	@Autowired
    private SqlSession sqlSession;
    
	@Override
    public List<CommentVO> selectCommentList(int boardId) throws Exception {
        return sqlSession.getMapper(CommentMapper.class).selectCommentList(boardId);
    }
	
	@Override
	public CommentVO getComment(int commentId) throws Exception {
	    return sqlSession.getMapper(CommentMapper.class).selectComment(commentId);
	}
    
	@Override
    public void insertComment(CommentVO commentVO) throws Exception {
        sqlSession.getMapper(CommentMapper.class).insertComment(commentVO);
    }
    
    @Override
    public void updateComment(CommentVO commentVO) throws Exception {
        sqlSession.getMapper(CommentMapper.class).updateComment(commentVO);
    }
    
    @Override
    public void deleteComment(int commentId) throws Exception {
        sqlSession.getMapper(CommentMapper.class).deleteComment(commentId);
    }
	
}
