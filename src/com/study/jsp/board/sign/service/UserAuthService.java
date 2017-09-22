package com.study.jsp.board.sign.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

@SuppressWarnings({"rawtypes", "unchecked"})
public class UserAuthService {
	/**
	 * @param loginInfo
	 * @return isSuccess : 성공여부, msg : 반환메세지
	 * @throws Exception 
	 */
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
}
