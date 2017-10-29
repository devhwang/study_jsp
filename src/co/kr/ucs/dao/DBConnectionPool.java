package co.kr.ucs.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.SQLTimeoutException;

public class DBConnectionPool {

	private int initConns, maxConns;
	private long timeOut = 1000 * 30;
	
	private String url, id, pw;
	
	private int[] connStatus;
	private Connection[] connPool;
	
	public DBConnectionPool(String url, String id, String pw, int initConns, int maxConns){
		this.url = url;
		this.id  = id;
		this.pw  = pw;
		
		this.initConns = initConns;
		this.maxConns  = maxConns;
		
		this.connStatus = new int[maxConns];//1 사용가능 2사용중
		this.connPool   = new Connection[maxConns];
		System.out.println(this.connPool);
		
		for(int i=0; i<this.initConns; i++) {//initConns만큼 커넥션 객체생성
			try {
				this.createConnection(i);
			} catch (ClassNotFoundException | SQLException e) {
				e.printStackTrace();
				return;
			}
		}
	}
	
	//커넥션 객체생성
	private Connection createConnection(int pos) throws ClassNotFoundException, SQLException{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection conn=DriverManager.getConnection(url,id,pw);
		
		this.connPool[pos] = conn;
		this.connStatus[pos] = 1;//1로 초기화
		
		return this.connPool[pos];
	}

	public synchronized Connection getConnection() throws SQLTimeoutException, InterruptedException{
		
		long currTime = System.currentTimeMillis();
		while((System.currentTimeMillis() - currTime) <= this.timeOut) {//대기가 30*1000 밀리초(30초) 이상되면 timeout으로 exception을 발생시킴
			for(int i=0; i<this.maxConns; i++) {
				if(this.connStatus[i] == 1) {//사용가능이면
					this.connStatus[i] = 2;//사용중으로바꾸고
					return this.connPool[i];//해당 인덱스번쨰의 커넥션 객체를 반환
				}else if(this.connStatus[i] == 0) {//0이라면
					try {
						this.connStatus[i] = 2;
						return createConnection(i);//신규 커넥션 생성시도
						
					} catch (ClassNotFoundException | SQLException e) {
						e.printStackTrace();
						System.out.println("새로운 Connection 생성 실패");
					}
				}
			}			
			
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		
		throw new SQLTimeoutException("모든 Connection이 사용중입니다.");
	}
	
	public void freeConnection(Connection conn){
		if(conn != null) {
			for(int i=0; i<this.maxConns; i++) {
				if(this.connPool[i] == conn) {		
					
					/*or(int j = 0 ; j < connPool.length; j++) {
						System.out.print("["+j+": ");
						System.out.print(this.connPool[j] + ": "+this.connStatus[j]);
						System.out.println("]");
					}*/

					this.connStatus[i] = 1;
					System.out.println(i+"번쨰 커넥션 반환됨");
					
					break;
				}
			}
		}
	}
	
	public long getTimeOut(){
		return timeOut;
		
	}
	
	public void setTimeOut(long timeOut){
		this.timeOut = timeOut;
	}

}
