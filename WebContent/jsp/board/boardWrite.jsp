<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
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
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css" type="text/css">
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
<script>
	function fn_submit(){
		
		var title = $("#TITLE");
		var contents = $("#CONTENTS");
		
		if(title.val()==""){
			alert("제목을 입력하여 주십시오");
			title.focus();
			return;
		}else if(contents.val()==""){
			alert("내용을 입력하여 주십시오");
			contents.focus();
			return;
		}
		
		var param = {
			"TITLE" : title.val(),
			"CONTENTS" : contents.val()
		}
	
		$.ajax({
			url:'<%= request.getContextPath()%>/board/write',
			data: {'param' : JSON.stringify(param)},
			type:'POST',
			contentType:'application/x-www-form-urlencoded; charset=UTF-8',
			dataType:'json',
			error:function(request,status,error){
		    	alert("[error code] : "+ request.status + "\n\n[message] :\n\n " + request.responseText + "\n[error msg] :\n " + error); //에러상황
		    },
			success:function(data){
				if(data['error']){
					alert(data['error']);
					return;
				}
				
				if(data['success']){
					alert(data['success']);
				}
				
				location.href='<%= request.getContextPath()%>/board/main'
			}
		});
	}
	
</script>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>

<div class="container">
  <div class="outer">
    <div class="inner">
   		<div class="centered">
	   		<div class="title">◎  게시판 입력</div>
			<form id="boardWriteForm">
		   		<table id="view">
					<tr>
						<th style="width: 30%">제목</th>
						<td><input type="text" id="TITLE" name="TITLE" style="width:99%;" autofocus="autofocus"></td>
					</tr>
					<tr>
						<th>내용</th>
						<td style="width: 70%">
							<textarea id="CONTENTS" name="CONTENTS" rows="" cols="" style="width:99%; height:200px;"></textarea> 
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div class="centered">
			<input type="button" value="저장" onclick="fn_submit()">
			<input type="button" value="취소" onclick="history.back(-1)">
		</div>
    </div>
  </div>
</div>


</body>
</html>