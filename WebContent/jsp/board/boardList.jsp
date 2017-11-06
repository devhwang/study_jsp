<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.*, java.sql.*, java.util.*"%>
<%
	String path = request.getContextPath();

	/* ArrayList<HashMap<String,String>> list = (ArrayList)request.getAttribute("list");
	HashMap<String ,String> search = (HashMap)request.getAttribute("searchInfo");
	
	int BLOCKSIZE = Integer.parseInt(search.get("BLOCKSIZE")); 
	int ROWSIZE = Integer.parseInt(search.get("ROWSIZE"));
	int nowBlock = Integer.parseInt(search.get("nowBlock"));
	int nowPage = Integer.parseInt(search.get("nowPage"));
	int totcnt = Integer.parseInt(search.get("totcnt"));
	
	String type = search.get("type");//검색 타입(제목or작성자)
	String keyword = search.get("keyword");//검색 키워드 */
%>
<!DOCTYPE html>
<html>
<head>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>

	var searchParam = {
		'block' : "1",
		'page' : "1",
		'type' : "",
		'keyword' : ""
	}
	var pagingParam = {
		'BLOCKSIZE'	: 10,	
		'ROWSIZE'	: 10,
		'nowBlock'	: 1,
		'nowPage'	: 1,
		'totcnt'	: 1,
	}

	$(function(){			
		fn_search();	
	})

	function fn_search(){		
		//검색시 1페이지로 출력
		
		searchParam["type"] = $("#S_TYPE").val();
		searchParam["keyword"] = $("#S_KEYWORD").val();
		
		$.ajax({
			url:'<%= request.getContextPath()%>/board/list',
			data: {'param' : JSON.stringify(searchParam)},
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
				
				fn_drawTable(data);			
				

			}
		});
	}
	
	function fn_drawTableHeader(){
		$("#listview").append("<tr><th style='width:10%'>글번호</th><th style='width:40%'>제목</th><th style='width:15%'>작성자</th>	<th style='width:15%'>작성일</th></tr>");
		return;
	}
		
	function fn_drawTable(data){
		$("#listview").html("");

		fn_drawTableHeader();
		
		if(data["list"].length == 0){
			$("#listview").html("<tr><td colspan='4'>조회 결과가 없습니다</td></tr>")
		}else{
			for(var i in data["list"]){
				var row = "";
				row += "<tr>";
				row += "<td>"+data["list"][i]["SEQ"]+"</td>";
				row += "<td>"+data["list"][i]["TITLE"]+"</td>";
				row += "<td>"+data["list"][i]["REG_NM"]+"</td>";
				row += "<td>"+data["list"][i]["REG_DATE"]+"</td>";				
				row += "</tr>"
				
				$("#listview").append(row);
			}
		}
	}

	function fn_write(){
		location.href="<%=path %>/board/form";
	}
</script>
<meta charset="UTF-8">
<title>게시판 메인</title>
<link rel="stylesheet" href="<%=path %>/css/common.css" type="text/css">
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
		text-align: center;
	}
	
	#search/* 검색영역  */
	{
		width: 350px;
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
		width : 10px;
	    margin: 0 3px 0 3px;
	    padding: 0 3px 0 3px;
	    border : 0;
	    float: left;
	}
	
</style>
</head>
<body>
<div class="container">
  <div class="outer">
    <div class="inner">
		<div class="centered">
   		<div class="title">◎  게시판 목록</div>
		<table id="search">
			<tr>
				<td>
					<select id="S_TYPE" >
 						<option value="title">제목</option>
						<option value="name">작성자</option>
					</select>
				</td>
				<td>
					<input type="text" id="S_KEYWORD" value="" onKeydown="javascript:if(event.keyCode == 13) fn_search();" autofocus="autofocus">
				</td>
				<td>
					<input type="button" value='검색' onclick="fn_search()">
				</td>
				<td>
					
					<input type="button" value='글쓰기' onclick="fn_write()">		
				</td>
			</tr>
		</table>
		
   		<table id="listview">
			
			
		</table>
					
	<%-- 		<div id="navigator" class="centered">
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
					<li><input type="button" value="&lt;&lt;" onclick='location.href="<%=path %>/board/main?block=1&page=1&type=<%=type%>&keyword=<%=keyword%>"'></li>
					<li><input type="button" value="&lt;" onclick='location.href="<%=path %>/board/main?block=<%=nowBlock-1%>&page=<%=pg%>&type=<%=type%>&keyword=<%=keyword%>"'></li>
		<%		
				}else if(i%ROWSIZE == 0 && i/ROWSIZE == nowPage){//현재 페이지 일경우 페이지버튼 링크X
		%>
					<li><b><%= pg %></b></li>
		<%		
				}else if(i%ROWSIZE == 0){ //0으로 나누어 떨어질경우 페이지로 분류
		%>
					<li><a href="<%=path %>/board/main?block=<%=nowBlock%>&page=<%=pg%>&type=<%=type%>&keyword=<%=keyword%>"><%= pg %></a></li>
		<%
				}else if(i/ROWSIZE >= (BLOCKSIZE*nowBlock)){//정해진 페이지 이상을 넘어설경우 다음으로 처리	
		%>
					<li><input type="button" value="&gt;" onclick='location.href="<%=path %>/board/main?block=<%=nowBlock+1%>&page=<%=pg+1%>&type=<%=type%>&keyword=<%=keyword%>"'></li>
					<li><input type="button" value="&gt;&gt;" onclick='location.href="<%=path %>/board/main?block=<%=lastBlock%>&page=<%=lastPage%>&type=<%=type%>&keyword=<%=keyword%>"'></li>
		<%
				break;
				}
			}
		%>  
		</ul>
		
		</div>  
		--%>
		
		</div>	
		
		
    </div>
  </div>
</div> 


</body>
</html>