package co.kr.ucs.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

import co.kr.ucs.dao.DBManager;

@SuppressWarnings({"rawtypes", "unchecked"})
public class BoardService {
	/**
	 * @param loginInfo
	 * @return isSuccess : 성공여부, msg : 반환메세지
	 * @throws Exception 
	 */
	@SuppressWarnings({"rawtypes", "unchecked"})
	public boolean doWrite(Map brdInfo) throws Exception {
		Connection conn = DBManager.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{	
			pstmt = conn.prepareStatement("INSERT INTO BOARD (SEQ,TITLE,CONTENTS,REG_ID,REG_DATE,MOD_DATE) VALUES ((SELECT MAX(SEQ)+1 FROM BOARD),?,?,?,SYSDATE,SYSDATE)");
			pstmt.setString(1, (String) brdInfo.get("TITLE"));
			pstmt.setString(2, (String) brdInfo.get("CONTENTS"));
			pstmt.setString(3, (String) brdInfo.get("REG_ID"));
			
			if(pstmt.executeUpdate()>0){
				return true;	
			}else{
				return false;
			}
			
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
