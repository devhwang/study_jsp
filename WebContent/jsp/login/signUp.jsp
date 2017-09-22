<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<link rel="stylesheet" href="../../css/common.css" type="text/css">
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
	var joinForm = document.getElementById("joinForm");
	joinForm.submit();
}

</script>
<body>
<form id="joinForm" action="signProcess.jsp" method="post">
	<div class="container">
		<div class="outer">
			<div class="inner">
			
				<div class="centered">
					<div class="title">◎ 회원가입</div>
					<input type="hidden" name="process" value="signup">
					<table>
						<tr>
							<th>아이디*</th>
							<td><input type="text" name="USER_ID" size="8" placeholder=""></td>
						</tr>
						<tr>
							<th>이름</th>
							<td><input type="text" name="USER_NM" size="30" placeholder=""></td>
						</tr>
						<tr>
							<th>비밀번호</th>
							<td><input type="password" name="USER_PW" size="8" placeholder=""></td>		
						</tr>
						<tr>
							<th>비밀번호 확인</th>
							<td><input type="password" name="USER_PW_CHECK" size="8" placeholder=""></td>		
						</tr>
						<tr>
							<th>이메일</th>
							<td><input type="text" name="USER_EMAIL" size="30" placeholder=""></td>
						</tr>
					</table>
				</div>
				
				<div class="centered">
					<input type="button" value="회원가입"  onclick="doJoin()">
					<input type="button" value="취소" onclick="location.href='signIn.jsp'">
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>