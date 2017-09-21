<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 
1. HTML로 게시판 입력 페이지를 작성
2. 경로 및 파일명 : WebContent > html > boradWrite.html
3. 내용 입력란은 textarea로 생성 
 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../../css/common.css" type="text/css">
<style type="text/css">
		
	#view {
		border-collapse: collapse;
		border-top: 1px solid black;
		border-left: 1px solid black;
	}  
	#view th, #view td {
		border-bottom: 1px solid black;
		border-right: 1px solid black;
	}
	
	#view/* 글작성 폼 영역 */
	{
		width: 100%;
		text-align: left;
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
		   		<table id="view">
					<tr>
						<th style="width: 30%">제목</th>
						<td><input type="text" style="width:99%;""></td>
					</tr>
					<tr>
						<th>내용</th>
						<td style="width: 70%">
							<textarea rows="" cols="" style="width:99%; height:200px;"></textarea> 
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div class="centered">
			<input type="button" value="저장" onclick="location.href='boardList.jsp'">
			<input type="button" value="취소" onclick="location.href='boardList.jsp'">
		</div>
    </div>
  </div>
</div>


</body>
</html>