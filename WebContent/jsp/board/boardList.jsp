<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 
1. 경로 및 파일명 : WebContent > jsp > board > boardList.jsp
2. 기본조회 : 최근 입력(수정)한 날짜 기준으로 조회
3. 테이블 : CM_USER
4. 컬럼 : 아이디 - USER_ID, 이름 - USER_NM, 비밀번호 - USER_PW,  이메일 - EMAIL
5. signProcess.jsp : 로그인, 회원가입 화면의 request를 받아 DB 처리 후 화면이동
	회원가입 처리 구분값 process="siginup"

※ 유효성검사
아이디 중복체크
 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../../css/common.css" type="text/css">
<style type="text/css">
		
	#listview {
		border-collapse: collapse;
		border-top: 1px solid black;
		border-left: 1px solid black;
	}  
	#listview th, #listview td {
		border-bottom: 1px solid black;
		border-right: 1px solid black;
	}
	
	#listview/* 리스트영역 */
	{
		width: 100%;
		height: 200px;
		text-align: center;
	}
	
	#search/* 검색영역  */
	{
		width: 300px;
		text-align: center;
		border: none 0px grey;
	}
	
	#navigator/* 페이징 영역  */
	{
		width: 230px;
		
	}
	
	#search input[type="button"],  #search select
	{
		width: 100%;
		hegiht : 100%;
	}
		
	ul 
	{
	    list-style:none;
	    margin:0;
	    padding:0;
	}

	li 
	{
	    margin: 0 0 0 0;
	    padding: 0 3px 0 0;
	    border : 0;
	    float: left;
	}
	
</style>
</head>
<body>
<%= session.getAttribute("USER_NM") %>님 환영합니다
<div class="container">
  <div class="outer">
    <div class="inner">
		<div class="centered">
   		<div class="title">◎  게시판 목록</div>
		<table id="search">
			<tr>
				<td>
					<select name="type">
						<option selected="selected">제목</option>
						<option>작성자</option>
					</select>
				</td>
				<td>
					<input type="text">
				</td>
				<td>
					<input type="button" value='검색'>	
				</td>
			</tr>
		</table>
		
   		<table id="listview">
			<tr>
				<th>글번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
			</tr>
			<tr>
				<td>1</td>
				<td><a href='boardRead.jsp'>게시판 목록을 작성하자</a></td>
				<td>홍길동</td>
				<td>2017.09.13</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		</table>
		
		<div id="navigator" class="centered">
			<ul>
				<li><input type="button" value="<<"></li>
				<li><input type="button" value="<"></li>
				<li><b>1</b></li>
				<li><a href="#">2</a></li>
				<li><a href="#">3</a></li>
				<li><a href="#">4</a></li>
				<li><a href="#">5</a></li>
				<li><a href="#">6</a></li>
				<li><a href="#">7</a></li>
				<li><a href="#">8</a></li>
				<li><a href="#">9</a></li>
				<li><input type="button" value=">>"></li>
				<li><input type="button" value=">"></li>
			</ul>
		</div>
		
		</div>	
		
		
    </div>
  </div>
</div>


</body>
</html>