package co.kr.ucs.dao;

import java.util.HashMap;
import java.util.Map;

public class DBConnectionPoolManager {
	final static String DEFAULT_POOLNAME = "DEFAULT";
	final static Map<String, DBConnectionPool> dbPool = new HashMap<>();
	final static DBConnectionPoolManager instance = new DBConnectionPoolManager();
	
	//DB Pool 생성
	//DBConnctionPoolManager 반환

	public static DBConnectionPoolManager getInstance(){
		return instance;
	}
	
	public void setDBPool(String url, String id, String pw) {
		setDBPool(DEFAULT_POOLNAME, url, id, pw, 1, 10);
	}
	
	//DB Pool 생성
	public void setDBPool(String poolName, String url, String id, String pw) {
		setDBPool(poolName, url, id, pw, 1, 10);
	}
	
	//DB Pool 생성
	public void setDBPool(String poolName, String url, String id, String pw, int initConns, int maxConns) {
		if(!dbPool.containsKey(poolName))  {
			DBConnectionPool connPool = new DBConnectionPool(url, id, pw, initConns, maxConns);
			dbPool.put(poolName, connPool);
		}
	}
	//Pool에서 커넥션 획득
	public DBConnectionPool getDBPool(){
		return getDBPool(DEFAULT_POOLNAME);
	};
	
	//Pool에서 커넥션 획득
	DBConnectionPool getDBPool(String poolName){//poolName을 지정해준경우
		return dbPool.get(poolName);
	};
	
	
}
