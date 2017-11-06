package co.kr.ucs.controller;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import co.kr.ucs.service.SignService;

//@WebServlet(urlPatterns = {"/sign/*"}, loadOnStartup = 1)
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
		JSONObject result = new JSONObject();//반환할 결과
		
		//요청분석
		String[] uri = request.getRequestURI().split("/");
		String process = uri[uri.length-1];
		
		String path = request.getContextPath();///study_jsp
		String msg = "";//사용자에게 출력할 메시지
		Boolean isSuccess = false; //성공여부

		//유저 정보
		String param = request.getParameter("param");
		Map<String, String> userInfo = new HashMap<String, String>();
		JSONObject jsonObj =null;
		
		if(param != null){
			JSONParser parser = new JSONParser();
			jsonObj = (JSONObject)parser.parse(param);
			userInfo.put("USER_ID",jsonObj.get("USER_ID").toString());
			userInfo.put("USER_PW",jsonObj.get("USER_PW").toString());
		}
		
		//기능수행
		if(process.equals("main")){//메인 페이지로 이동
			RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/login/signIn.jsp");
			dispatcher.forward(request, response);			
			
		}else if(process.equals("form")){//회원가입 폼으로 이동
			RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/login/signUp.jsp");
			dispatcher.forward(request, response);			
			
		}else if(process.equals("signin")){
			if(!sign.doLogin(userInfo)){
				msg ="아이디 또는 패스워드가 맞지 않습니다";
			}else{
				request.getSession().setAttribute("USER_ID", userInfo.get("USER_ID"));
				request.getSession().setAttribute("USER_NM", userInfo.get("USER_NM"));
				request.getSession().setAttribute("EMAIL", userInfo.get("EMAIL"));
				
				msg = userInfo.get("USER_NM")+"님 방문을 환영합니다.";
				isSuccess = true;
			}			
			
		}else if(process.equals("signup")){
			userInfo.put("USER_NM",jsonObj.get("USER_NM").toString());
			userInfo.put("EMAIL",jsonObj.get("EMAIL").toString());
			
			System.out.println(userInfo);
			
			if(!sign.createAccount(userInfo)) {
				msg ="이미 존재하는 아이디입니다.";
			} else {
				msg ="성공적으로 가입되었습니다";	
				isSuccess = true;
			}
			
		}else{
			msg ="잘못된 접근입니다.";
		}
		
		if(isSuccess == false) {
			result.put("error", msg);
		}else {
			result.put("success", msg);
		}
		
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(result.toJSONString());
		
	}
}
