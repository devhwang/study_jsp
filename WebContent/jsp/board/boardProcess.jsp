<%@page import="javax.xml.ws.Response"%>
<%@page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%!
	public boolean doWrite(Map brdInfo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@220.76.203.39:1521:UCS", "UCS_STUDY", "qazxsw");
			
			pstmt = conn.prepareStatement("INSERT INTO BOARD (SEQ,TITLE,CONTENTS,REG_ID,REG_DATE,MOD_DATE) VALUES ((SELECT MAX(SEQ)+1 FROM BOARD),?,?,?,SYSDATE,SYSDATE)");
			pstmt.setString(1, (String) brdInfo.get("TITLE"));
			pstmt.setString(2, (String) brdInfo.get("CONTENTS"));
			pstmt.setString(3, (String) brdInfo.get("REG_ID"));
			
			if(pstmt.executeUpdate()>0){
				return true;	
			}else{
				return false;
			}
			
		} catch (Exception e){
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			throw e;
		}finally{
			if (rs != null) try { rs.close(); } catch(SQLException ex) {ex.getStackTrace();}
	        if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {ex.getStackTrace();}
	        if (conn != null) try { conn.close(); } catch(SQLException ex) {ex.getStackTrace();}
		}	
	}
%>
<%
	String process = request.getParameter("PROCESS");
	if("write".equals(process)){
		
		Map brdInfo = new HashMap();
		brdInfo.put("TITLE", request.getParameter("TITLE")); System.out.println(request.getParameter("TITLE"));
		brdInfo.put("CONTENTS", request.getParameter("CONTENTS")); System.out.println(request.getParameter("CONTENTS"));
		brdInfo.put("REG_ID", session.getAttribute("USER_ID")); System.out.println(session.getAttribute("USER_ID"));
		
		if(doWrite(brdInfo)){
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