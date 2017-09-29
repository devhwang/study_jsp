<%@page import="co.kr.ucs.service.BoardService"%>
<%@page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	
	String process = request.getParameter("PROCESS");

	
	if("write".equals(process)){
		Map brdInfo = new HashMap();
		brdInfo.put("TITLE", request.getParameter("TITLE")); 
		brdInfo.put("CONTENTS", request.getParameter("CONTENTS"));
		brdInfo.put("REG_ID", session.getAttribute("USER_ID"));
		
		if(doWrite(brdInfo)){c
			//등록성공시 페이지이동
			pw.println(pushMsg("성공적으로 글을 등록했습니다","boardList.jsp"));
		}else{
			//동록 실패시 back
			pw.println(pushMsg("등록에 실패하였습니다","back"));			
		}
	}
 %>