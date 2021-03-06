<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!-- 

1. 경로 및 파일명 : WebContent > jsp > login > signUp.jsp
2. 가입 클릭시 아이디, 이름, 비밀번호, 비밀번호 확인, 이메일에 입력값이 있는지 확인 후
	signProcess.jsp로 submit 하여 로그인 처리
3. 회원가입 클릭시 회원가입 화면이로 이동
4. 테이블 : CM_USER
5. 컬럼 : 아이디 - USER_ID, 이름 - USER_NM, 비밀번호 - USER_PW,  이메일 - EMAIL
6. signProcess.jsp : 로그인, 회원가입 화면의 request를 받아 DB 처리 후 화면이동
	- 회원가입 처리 구분값 process="siginup"

※ 유효성검사
	- 아이디 중복체크

 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 화면</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css" type="text/css">
<style type="text/css">
	
	table {
		border-collapse: collapse;
		border-top: 1px solid black;
		border-left: 1px solid black;
		width: 100%;
		height: 200px;
		text-align: center;
	}  
	table th, table td {
		border-bottom: 1px solid black;
		border-right: 1px solid black;
	}
	
	input[type="text"],input[type="password"]{
		width: 80%;
	}
	
	#container{
		float: left;
		margin: 0 auto;
	}

</style>
</head>
<script>
function doJoin(){
	var userId = $("#USER_ID");
	var userPw = $("#USER_PW");
	var userPwAgain = $("#USER_PW_AGAIN");
	var userNm = $("#USER_NM");
	var email = $("#EMAIL");
	
	if(!userId.val()){
		alert("아이디를 입력하여 주십시오");
		userId.focus();
		return;
	}else if(!userNm.val()){
		alert("이름을 입력하여 주십시오");
		userNm.focus();
		return;
	}else if(!userPw.val()){
		alert("비밀번호를 입력하여 주십시오");
		userPw.focus();
		return;
	}else if(!userPwAgain.val()){
		alert("비밀번호 확인란을 입력하여 주십시오");
		userPwAgain.focus();
		return;
	}else  if(!email.val()){
		alert("이메일을 입력하여 주십시오");
		email.focus();
		return;
	}else 
		
	if(userPw.val() != userPwAgain.val()){
		alert("비밀번호와 비밀번호 확인란이 일치하지 않습니다. 확인해주세요");
		userPw.val() = "";
		userPwAgain.val() = "";
		userPw.focus();
		return;
	}
	
	//이메일 유효성 검사 정규식
	var regExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	if(email.val().match(regExp) == null){
		alert("올바르지 않은 이메일 형식입니다");
		email.val() = "";
		email.focus();
		return;
	}
	
	var param = {
		"USER_ID" : userId.val(),
		"USER_PW" : userPw.val(),
		"USER_NM" : userNm.val(),
		"EMAIL" : email.val()
	}
		
	$.ajax({
		url:'<%= request.getContextPath()%>/sign/signup',
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
			
			location.href='<%= request.getContextPath()%>/sign/main'
		}
	});
}

</script>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<body>
<!-- <form id="joinForm" action="../sign/signup" method="post" accept-charset="UTF-8"> -->
<form id="joinForm" >
	<div class="container">
		<div class="outer">
			<div class="inner">
			
				<div class="centered">
					<div class="title">◎ 회원가입</div>
					<input type="hidden" name="PROCESS" value="signup">
					<table>
						<tr>
							<th>아이디*</th>
							<td><input type="text" id="USER_ID" name="USER_ID" size="8" placeholder=""></td>
						</tr>
						<tr>
							<th>이름</th>
							<td><input type="text" id="USER_NM" name="USER_NM" size="30" placeholder=""></td>
						</tr>
						<tr>
							<th>비밀번호</th>
							<td><input type="password" id="USER_PW" name="USER_PW" size="8" placeholder=""></td>		
						</tr>
						<tr>
							<th>비밀번호 확인</th>
							<td><input type="password" id="USER_PW_AGAIN" name="USER_PW_AGAIN" size="8" placeholder=""></td>		
						</tr>
						<tr>
							<th>이메일</th>
							<td><input type="text" id="EMAIL" name="EMAIL" size="30" placeholder=""></td>
						</tr>
					</table>
				</div>
				
				<div class="centered">
					<input type="button" value="회원가입"  onclick="doJoin()">
					<input type="button" value="취소" onclick="location.href='../sign/main'">
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>