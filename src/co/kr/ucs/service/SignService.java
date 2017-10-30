package co.kr.ucs.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

import co.kr.ucs.dao.DBConnectionPool;
import co.kr.ucs.dao.DBConnectionPoolManager;
import co.kr.ucs.dao.DBManager;

public class SignService {
	
	DBConnectionPoolManager dbPoolManager = DBConnectionPoolManager.getInstance();
	DBConnectionPool dbPool;
	
	public SignService() {
		dbPoolManager.setDBPool(DBManager.getUrl(), DBManager.getId(), DBManager.getPw());
		dbPool = dbPoolManager.getDBPool();
	}
	
	public boolean doLogin(Map userInfo) throws Exception {
		
		//Connection conn = DBManager.getConnection();
		Connection conn = dbPool.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			pstmt = conn.prepareStatement("SELECT USER_ID, USER_NM, EMAIL FROM CM_USER WHERE USER_ID = ? AND USER_PW = ?");
			pstmt.setString(1, (String) userInfo.get("USER_ID"));
			pstmt.setString(2, (String) userInfo.get("USER_PW"));

			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				userInfo.put("USER_NM", rs.getString("USER_NM"));
				userInfo.put("EMAIL", rs.getString("EMAIL"));
				return true;
			}
			return false;
			
		} catch (Exception e){
			e.printStackTrace();
			return false;		
		}finally{
			/*DBManager.close(rs);
			DBManager.close(pstmt);
			DBManager.close(conn);*/
			dbPool.freeConnection(conn);
			DBManager.close(null, pstmt);
		}	
	}
	
	public boolean createAccount(Map userInfo) throws Exception {
		//Connection conn = DBManager.getConnection();
		Connection conn = dbPool.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			pstmt = conn.prepareStatement("SELECT USER_ID, USER_PW, USER_NM, EMAIL FROM CM_USER WHERE USER_ID = ?");
			pstmt.setString(1, (String) userInfo.get("USER_ID"));

			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return false;
			}
			
			pstmt = conn.prepareStatement("INSERT INTO CM_USER(USER_ID,USER_PW,USER_NM,EMAIL) VALUES (?,?,?,?)");
			pstmt.setString(1, (String) userInfo.get("USER_ID"));
			pstmt.setString(2, (String) userInfo.get("USER_PW"));
			pstmt.setString(3, (String) userInfo.get("USER_NM"));
			pstmt.setString(4, (String) userInfo.get("EMAIL"));
			
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
			/*DBManager.close(rs);
			DBManager.close(pstmt);
			DBManager.close(conn);*/
			dbPool.freeConnection(conn);
			DBManager.close(null, pstmt);
		}	
	}
}
