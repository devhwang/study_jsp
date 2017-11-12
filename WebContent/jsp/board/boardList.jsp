<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.*, java.sql.*, java.util.*"%>
<%
   String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
   var boardObj = {
      blockSize: 10,
      rowSize : 10,      
      totalCount : 0,
      totalPage : 0,
      pageNum : 0,
      page : "<%= request.getParameter("page")==null? 1 : request.getParameter("page")%>",
      type : "<%= request.getParameter("type")==null? 1 : request.getParameter("type")%>",
      keyword : "<%= request.getParameter("keyword")==null? 1 : request.getParameter("keyword")%>",
      contents : {}
   }
      
   $(function(){
	   $("#S_TYPE").val(boardObj.type);
	   $("#S_KEYWORD").val(boardObj.keyword);
	   
	   drawPage(boardObj.page);//출력할 페이지가 입력된다
      
   })
   
   function fn_search(){
	   
	  boardObj.keyword = $("#S_KEYWORD").val();
	  boardObj.type = $("#S_TYPE").val();
	   
      var param = {};
      param["blockSize"] = boardObj.blockSize;
      param["rowSize"] = boardObj.rowSize;
      param["page"] = boardObj.page;
      param["type"] = boardObj.type;
      param["keyword"] = boardObj.keyword;
      
      $.ajax({
         url:'<%= path%>/board/list',
         data: {'param' : JSON.stringify(param)},
         type:'POST',
         contentType:'application/x-www-form-urlencoded; charset=UTF-8',
         dataType:'json',
         async : false,
         error:function(request,status,error){
             alert("[error code] : "+ request.status + "\n\n[message] :\n\n " + request.responseText + "\n[error msg] :\n " + error); //에러상황
          },
         success:function(data){
            if(data['error']){ alert(data['error']); return; }            
            if(data['success']){ alert(data['success']); }
            
            boardObj.totalCount   = parseInt(data["searchInfo"]["totalCount"]);
            boardObj.totalPage   = parseInt(data["searchInfo"]["totalPage"]);
            boardObj.contents = JSON.parse(JSON.stringify(data["list"]));//DeepCopy
            
         }
      });
   }
   
   function drawContents(){

	  var str = "";
	  var board = boardObj.contents;
	  var totalCount = boardObj.totalCount;
	  var totalPage = boardObj.totalPage;
	  
	  str += "<tr><th style='width:10%'>글번호</th><th style='width:40%'>제목</th><th style='width:15%'>작성자</th>	<th style='width:15%'>작성일</th></tr>";
	
	  if(totalCount == 0){
		str += "<tr><td colspan='4'>조회 결과가 없습니다</td><tr>"
		totalPage = 1;
	  }else{	  
		  for(var i in board){
	         str += "<tr><td>"+board[i].SEQ+"</td>"
	         str += "<td><a href='javascript:goDetail("+board[i].SEQ+");'>"+board[i].TITLE+"</a></td>"
	         str += "<td>"+board[i].REG_NM+"</td>"
	         str += "<td>"+board[i].REG_DATE+"</td></tr>"
		  }
	  }
      $("#listview").html(str);
       
   }
   
   function drawPage(goTo){
	  boardObj.page = goTo;  
      fn_search();      
      drawContents();
      
      var blockSize = boardObj.blockSize;
      var totalCount   = boardObj.totalCount;
      var totalPage   = boardObj.totalPage;
      var pageNum      = boardObj.pageNum;
      var page      = boardObj.page;
      
      //페이징처리 관련변수      
      var pageGroup = Math.ceil(page/blockSize);/* Math.ceil(page/10); */
      var next = pageGroup*(blockSize)/* pageGroup*10; */
      var prev = next-(blockSize-1)/* next-9; */            
      var goNext = next+1;
        
      if(prev-1<=0){
          var goPrev = 1;
      }else{
          var goPrev = prev-1;
      }

      if(next>totalPage){
          var goNext = totalPage;
          next = totalPage;
      }else{
          var goNext = next+1;
      }
      
      if(pageGroup!=1){
	      var firstStep = " <input type='button' onclick='javascript:drawPage(1);' value='&lt;&lt;'</input>";
	      var prevStep = " <input type='button' onclick='javascript:drawPage("+goPrev+");' value='&lt;'</input>";
      }
      
  	  if(next < totalPage){
	      var nextStep = " <input type='button' onclick='javascript:drawPage("+goNext+");' value='&gt;'</input>";
	      var lastStep = " <input type='button' onclick='javascript:drawPage("+totalPage+");' value='&gt;&gt;'</input>";
      }
      
      $("#navigator").empty();
      $("#navigator").append(firstStep);
      $("#navigator").append(prevStep);
      
      for(var i=prev; i<=next;i++){
          if(i == page ){
             pageNum = "<strong>"+i+"</strong> ";   
          }else{
             pageNum = "<a href='javascript:drawPage("+i+")'>"+i+"</a>&nbsp;";
          }
          $("#navigator").append(pageNum);
      }
      
      $("#navigator").append(nextStep);   
      $("#navigator").append(lastStep);
 	}    


   function fn_write(){
      location.href="<%=path %>/board/form";
   }

   function goDetail(seq){
	   location.href="<%=path %>/board/read?seq="+seq+"&page="+boardObj.page+"&type="+boardObj.type+"&keyword="+boardObj.keyword;
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
      width: 400px;
      
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
               <input type="text" id="S_KEYWORD" value="" onKeydown="javascript:if(event.keyCode == 13) drawPage(1);" autofocus="autofocus">
            </td>
            <td>
               <input type="button" value='검색' onclick="drawPage(1)">
            </td>
            <td>
               <input type="button" value='글쓰기' onclick="fn_write()">      
            </td>
         </tr>
      </table>
      <table id="listview">
         	<!-- 게시글 영역 -->
      </table>
               
       <div id="navigator" class="centered">
            <!-- 페이징 영역 -->
      </div>  
      
      
      </div>   
      
      
    </div>
  </div>
</div> 


</body>
</html>