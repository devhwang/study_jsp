<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 

1. 경로 및 파일명 : WebContent > jsp > login > signIn.jsp
2. 로그인 클릭시 아이디, 비밀번호에 입력값이 있는지 확인
   signProcess.jsp로 submit 하여 로그인 처리
3. 회원가입 클릭시 회원가입 화면이로 이동
4. 테이블 : CM_USER
5. 컬럼 : 아이디 - USER_ID, 비밀번호 - USER_PW
6. signProcess.jsp : 로그인, 회원가입 화면의 request를 받아 DB 처리 후 화면이동
     로그인 처리 구분값 process="signin"

 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 화면</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css" type="text/css">
<style type="text/css">
	
	table {
		border-collapse: collapse;
		border-top: 1px solid black;
		border-left: 1px solid black;
		width: 100%;
		height: 100px;
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

	
	function doLogin(){

		if(!$("#USER_ID").val()){
			alert("아이디를 입력하여 주십시오");
			$("#USER_ID").focus();
			return;
			
		}else if(!$("#USER_PW").val()){
			alert("패스워드를 입력하여 주십시오");
			$("#USER_PW").focus();
			return;
		}
		
		$("#loginForm").submit();		
	}

</script>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<body>
	<div class="container">
		<div class="outer">
			<div class="inner">
			
				<div class="centered">		
					<div class="title">로그인</div>
					<form id="loginForm" action="../sign/signin" method="post">
					<table>
						<tr>
							<th>아이디*</th>
							<td><input type="text" id="USER_ID" name="USER_ID" size="8" placeholder=""></td>
						</tr>
						<tr>
							<th>비밀번호</th>
							<td><input type="password" id="USER_PW"  name="USER_PW" size="8" placeholder=""></td>		
						</tr>
					</table>
					</form>
				</div>	
				
				<div class="centered">
					<input type="button" value="로그인" onclick="doLogin()">
					<input type="button" value="회원가입" onclick="location.href='../sign/form'">
				</div>
				
			</div>
		</div>
	</div>
</body>
</html>