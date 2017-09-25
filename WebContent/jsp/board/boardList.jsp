<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.*, java.sql.*, java.util.*"%>
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
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	
	String url,id,pw, query;
	
	//--페이징처리 관련 변수
	final int BLOCKSIZE = 10, ROWSIZE = 10; //group당 몇개의 page를 표현할 것인가//page당 몇개의 row를 표현할 것인가
	int totcnt = 0;//resultSet 순회시 대입됨

	
	int nowBlock = Integer.parseInt(request.getParameter("block")==null?"1":request.getParameter("block")); //네비게이터; 현재 어떤 그룹을 보고있는가
	int nowPage = Integer.parseInt(request.getParameter("page")==null?"1":request.getParameter("page")); //네비게이터; 현재 어떤 페이지를 보고있는가
	 		
	int minRowNum = ROWSIZE * (nowPage-1);//페이지 네비게이터 최소페이지
	int maxRowNum = ROWSIZE * (nowPage);//페이지 네비게이터 최대 페이지

	ArrayList<Map> list = new ArrayList<Map>();
	
	try{
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection("jdbc:oracle:thin:@220.76.203.39:1521:UCS", "UCS_STUDY", "qazxsw");
		
		query = 		
		  "SELECT *"
		+" FROM" 
				+"( SELECT C.*, ROWNUM AS RNUM, COUNT(*) OVER() AS TOTCNT"
				 +" FROM "
				  	 +"( SELECT A.SEQ, A.TITLE, A.CONTENTS, A.REG_ID, TO_CHAR(A.REG_DATE,'yyyy-mm-dd') REG_DATE, A.MOD_DATE, B.USER_NM AS REG_NM"
					  +" FROM BOARD A, CM_USER B"
					  +" WHERE A.REG_ID = B.USER_ID"
					  +" ORDER BY SEQ DESC)C)"
		+" WHERE RNUM > ? AND RNUM <=?";
		
		pstmt = conn.prepareStatement(query);
		
		pstmt.setInt(1, minRowNum);
		pstmt.setInt(2, maxRowNum);
		
		rs = pstmt.executeQuery();

		
		while(rs.next()){
			
			Map brdInfo = new HashMap();
			
			if(rs.isFirst()){
				totcnt = rs.getInt("TOTCNT");
			}
			
			brdInfo.put("SEQ",rs.getString("SEQ"));
			brdInfo.put("TITLE",rs.getString("TITLE"));
			brdInfo.put("CONTENTS",rs.getString("CONTENTS"));
			brdInfo.put("REG_ID",rs.getString("REG_ID"));
			brdInfo.put("REG_NM",rs.getString("REG_NM"));
			brdInfo.put("REG_DATE",rs.getString("REG_DATE"));
			brdInfo.put("MOD_DATE",rs.getString("MOD_DATE"));
			
			list.add(brdInfo);
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
		width: 350px;
		
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
<%
	for(int i = 0; i < list.size(); i++){
%>
	<tr>
		<td><%= list.get(i).get("SEQ") %></td>
		<td><a href="read.jsp?brdno=<%= list.get(i).get("SEQ")%>"><%= list.get(i).get("TITLE")%></a></td>
		<td><%= list.get(i).get("REG_NM")%></td>
		<td><%= list.get(i).get("REG_DATE")%></td>
	</tr>
<%	
	}
%>
		</table>		
		<div id="navigator" class="centered">
		<ul>
<%
		
		int startRow = (BLOCKSIZE*ROWSIZE*(nowBlock-1))+1; //출력을 시작하는 행
		int endRow = totcnt+ROWSIZE;//출력을 종료하는 행
		int lastBlock = ((totcnt/ROWSIZE)/BLOCKSIZE)+1;//전체 리스트의 마지막 블럭
		int lastPage = (totcnt/ROWSIZE) + 1;// 전체 리스트의 마지막 페이지
		
		for(int i = startRow; i < endRow; i++){
			int pgBtn = i%ROWSIZE;//페이지 네이게이션 버튼
			int pg = i/ROWSIZE;//대상이 되는 페이지
			if(i == startRow && nowBlock!=1){//문서 시작시 이전 페이지 이동버튼설정 (1페이지는 설정안함)
	%>
				<li><input type="button" value="&lt;&lt;" onclick='location.href="boardList.jsp?block=1&page=1"'></li>
				<li><input type="button" value="&lt;" onclick='location.href="boardList.jsp?block=<%=nowBlock-1%>&page=<%=pg%>"'></li>
	<%		
			}else if(pgBtn == 0 && pg == nowPage){//현재 페이지 일경우 페이지버튼 링크X
	%>
				<li><b><%= pg %></b></li>
	<%		
			}else if(pgBtn == 0){ //0으로 나누어 떨어질경우 페이지로 분류
	%>
				<li><a href="boardList.jsp?block=<%=nowBlock%>&page=<%=pg%>"><%= pg %></a></li>
	<%
			}else if(pg >= (BLOCKSIZE*nowBlock)){//정해진 페이지 이상을 넘어설경우 다음으로 처리	
	%>
				<li><input type="button" value="&gt;" onclick='location.href="boardList.jsp?block=<%=nowBlock+1%>&page=<%=pg+1%>"'></li>
				<li><input type="button" value="&gt;&gt;" onclick='location.href="boardList.jsp?block=<%=lastBlock%>&page=<%=lastPage%>"'></li>
	<%
			break;
			}
		}
	%>
		</ul>
		</div> 
		
		</div>	
		
		
    </div>
  </div>
</div>


</body>
</html>