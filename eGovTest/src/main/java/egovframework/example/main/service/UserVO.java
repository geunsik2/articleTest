package egovframework.example.main.service;

import java.sql.Date;

public class UserVO {
	private String userId;      // 회원 아이디
    private String userPw;      // 회원 비밀번호
    private String userName;    // 회원 이름
    private String userEmail;   // 회원 이메일
    private String userRole;    // 회원 권한 (USER, ADMIN 등)
    private Date userDate;      // 가입일
    private Date lastLogin;		// 마지막 로그인 시간
    
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPw() {
		return userPw;
	}
	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getUserRole() {
		return userRole;
	}
	public void setUserRole(String userRole) {
		this.userRole = userRole;
	}
	public Date getUserDate() {
		return userDate;
	}
	public void setUserDate(Date userDate) {
		this.userDate = userDate;
	}
	public Date getLastLogin() {
		return lastLogin;
	}
	public void setLastLogin(Date lastLogin) {
		this.lastLogin = lastLogin;
	}
}
