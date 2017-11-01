<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.*, java.sql.*, java.util.*"%>
<%
	HashMap<String, String> brdInfo = (HashMap)request.getAttribute("brdInfo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 읽기</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css" type="text/css">
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
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
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