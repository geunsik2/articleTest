package egovframework.example.main.controller;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.main.service.UserService;
import egovframework.example.main.service.UserVO;

@Controller
public class UserController {
    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserService userService;
    
    // 로그인 페이지 이동
    @RequestMapping("/loginPage.do")
    public String loginPage() {
        return "login";
    }
    
    // 회원가입 페이지 이동
    @RequestMapping("/registerPage.do")
    public String registerPage() {
        return "register";
    }
    
    // 회원가입 처리
    @RequestMapping(value = "/register.do", method = RequestMethod.POST)
    public String register(@ModelAttribute("userVO") UserVO userVO, Model model) {
        try {
            // 아이디 중복 체크
            if (userService.checkUserId(userVO.getUserId())) {
                model.addAttribute("message", "이미 사용 중인 아이디입니다.");
                return "register";
            }
            
            // 이메일 중복 체크
            if (userService.checkUserEmail(userVO.getUserEmail())) {
                model.addAttribute("message", "이미 사용 중인 이메일입니다.");
                return "register";
            }
            
            // 회원 등록
            userService.registerUser(userVO);
            
            return "redirect:/loginPage.do?registrationSuccess=true";
            
        } catch (Exception e) {
            logger.error("회원가입 실패: {}", e.getMessage());
            model.addAttribute("message", "회원가입 중 오류가 발생했습니다.");
            return "register";
        }
    }
    
    // 로그인 처리
    @RequestMapping(value = "/login.do", method = RequestMethod.POST)
    public String login(@ModelAttribute("userVO") UserVO userVO, HttpSession session, Model model) {
        try {
            UserVO loginUser = userService.login(userVO);
            
            if (loginUser != null) {
                // 로그인 성공 - 세션에 사용자 정보 저장
                session.setAttribute("loginUser", loginUser);
                return "redirect:/board.do";
            } else {
                // 로그인 실패
                model.addAttribute("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
                return "login";
            }
            
        } catch (Exception e) {
            logger.error("로그인 실패: {}", e.getMessage());
            model.addAttribute("message", "로그인 중 오류가 발생했습니다.");
            return "login";
        }
    }
    
    // 로그아웃 처리
    @RequestMapping("/logout.do")
    public String logout(HttpSession session) {
        // 세션 무효화
        session.invalidate();
        return "redirect:/board.do";
    }
    
    // 마이페이지 이동
    @RequestMapping("/myPage.do")
    public String myPage(HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            // 로그인되지 않은 경우
            return "redirect:/loginPage.do";
        }
        
        try {
            // 최신 회원 정보 조회
            UserVO userInfo = userService.getUserInfo(loginUser.getUserId());
            model.addAttribute("userInfo", userInfo);
            
            return "myPage";
            
        } catch (Exception e) {
            logger.error("회원 정보 조회 실패: {}", e.getMessage());
            model.addAttribute("message", "회원 정보 조회 중 오류가 발생했습니다.");
            return "redirect:/board.do";
        }
    }
    
    // 회원 정보 수정 처리
    @RequestMapping(value = "/updateUser.do", method = RequestMethod.POST)
    public String updateUser(@ModelAttribute("userVO") UserVO userVO, HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "redirect:/loginPage.do";
        }
        
        // 세션의 회원 ID 설정 (보안)
        userVO.setUserId(loginUser.getUserId());
        
        try {
            userService.updateUser(userVO);
            
            // 세션 정보 갱신
            UserVO updatedUser = userService.getUserInfo(loginUser.getUserId());
            session.setAttribute("loginUser", updatedUser);
            
            model.addAttribute("message", "회원 정보가 성공적으로 수정되었습니다.");
            return "redirect:/myPage.do";
            
        } catch (Exception e) {
            logger.error("회원 정보 수정 실패: {}", e.getMessage());
            model.addAttribute("message", "회원 정보 수정 중 오류가 발생했습니다.");
            return "myPage";
        }
    }
    
    // 아이디 중복 체크 (AJAX)
    @RequestMapping("/checkId.do")
    @ResponseBody
    public String checkId(@RequestParam("userId") String userId) {
        try {
            boolean exists = userService.checkUserId(userId);
            return exists ? "duplicate" : "available";
        } catch (Exception e) {
            logger.error("아이디 중복 체크 실패: {}", e.getMessage());
            return "error";
        }
    }
    
    // 이메일 중복 체크 (AJAX)
    @RequestMapping("/checkEmail.do")
    @ResponseBody
    public String checkEmail(@RequestParam("userEmail") String userEmail) {
        try {
            boolean exists = userService.checkUserEmail(userEmail);
            return exists ? "duplicate" : "available";
        } catch (Exception e) {
            logger.error("이메일 중복 체크 실패: {}", e.getMessage());
            return "error";
        }
    }
}