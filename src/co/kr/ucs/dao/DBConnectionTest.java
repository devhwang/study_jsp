package co.kr.ucs.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLTimeoutException;
import java.text.MessageFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ArrayBlockingQueue;

/**
 * 다중접속 단위 테스트용 클래스
 * @author Kiha
 *
 */

public class DBConnectionTest {

	ArrayBlockingQueue<ThreadT> abq = new ArrayBlockingQueue<DBConnectionTest.ThreadT>(1000);

	DBConnectionPoolManager dbPoolManager = DBConnectionPoolManager.getInstance();
	DBConnectionPool dbPool;
	
	public DBConnectionTest() throws Exception {

		dbPoolManager.setDBPool(DBManager.getUrl(), DBManager.getId(), DBManager.getPw());
		dbPool = dbPoolManager.getDBPool();
		
		for(int i = 0; i < 1000; i++) {
			try{
				abq.offer(new ThreadT(dbPool));
				go();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}

		
	}
	
	public void go() throws Exception {	
		abq.poll().start();		
	}
	
	public static void main(String[] args) {
		try {
			new DBConnectionTest();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	class ThreadT extends Thread{	
		DBConnectionPool dbPool;
		
		public ThreadT(DBConnectionPool cp) {
			this.dbPool = cp;
		}
		
		public void run() {
			Connection conn = null;
			try { 
				conn = dbPool.getConnection();
			} catch(Exception e) {
				e.printStackTrace();
			}
			
			if(conn == null) System.out.println("커넥션 NULL");
			
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try{
				pstmt = conn.prepareStatement("SELECT 'CONNECTED' K FROM DUAL");
				rs = pstmt.executeQuery();
				rs.next();
				
				System.out.println(MessageFormat.format("{0} : 결과 {1}", new Object[]{conn.toString(), rs.getString("K")}));
			} catch (Exception e){
				e.printStackTrace();
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			}finally{
				if (rs != null)
					try {
						rs.close();
					} catch (SQLException e) {}
		        if (pstmt != null)
					try {
						pstmt.close();
					} catch (SQLException e) {}
		        dbPool.freeConnection(conn);
			}	
		}
	}
	
}
