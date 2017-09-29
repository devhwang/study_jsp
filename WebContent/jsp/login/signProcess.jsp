<%@page import="javax.xml.ws.Response"%>
<%@page import="java.io.*, java.sql.*, java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%!
	@SuppressWarnings({"rawtypes", "unchecked"})
	public boolean doLogin(Map loginInfo, Map userInfo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@220.76.203.39:1521:UCS", "UCS_STUDY", "qazxsw");
			
			pstmt = conn.prepareStatement("SELECT USER_ID, USER_PW, USER_NM, EMAIL FROM CM_USER WHERE USER_ID = ? AND USER_PW = ?");
			pstmt.setString(1, (String) loginInfo.get("USER_ID"));
			pstmt.setString(2, (String) loginInfo.get("USER_PW"));

			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				userInfo.put("USER_ID", rs.getString("USER_ID"));
				userInfo.put("USER_NM", rs.getString("USER_NM"));
				userInfo.put("EMAIL", rs.getString("EMAIL"));
				return true;
			}
			return false;
			
		} catch (Exception e){
			e.printStackTrace();
			return false;
		}finally{
			if (rs != null) try { rs.close(); } catch(SQLException ex) {ex.getStackTrace();}
	        if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {ex.getStackTrace();}
	        if (conn != null) try { conn.close(); } catch(SQLException ex) {ex.getStackTrace();}
		}			
	}
	
	/**
	 * @param applyInfo
	 * @return isSuccess : 성공여부, msg : 반환메세지
	 * @throws Exception 
	 */
	public boolean createAccount(Map applyInfo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@220.76.203.39:1521:UCS", "UCS_STUDY", "qazxsw");
			
			pstmt = conn.prepareStatement("SELECT USER_ID, USER_PW, USER_NM, EMAIL FROM CM_USER WHERE USER_ID = ?");
			pstmt.setString(1, (String) applyInfo.get("USER_ID"));

			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return false;
			}
			
			pstmt = conn.prepareStatement("INSERT INTO CM_USER(USER_ID,USER_PW,USER_NM,EMAIL) VALUES (?,?,?,?)");
			pstmt.setString(1, (String) applyInfo.get("USER_ID"));
			pstmt.setString(2, (String) applyInfo.get("USER_PW"));
			pstmt.setString(3, (String) applyInfo.get("USER_NM"));
			pstmt.setString(4, (String) applyInfo.get("EMAIL"));
			
			pstmt.executeUpdate();
			
			return true;
		} catch (Exception e){
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			throw e;
		}finally{
			if (rs != null) try { rs.close(); } catch(SQLException ex) {ex.getStackTrace();}
	        if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {ex.getStackTrace();}
	        if (conn != null) try { conn.close(); } catch(SQLException ex) {ex.getStackTrace();}
		}	
	}
%>
<%!
	//jsp 메시지 출력용 메소드
	public String pushMsg(String msg, String location){
		StringBuffer sb = new StringBuffer();
		
		sb.append("<script>");//--script 영역시작
		
		sb.append("alert('"+msg+"');");//출력할 메시지 설정
		if("back".equals(location)){//경로가 back이면 
			sb.append("history.back(-1);");//뒤로보낸다
		}else{
			sb.append("location.href='"+location+"';");//아니면 경로로 이동
		}
		
		sb.append("</script>");//--script 영역종료
		
		return sb.toString();
	}
%>
<%
	PrintWriter pw = response.getWriter();
	String process = request.getParameter("PROCESS");
	
	if("signin".equals(process)){
		Map loginInfo = new HashMap();
		loginInfo.put("USER_ID", request.getParameter("USER_ID"));
		loginInfo.put("USER_PW", request.getParameter("USER_PW"));
		
		Map userInfo = new HashMap();
		if(!doLogin(loginInfo, userInfo)) {
			// 로그인 실패
			pw.println(pushMsg("아이디 또는 비밀번호가 일치하지 않습니다","back"));
		} else {
			for(Object key : userInfo.keySet()) {
				session.setAttribute((String)key, userInfo.get(key));
			}
			// 로그인 성공 페이지 이동
			pw.println(pushMsg(session.getAttribute("USER_NM")+"님 환영합니다!","../board/boardList.jsp"));
		}
	} else if("signup".equals(process)){
		Map applyInfo = new HashMap();
		applyInfo.put("USER_ID", request.getParameter("USER_ID"));
		applyInfo.put("USER_PW", request.getParameter("USER_PW"));
		applyInfo.put("USER_NM", request.getParameter("USER_NM"));
		applyInfo.put("EMAIL", request.getParameter("EMAIL"));
	
		if(!createAccount(applyInfo)) {
			//중복계정시 back
			pw.println(pushMsg("이미 존재하는 계정입니다","back"));
		} else {
			//가업성공시 페이지 이동
			pw.println(pushMsg("가입에 성공하였습니다","signIn.jsp"));
		}
	}
 %>