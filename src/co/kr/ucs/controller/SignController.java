package co.kr.ucs.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import co.kr.ucs.service.SignService;

@WebServlet(urlPatterns = {"/sign/*"}, loadOnStartup = 1)
public class SignController extends HttpServlet{

	private static final long serialVersionUID = 1L;

	private static final Logger logger = LoggerFactory.getLogger(SignController.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			processRequest(request, response);
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			processRequest(request, response);
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void processRequest(HttpServletRequest request, HttpServletResponse response) throws Throwable {
		response.setContentType("text/html; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");

		SignService sign = new SignService();
		
		//요청분석
		String[] uri = request.getRequestURI().split("/");
		String process = uri[uri.length-1];
		
		String path = request.getContextPath();///study_jsp
		String msg = "";//사용자에게 출력할 메시지
		String view = "";//이동시킬 URL	
		
		//유저 정보
		Map userInfo = new HashMap();
		userInfo.put("USER_ID", request.getParameter("USER_ID"));
		userInfo.put("USER_PW", request.getParameter("USER_PW"));
		userInfo.put("USER_NM", request.getParameter("USER_NM"));
		userInfo.put("EMAIL", request.getParameter("EMAIL"));
		
		//기능수행
		if(process.equals("main")){//메인 페이지
			view = "/jsp/login/signIn.jsp";
			
		}else if(process.equals("form")){
			view = "/jsp/login/signUp.jsp";
			
		}else if(process.equals("signin")){
			if(!sign.doLogin(userInfo)){
				msg ="아이디 또는 패스워드가 맞지 않습니다";
				view = "";
			}else{
				/*for(Object key : userInfo.keySet()) {	 request.getSession().setAttribute((String)key, userInfo.get(key));	}*/
				request.getSession().setAttribute("USER_ID", userInfo.get("USER_ID"));
				request.getSession().setAttribute("USER_NM", userInfo.get("USER_NM"));
				request.getSession().setAttribute("EMAIL", userInfo.get("EMAIL"));
				
				msg = userInfo.get("USER_NM")+"님 방문을 환영합니다.";
				view = "/board/main";
			}			
			
		}else if(process.equals("signup")){
			if(!sign.createAccount(userInfo)) {
				msg ="이미 존재하는 아이디입니다.";
				view = "";
			} else {
				msg ="성공적으로 가입되었습니다";
				view = "/sign/main";		
			}
			
		}else{
			msg ="잘못된 접근입니다.";
			view = "/sign/main";
		}
		
		//페이지이동
		//--메시지가 존재하는 경우 해당 메시지를 출력 후 페이지 이동
		if(msg.equals("")) {			
			RequestDispatcher dispatcher = request.getRequestDispatcher(view);
			dispatcher.forward(request, response);			
		}else {			
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('"+msg+"')");
			if("".equals(view)) { 
				pw.println("history.back(-1)");
			}else {
				pw.println("location.href='"+path+view+"'");
			}
			pw.println("</script>");
		}
				

	}
}
