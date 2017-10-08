package co.kr.ucs.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
import co.kr.ucs.dao.DBManager;

@SuppressWarnings({"rawtypes", "unchecked"})
public class SignService {
	/**
	 * @param loginInfo
	 * @return isSuccess : 성공여부, msg : 반환메세지
	 * @throws Exception 
	 */
	
	@SuppressWarnings({"rawtypes", "unchecked"})
	public boolean doLogin(Map loginInfo, Map userInfo) throws Exception {
		
		Connection conn = DBManager.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
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
			DBManager.close(rs);
			DBManager.close(pstmt);
			DBManager.close(conn);
		}			
	}
	
	/**
	 * @param applyInfo
	 * @return isSuccess : 성공여부, msg : 반환메세지
	 * @throws Exception 
	 */
	public boolean createAccount(Map applyInfo) throws Exception {
		Connection conn = DBManager.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
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
			DBManager.close(rs);
			DBManager.close(pstmt);
			DBManager.close(conn);
		}	
	}
}
