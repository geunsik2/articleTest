package egovframework.example.main.service.impl;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import egovframework.example.main.service.UserService;
import egovframework.example.main.service.UserVO;

@Service
public class UserServiceImpl implements UserService {
	@Autowired
    private SqlSession sqlSession;
    
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;
    
    @Override
    public void registerUser(UserVO userVO) throws Exception {
        // 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(userVO.getUserPw());
        userVO.setUserPw(encodedPassword);
        
        // 기본 권한 설정
        userVO.setUserRole("USER");
        
        // 회원 등록
        sqlSession.getMapper(UserMapper.class).insertUser(userVO);
    }

    @Override
    public UserVO login(UserVO userVO) throws Exception {
        // DB에서 회원 정보 조회
        UserVO storedUser = sqlSession.getMapper(UserMapper.class).selectUserById(userVO.getUserId());
        
        if (storedUser != null) {
            // 비밀번호 일치 여부 확인
            if (passwordEncoder.matches(userVO.getUserPw(), storedUser.getUserPw())) {
                // 마지막 로그인 시간 업데이트
                sqlSession.getMapper(UserMapper.class).updateLastLogin(userVO.getUserId());
                return storedUser;
            }
        }
        
        return null; // 로그인 실패
    }

    @Override
    public UserVO getUserInfo(String userId) throws Exception {
        return sqlSession.getMapper(UserMapper.class).selectUserById(userId);
    }

    @Override
    public void updateUser(UserVO userVO) throws Exception {
        // 비밀번호가 변경된 경우에만 암호화
        if (userVO.getUserPw() != null && !userVO.getUserPw().isEmpty()) {
            String encodedUserPw = passwordEncoder.encode(userVO.getUserPw());
            userVO.setUserPw(encodedUserPw);
        }
        
        sqlSession.getMapper(UserMapper.class).updateUser(userVO);
    }

    @Override
    public void deleteUser(String userId) throws Exception {
        sqlSession.getMapper(UserMapper.class).deleteUser(userId);
    }

    @Override
    public boolean checkUserId(String userId) throws Exception {
        int count = sqlSession.getMapper(UserMapper.class).checkUserId(userId);
        return count > 0; // 이미 존재하면 true 반환
    }

    @Override
    public boolean checkUserEmail(String userEmail) throws Exception {
        int count = sqlSession.getMapper(UserMapper.class).checkUserEmail(userEmail);
        return count > 0; // 이미 존재하면 true 반환
    }
}
