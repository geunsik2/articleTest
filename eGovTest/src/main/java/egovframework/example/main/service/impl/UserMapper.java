package egovframework.example.main.service.impl;

import egovframework.example.main.service.UserVO;

public interface UserMapper {
	// 회원 등록
    void insertUser(UserVO userVO) throws Exception;
    
    // 로그인 - 아이디와 비밀번호로 회원 조회
    UserVO selectUserByIdAndPw(UserVO userVO) throws Exception;
    
    // 회원 정보 조회
    UserVO selectUserById(String userId) throws Exception;
    
    // 회원 정보 수정
    void updateUser(UserVO userVO) throws Exception;
    
    // 회원 삭제
    void deleteUser(String userId) throws Exception;
    
    // 아이디 중복 체크
    int checkUserId(String userId) throws Exception;
    
    // 이메일 중복 체크
    int checkUserEmail(String userEmail) throws Exception;
    
    // 마지막 로그인 시간 업데이트
    void updateLastLogin(String userId) throws Exception;
}
