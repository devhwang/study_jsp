package co.kr.ucs.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBManager {
	
	public static Connection getConnection(){
		Connection conn=null;
		
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@220.76.203.39:1521:UCS", "UCS_STUDY", "qazxsw");
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return conn;
	}
	
	public static void close(Connection conn){
		if(conn!=null){
			try{
				conn.close();
			}catch(SQLException e){
				e.printStackTrace();
			}
		}
	}
	
	public static void close(PreparedStatement pstmt){
		if(pstmt!=null){
			try{
				pstmt.close();
			}catch(SQLException e){
				e.printStackTrace();
			}
		}
	}
	
	public static void close(ResultSet rs){
		if(rs!=null){
			try{
				rs.close();
			}catch(SQLException e){
				e.printStackTrace();
			}
		}
	}
}
