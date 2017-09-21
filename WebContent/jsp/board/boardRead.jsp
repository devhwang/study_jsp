<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 
	HTML로 게시판 상세 페이지를 작성
	경로 및 파일명 : WebContent > html > boradRead.html
 -->
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
			<form action="" method="post">
		   		<table id="form">
					<tr>
						<th style="width: 25%">작성자</th>
						<td style="width: 25%">홍길동</td>
						<th style="width: 25%">작성일</th>
						<td style="width: 25%">2017.09.13</td>
					</tr>
					<tr>
						<th>제목</th>
						<td colspan="3">
							게시판 목록을 작성하자 
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td colspan="3" style="height:200px">
							게시판 상세를 입력 
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div class="centered">
			<input type="button" value="뒤로" onclick="location.href='boardList.jsp'">
		</div>
    </div>
  </div>
</div>


</body>
</html>