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
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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

		//요청분석
		String[] uri = request.getRequestURI().split("/");
		String process = uri[uri.length-1];
		
		String path = request.getContextPath();
		String msg = "";//사용자에게 출력할 메시지
		Boolean isSuccess = false; //성공여부
		String param = request.getParameter("param");//파라미터(json형식)		
		JSONObject jsonObj =null;
		
		//게시판 정보
		Map brdInfo = new HashMap();
		//검색정보
		Map searchInfo = new HashMap();
		
		if(param != null){
			JSONParser parser = new JSONParser();
			jsonObj = (JSONObject)parser.parse(param);
		}
		
		
		// 기능수행
		if(process.equals("main")) {//리스트조회
			
			/*searchInfo.put("block", jsonObj.get("block").toString());
			searchInfo.put("page", jsonObj.get("page").toString());
			searchInfo.put("type", jsonObj.get("type").toString());
			searchInfo.put("keyword", jsonObj.get("keyword").toString());
			*///널체크후 다시사용하기전 페이징안됨.
			request.setAttribute("list", board.getlist(searchInfo));
			request.setAttribute("searchInfo", searchInfo);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/board/boardList.jsp");
			dispatcher.forward(request, response);		
			
		}else if(process.equals("form")) {//글 작성폼
			RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/board/boardWrite.jsp");
			dispatcher.forward(request, response);	
			
		}else if(process.equals("read")) {//글 읽기
			RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/board/boardRead.jsp");
			dispatcher.forward(request, response);	
			
		}else if(process.equals("write")) {//글 쓰기
			brdInfo.put("TITLE", jsonObj.get("TITLE").toString());
			brdInfo.put("CONTENTS", jsonObj.get("CONTENTS").toString());
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
		
		JSONObject result = new JSONObject();		
		if(isSuccess == false) {
			result.put("error", msg);
		}else {
			result.put("success", msg);
		}
		
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(result.toJSONString());
		
						
	}
	
}
