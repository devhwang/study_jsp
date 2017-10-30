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
 * 다중접속 환경 단위 테스트용 클래스
 * @author Kiha
 *
 */

public class DBConnectionTest {

	ArrayBlockingQueue<ThreadA> queue = new ArrayBlockingQueue<DBConnectionTest.ThreadA>(1000);

	DBConnectionPoolManager dbPoolManager = DBConnectionPoolManager.getInstance();
	DBConnectionPool dbPool;
	
	public DBConnectionTest() throws Exception {

		//dbPoolManager.setDBPool(DBManager.getUrl(), DBManager.getId(), DBManager.getPw());//PoolName 미지정
		dbPoolManager.setDBPool("poolNameTest",DBManager.getUrl(), DBManager.getId(), DBManager.getPw(),1,20);
		dbPool = dbPoolManager.getDBPool("poolNameTest");
		
		for(int i = 0; i < 1000; i++) {
			try{
				queue.offer(new ThreadA(dbPool));
				go();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		
	}
	
	public void go() throws Exception {	
		queue.poll().start();		
	}
	
	public static void main(String[] args) {
		try {
			new DBConnectionTest();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	class ThreadA extends Thread{	
		DBConnectionPool dbPool;
		
		public ThreadA(DBConnectionPool cp) {
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
				
				//System.out.println(MessageFormat.format("{0} : 결과 {1}", new Object[]{conn.toString(), rs.getString("K")}));
			} catch (Exception e){
				e.printStackTrace();				
			}finally{
		        dbPool.freeConnection(conn);
		        DBManager.close(rs, pstmt);
			}	
		}
	}
	
}
