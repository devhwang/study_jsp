<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.*, java.sql.*, java.util.*"%>
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	HashMap<String, String> brdInfo = new HashMap<String, String>();
	
	try{	
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection("jdbc:oracle:thin:@220.76.203.39:1521:UCS", "UCS_STUDY", "qazxsw");
		
		String query = 
				" SELECT A.SEQ, A.TITLE, A.CONTENTS, A.REG_ID, TO_CHAR(A.REG_DATE,'yyyy-mm-dd') REG_DATE, A.MOD_DATE, B.USER_NM AS REG_NM"
			   +" FROM BOARD A, CM_USER B"
			   +" WHERE A.REG_ID = B.USER_ID"
			   +" AND SEQ = ?";
		
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, request.getParameter("seq"));
		
		rs = pstmt.executeQuery();
		
		if(rs.next()){
			brdInfo.put("SEQ",rs.getString("SEQ"));
			brdInfo.put("TITLE",rs.getString("TITLE"));
			brdInfo.put("CONTENTS",rs.getString("CONTENTS"));
			brdInfo.put("REG_ID",rs.getString("REG_ID"));
			brdInfo.put("REG_NM",rs.getString("REG_NM"));
			brdInfo.put("REG_DATE",rs.getString("REG_DATE"));
			brdInfo.put("MOD_DATE",rs.getString("MOD_DATE"));
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if (rs != null) try { rs.close(); } catch(SQLException ex) {ex.getStackTrace();}
        if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {ex.getStackTrace();}
        if (conn != null) try { conn.close(); } catch(SQLException ex) {ex.getStackTrace();}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../../css/common.css" type="text/css">
<style type="text/css">
		
	#form {
		border-collapse: collapse;
		border-top: 1px solid black;
		border-left: 1px solid black;
	}  
	#form th, #form td {
		border-bottom: 1px solid black;
		border-right: 1px solid black;
	}
	
	#form /* 글작성 폼 영역 */
	{
		width: 100%;
		text-align: left;
	}
	
	#navigator/* 페이징 영역  */
	{
		width: 200px;
		margin : auto;
		float : left;		
		width: 300px;
		
	}
	
	textarea{
		width: 98%;
		height: 200px;
	}
	
	input[type="text"]{
		width : 98%;
		height: 100%;	
	}
		
	
</style>
</head>
<body>

<div class="container">
  <div class="outer">
    <div class="inner">
   		
   		<div class="centered">
	   		<div class="title">◎  게시판 입력</div>
		   		<table id="form">
					<tr>
						<th style="width: 25%">작성자</th>
						<td style="width: 25%"><%= brdInfo.get("REG_NM")%> </td>
						<th style="width: 25%">작성일</th>
						<td style="width: 25%"><%= brdInfo.get("REG_DATE") %></td>
					</tr>
					<tr>
						<th>제목</th>
						<td colspan="3">
							<%= brdInfo.get("TITLE") %>
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td colspan="3" style="height:200px">
							<%= brdInfo.get("CONTENTS") %> 
						</td>
					</tr>
				</table>
		</div>
		<div class="centered">
			<input type="button" value="뒤로" onclick="history.back(-1)">
		</div>
    </div>
  </div>
</div>


</body>
</html>