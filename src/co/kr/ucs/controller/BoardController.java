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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import co.kr.ucs.service.BoardService;

@WebServlet(urlPatterns = {"/board/*"}, loadOnStartup = 1)
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
		String view = "";//이동시킬 URL	
		
		//게시판 정보
		Map brdInfo = new HashMap();
		brdInfo.put("TITLE", request.getParameter("TITLE"));
		brdInfo.put("CONTENTS", request.getParameter("CONTENTS"));
		brdInfo.put("REG_ID", request.getSession().getAttribute("USER_ID"));
		
		//검색정보
		Map searchInfo = new HashMap();
		searchInfo.put("block", request.getParameter("block"));
		searchInfo.put("page", request.getParameter("page"));
		searchInfo.put("type", request.getParameter("type"));
		searchInfo.put("keyword", request.getParameter("keyword"));
		
		// 기능수행
		if(process.equals("main")) {//리스트조회
			request.setAttribute("list", board.getlist(searchInfo));
			request.setAttribute("searchInfo", searchInfo);
			view = "/jsp/board/boardList.jsp";	
		}else if(process.equals("form")) {//글 작성폼
			view = "/jsp/board/boardWrite.jsp";
		}else if(process.equals("read")) {//글 읽기
			view = "/jsp/board/boardRead.jsp";
		}else if(process.equals("write")) {//글 쓰기
			if(board.doWrite(brdInfo)){
				msg = "성공적으로 글을 등록했습니다";
				view = "/board/main";
			}else{
				msg = "등록에 실패하였습니다. 다시 시도해주세요";
			}
		}else{
			msg ="잘못된 접근입니다.";
			view = "/board/main";
		}
		
		//페이지이동
		//--메시지가 존재하는 경우 해당 메시지를 출력 후 페이지 이동
		if(msg.equals("")) {			
			RequestDispatcher dispatcher = request.getRequestDispatcher(view);
			dispatcher.forward(request, response);			
		}else {			
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('"+msg+"')");
			if("".equals(view)) { 
				pw.println("history.back(-1)");
			}else {
				pw.println("location.href='"+path+view+"'");
			}
			pw.println("</script>");
		}
						
	}
	
}
