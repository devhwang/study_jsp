<%@page import="java.io.PrintWriter"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
/* 작업중 */
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int result = 0;
	String errMsg = "";
	
	HashMap<String, String> userInfo = new HashMap<String, String>();
	String process = request.getParameter("process");
		
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection("jdbc:oracle:thin:@220.76.203.39:1521:UCS", "UCS_STUDY", "qazxsw");

		if("signin".equals(process)){	
			pstmt = conn.prepareStatement("SELECT USER_ID, USER_PW, USER_NM, EMAIL FROM CM_USER WHERE USER_ID = ? AND USER_PW = ?");
			pstmt.setString(1, request.getParameter("user_id"));
			pstmt.setString(2, request.getParameter("user_pw"));

			rs = pstmt.executeQuery();
			
			while(rs.next()){
				userInfo.put("USER_ID", rs.getString("USER_ID"));
				userInfo.put("USER_NM", rs.getString("USER_NM"));
				userInfo.put("EMAIL", rs.getString("EMAIL"));
			}
			
			if(userInfo.get("USER_ID")!=null){
				result = 1;
			}else{
				throw new Exception("아이디 또는 패스워드가 올바르지 않습니다.");
			}
		}
		else if("signup".equals(process)){
			
			userInfo.put("USER_ID", request.getParameter("user_id"));
			userInfo.put("USER_PW", request.getParameter("user_pw"));
			userInfo.put("USER_NM", request.getParameter("user_nm"));
			userInfo.put("EMAIL", request.getParameter("email"));
			
			pstmt = conn.prepareStatement("INSERT INTO CM_USER(USER_ID,USER_PW,USER_NM,EMAIL) VALUES (?,?,?,?)");
			
			pstmt.setString(1, userInfo.get("USER_ID"));
			pstmt.setString(2, userInfo.get("USER_PW"));
			pstmt.setString(3, userInfo.get("USER_NM"));
			pstmt.setString(4, userInfo.get("EMAIL"));
			
			result = pstmt.executeUpdate();
			if(result == 0){
				throw new Exception("가입 할 수 없습니다");
			}
		}
		
		if(result > 0){
			//유저정보를 세션에 저장
			session.setAttribute("USER_ID", userInfo.get("USER_ID"));
			session.setAttribute("USER_NM", userInfo.get("USER_NM"));
			session.setAttribute("EMAIL", userInfo.get("EMAIL"));
						
			//게시판 페이지로 이동
			response.sendRedirect("../board/boardList.jsp");
		}
		
	}catch(Exception e){
		e.printStackTrace();
		PrintWriter msg = response.getWriter();
		msg.println("<script>");
		msg.println("alert('"+e.getMessage()+"')");
		msg.println("location.href='signIn.jsp'");
		msg.println("</script>");
	}finally{
		if (rs != null) try { rs.close(); } catch(SQLException ex) {ex.getStackTrace();}
        if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {ex.getStackTrace();}
        if (conn != null) try { conn.close(); } catch(SQLException ex) {ex.getStackTrace();}
		
	}
 %>