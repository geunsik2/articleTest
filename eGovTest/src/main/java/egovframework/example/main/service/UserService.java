package egovframework.example.main.service;

public interface UserService {
	// 회원 가입
    void registerUser(UserVO userVO) throws Exception;
    
    // 로그인 처리
    UserVO login(UserVO userVO) throws Exception;
    
    // 회원 정보 조회
    UserVO getUserInfo(String userId) throws Exception;
    
    // 회원 정보 수정
    void updateUser(UserVO userVO) throws Exception;
    
    // 회원 탈퇴
    void deleteUser(String userId) throws Exception;
    
    // 아이디 중복 체크
    boolean checkUserId(String userId) throws Exception;
    
    // 이메일 중복 체크
    boolean checkUserEmail(String userEmail) throws Exception;
}
