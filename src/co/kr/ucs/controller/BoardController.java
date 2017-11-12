package co.kr.ucs.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import co.kr.ucs.service.BoardService;

//@WebServlet(urlPatterns = {"/board/*"}, loadOnStartup = 1)
public class BoardController extends HttpServlet{

   private static final long serialVersionUID = 1L;

   private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
   
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      try {
         processRequest(request, response);
      } catch (Throwable e) {
         // TODO Auto-generated catch block
         e.printStackTrace();
      }
   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      try {
         processRequest(request, response);
      } catch (Throwable e) {
         // TODO Auto-generated catch block
         e.printStackTrace();
      }
   }
   
   private void processRequest(HttpServletRequest request, HttpServletResponse response) throws Throwable {
      response.setContentType("text/html; charset=UTF-8");
      response.setCharacterEncoding("UTF-8");
      BoardService board = new BoardService();
      Map result = new HashMap();   //반환할 결과

      //요청분석
      String[] uri = request.getRequestURI().split("/");//e.g)  */board/write/ ==> [*][board][write]
      String process = uri[uri.length-1];//e.g) process = write;
      
      String path = request.getContextPath();
      String msg = "";//사용자에게 출력할 메시지
      Boolean isSuccess = false; //성공여부
      Map searchInfo = new HashMap();//페이징 정보
      Map brdInfo = new HashMap();//게시물 정보

      String param = request.getParameter("param");//json 파라미터 분석      
      JsonElement jsonObj =null;
      
      if(param != null){
         JsonParser parser = new JsonParser();
         jsonObj = (JsonElement)parser.parse(param);
      }
       
      // 기능수행
      if(process.equals("main")) {//리스트조회
         
         //단순 페이지 이동만
         RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/board/boardList.jsp");
         dispatcher.forward(request, response);      
         
      }else if(process.equals("list")){
         searchInfo.put("blockSize", jsonObj.getAsJsonObject().get("blockSize").getAsString());
         searchInfo.put("rowSize", jsonObj.getAsJsonObject().get("rowSize").getAsString());
         searchInfo.put("page", jsonObj.getAsJsonObject().get("page").getAsString());
         searchInfo.put("type", jsonObj.getAsJsonObject().get("type").getAsString());
         searchInfo.put("keyword", jsonObj.getAsJsonObject().get("keyword").getAsString());
         
         result.put("list", board.getlist(searchInfo));
         result.put("searchInfo", searchInfo);
         
      
      }else if(process.equals("form")) {//글 작성폼으로 이동
         RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/board/boardWrite.jsp");
         dispatcher.forward(request, response);   
         
      }else if(process.equals("read")) {//글 상세로 이동
         RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/board/boardRead.jsp");
         dispatcher.forward(request, response);   
         
      }else if(process.equals("detail")) {//글 상세로 이동
    	  String seq = jsonObj.getAsJsonObject().get("seq").getAsString();
    	  String page = jsonObj.getAsJsonObject().get("page").getAsString();
    	  
		  brdInfo.put("seq", seq);
		  brdInfo.put("page", page);
	      result.put("brdInfo", board.getDetailView(seq));
          
       }else if(process.equals("write")) {//글 쓰기로 이동
         brdInfo.put("TITLE", jsonObj.getAsJsonObject().get("TITLE").getAsString());
         brdInfo.put("CONTENTS", jsonObj.getAsJsonObject().get("CONTENTS").getAsString());
         brdInfo.put("REG_ID", request.getSession().getAttribute("USER_ID"));
         
         if(board.doWrite(brdInfo)){
            msg = "성공적으로 글을 등록했습니다";
            isSuccess = true;
         }else{
            msg = "등록에 실패하였습니다. 다시 시도해주세요";
         }
         
      }else{
         msg ="잘못된 접근입니다.";      
      }
      
      if(isSuccess == false) {
         result.put("error", msg);
      }else {
         result.put("success", msg);
      }
      Gson gson = new Gson();
      response.setContentType("text/html;charset=UTF-8");
      response.getWriter().write(gson.toJson(result));
      
                  
   }
   
}