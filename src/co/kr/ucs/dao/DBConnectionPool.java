package co.kr.ucs.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.SQLTimeoutException;

public class DBConnectionPool {

	private int initConns, maxConns;
	private long timeOut = 1000 * 30;// timeout 기본은 30초이고 setTimeOut 메서드를 통해 직접 지정해 줄 수 있다.
	
	private String url, id, pw;
	
	private Boolean[] connStatus;
	private Connection[] connPool;
	
	public DBConnectionPool(String url, String id, String pw, int initConns, int maxConns){
		this.url = url;
		this.id  = id;
		this.pw  = pw;
		
		this.initConns = initConns;
		this.maxConns  = maxConns;
		
		this.connStatus = new Boolean[maxConns];//1 사용가능 2사용중
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
		this.connStatus[pos] = false;//1로 초기화
		
		return this.connPool[pos];
	}

	public synchronized Connection getConnection() throws SQLTimeoutException, InterruptedException{
		
		long currTime = System.currentTimeMillis();
		while((System.currentTimeMillis() - currTime) <= this.timeOut) {//대기가 30*1000 밀리초(30초) 이상되면 timeout으로 exception을 발생시킴
			for(int i=0; i<this.maxConns; i++) {
								
				if(this.connStatus[i] != null && this.connStatus[i] == false) {//사용가능이면
					System.out.println("false일경우 탄다");
					this.connStatus[i] = true;//사용중으로바꾸고
					//System.out.println(i+"번째 커넥션 연결");
					return this.connPool[i];//해당 인덱스번쨰의 커넥션 객체를 반환
				}else if(this.connStatus[i] == null) {//0이라면
					System.out.println("0일경우 탄다");
					try {
						this.connStatus[i] = true;
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
	
	public String freeConnection(Connection conn){
				
		if(conn != null) {
			for(int i=0; i<this.maxConns; i++) {
				if(this.connPool[i] == conn) {		

					this.connStatus[i] = false;
					
					String temp;
					String temp2;
					System.out.print("["+i+"반환후:");
					for(int j = 0 ; j < connPool.length; j++) {
						if(this.connPool[j]==null) {temp2 = "_";} else {temp2= "CONN";}
						if(this.connStatus[j]==null) {temp = "_";} else if(this.connStatus[j]==false) { temp= "false";} else {temp= "true";}
						System.out.print(temp2+":"+temp+",");
					}
					System.out.println("]");
					
					return "연결 종료 성공";
					//break;
				}
			}
		}
		return "연결 종료 실패";
	}
	
	public long getTimeOut(){
		return timeOut;
	}
	
	public void setTimeOut(long timeOut){
		this.timeOut = timeOut;
	}

}
