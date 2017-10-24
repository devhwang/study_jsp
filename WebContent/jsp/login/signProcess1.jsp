<%@ page import="javax.xml.ws.Response"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="co.kr.ucs.service.SignService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	SignService sign = new SignService();	
	String process = request.getParameter("PROCESS");
	if("signin".equals(process)){
		Map loginInfo = new HashMap();
		loginInfo.put("USER_ID", request.getParameter("USER_ID"));
		loginInfo.put("USER_PW", request.getParameter("USER_PW"));
		
		Map userInfo = new HashMap();
		if(!sign.doLogin(loginInfo, userInfo)) {
			// 로그인 실패
			PrintWriter msg = response.getWriter();
			msg.println("<script>");
			msg.println("alert('"+"아이디 또는 비밀번호가 일치하지 않습니다"+"')");
			msg.println("location.href='signIn.jsp'");
			msg.println("</script>");
			
		} else {
			for(Object key : userInfo.keySet()) {
				session.setAttribute((String)key, userInfo.get(key));
			}
			//  페이지 이동
			response.sendRedirect("../board/boardList.jsp");						
		}
	} else if("signup".equals(process)){
		Map applyInfo = new HashMap();
		applyInfo.put("USER_ID", request.getParameter("USER_ID"));
		applyInfo.put("USER_PW", request.getParameter("USER_PW"));
		applyInfo.put("USER_NM", request.getParameter("USER_NM"));
		applyInfo.put("EMAIL", request.getParameter("EMAIL"));
	
		if(!sign.createAccount(applyInfo)) {
			PrintWriter msg = response.getWriter();
			msg.println("<script>");
			msg.println("alert('"+"이미 존재하는 계정입니다"+"')");
			msg.println("location.href='signUp.jsp'");
			msg.println("</script>");
		} else {
			PrintWriter msg = response.getWriter();
			msg.println("<script>");
			msg.println("alert('"+"가입에 성공하였습니다."+"')");
			msg.println("location.href='signIn.jsp'");
			msg.println("</script>");
		}
	}
 %>