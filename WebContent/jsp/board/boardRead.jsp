<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <%@page import="java.io.*, java.sql.*, java.util.*"%>
<%
	HashMap<String, String> brdInfo = (HashMap)request.getAttribute("brdInfo");
%> --%>
<%
   String path = request.getContextPath();
   String pg =  request.getParameter("page");
   String type =  request.getParameter("type");
   String keyword =  request.getParameter("keyword");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 읽기</title>
<link rel="stylesheet" href="<%= path %>/css/common.css" type="text/css">
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
<script>

	$(function(){
		fn_search();
	})
	
	function goBack(){
		
		var page = "<%= pg%>";
		var type = "<%= type%>";
		var keyword = "<%= keyword%>";
		
		 location.href="<%=path %>/board/main?page="+page+"&type="+type+"&keyword="+keyword
	}

	function fn_search(){

	    var param = {};
	    
		param["seq"] = "<%= request.getParameter("seq")%>";
		param["page"] = "<%= request.getParameter("page")%>";
		
	    $.ajax({
	       url:'<%= path%>/board/detail',
	       data: {'param' : JSON.stringify(param)},
	       type:'POST',
	       contentType:'application/x-www-form-urlencoded; charset=UTF-8',
	       dataType:'json',
	       error:function(request,status,error){
	           alert("[error code] : "+ request.status + "\n\n[message] :\n\n " + request.responseText + "\n[error msg] :\n " + error); //에러상황
	        },
	       success:function(data){
			if(data['error']){ alert(data['error']); return; }            
			if(data['success']){ alert(data['success']); }
				
			$("#reg_nm").html(data["brdInfo"]["REG_NM"]);
			$("#reg_date").html(data["brdInfo"]["REG_DATE"]);
			$("#title").html(data["brdInfo"]["TITLE"]);
			$("#contents").html(data["brdInfo"]["CONTENTS"]);
	       }
	    });
	 }

</script>
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
						<td style="width: 25%"><span id="reg_nm"></span> </td>
						<th style="width: 25%">작성일</th>
						<td style="width: 25%"><span id="reg_date"></span></td>
					</tr>
					<tr>
						<th>제목</th>
						<td colspan="3">
							<span id="title"></span>
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td colspan="3" style="height:200px">
							<span id="contents"></span>
						</td>
					</tr>
				</table>
		</div>
		<div class="centered">
			<input type="button" value="뒤로" onclick="goBack()">
		</div>
    </div>
  </div>
</div>


</body>
</html>