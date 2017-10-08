<%@ page import="javax.xml.ws.Response"%>
<%@ page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page import="co.kr.ucs.service.BoardService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	BoardService board = new BoardService();

	String process = request.getParameter("PROCESS");
	if("write".equals(process)){
		
		Map brdInfo = new HashMap();
		brdInfo.put("TITLE", request.getParameter("TITLE")); System.out.println(request.getParameter("TITLE"));
		brdInfo.put("CONTENTS", request.getParameter("CONTENTS")); System.out.println(request.getParameter("CONTENTS"));
		brdInfo.put("REG_ID", session.getAttribute("USER_ID")); System.out.println(session.getAttribute("USER_ID"));
		
		if(board.doWrite(brdInfo)){
			PrintWriter msg = response.getWriter();
			msg.println("<script>");
			msg.println("alert('"+"성공적으로 글을 등록했습니다"+"')");
			msg.println("location.href='boardList.jsp'");
			msg.println("</script>");
		}else{
			PrintWriter msg = response.getWriter();
			msg.println("<script>");
			msg.println("alert('"+"등록에 실패하였습니다"+"')");
			msg.println("history.back(-1)");
			msg.println("</script>");
		}
	}
 %>