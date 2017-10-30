package co.kr.ucs.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import co.kr.ucs.dao.DBConnectionPool;
import co.kr.ucs.dao.DBConnectionPoolManager;
import co.kr.ucs.dao.DBManager;

@SuppressWarnings({"rawtypes", "unchecked"})
public class BoardService {

	DBConnectionPoolManager dbPoolManager = DBConnectionPoolManager.getInstance();
	DBConnectionPool dbPool;

	public BoardService() {
		dbPoolManager.setDBPool(DBManager.getUrl(), DBManager.getId(), DBManager.getPw());
		dbPool = dbPoolManager.getDBPool();
	}
	
	public ArrayList getlist(Map searchInfo) throws Exception{
		Connection conn = dbPool.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
			
		//--페이징처리 관련 변수
		final int BLOCKSIZE = 10, ROWSIZE = 10; //group당 몇개의 page를 표현할 것인가//page당 몇개의 row를 표현할 것인가
		int totcnt = 0;//resultSet 순회시 대입됨
		
		int nowBlock = Integer.parseInt((String)searchInfo.get("block")==null?"1":(String)searchInfo.get("block")); //네비게이터; 현재 어떤 그룹을 보고있는가
		int nowPage = Integer.parseInt((String)searchInfo.get("page")==null?"1":(String)searchInfo.get("page")); //네비게이터; 현재 어떤 페이지를 보고있는가
		 		
		int minRowNum = ROWSIZE * (nowPage-1);//페이지 네비게이터 최소페이지
		int maxRowNum = ROWSIZE * (nowPage);//페이지 네비게이터 최대 페이지

		String type = "";
		String keyword = "";
		
		ArrayList<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
				
		try{	
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@220.76.203.39:1521:UCS", "UCS_STUDY", "qazxsw");
			
			type = (String) searchInfo.get("type");
			keyword = (String) searchInfo.get("keyword");
			
			String searchCondition = "";
			
			if((type != null || "".equals(type)) && (keyword != null || "".equals(keyword))){
				if("title".equals(type)){
					searchCondition = " AND A.TITLE LIKE '%"+keyword+"%'";
				}else if("name".equals(type)){
					searchCondition = " AND B.USER_NM LIKE '%"+keyword+"%'";
				}
			}else{
				type = "";
				keyword = "";
			}
			
			String query = 		
			  "SELECT *"
			+" FROM" 
					+"( SELECT C.*, ROWNUM AS RNUM, COUNT(*) OVER() AS TOTCNT"
					 +" FROM "
					  	 +"( SELECT A.SEQ, A.TITLE, A.CONTENTS, A.REG_ID, TO_CHAR(A.REG_DATE,'yyyy-mm-dd') REG_DATE, A.MOD_DATE, B.USER_NM AS REG_NM"
						  +" FROM BOARD A, CM_USER B"
						  +" WHERE A.REG_ID = B.USER_ID"
						  +  searchCondition
						  +" ORDER BY SEQ DESC)C)"
			+" WHERE RNUM > ? AND RNUM <=?";

			System.out.println(query);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, minRowNum);
			pstmt.setInt(2, maxRowNum);
			
			System.out.println(minRowNum +"~"+maxRowNum);
			rs = pstmt.executeQuery();
			Map brdInfo;
			while(rs.next()){
				//System.out.println("==="+rs.getRow() +"===");
				if(rs.isFirst()){
					totcnt = rs.getInt("TOTCNT");
				}
				brdInfo = new HashMap();
				
				brdInfo.put("SEQ",rs.getString("SEQ"));// System.out.print(brdInfo.get("SEQ"));
				brdInfo.put("TITLE",rs.getString("TITLE"));//System.out.print(brdInfo.get("TITLE"));
 				brdInfo.put("CONTENTS",rs.getString("CONTENTS"));//System.out.print(brdInfo.get("CONTENTS"));
				brdInfo.put("REG_ID",rs.getString("REG_ID"));//System.out.print(brdInfo.get("REG_ID"));
				brdInfo.put("REG_NM",rs.getString("REG_NM"));//System.out.print(brdInfo.get("REG_NM"));
				brdInfo.put("REG_DATE",rs.getString("REG_DATE"));//System.out.print(brdInfo.get("REG_DATE"));
				brdInfo.put("MOD_DATE",rs.getString("MOD_DATE"));//System.out.println(brdInfo.get("MOD_DATE"));
				
				list.add((HashMap<String, String>) brdInfo);
				//System.out.println(list);
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
/*			DBManager.close(rs);
			DBManager.close(pstmt);
			DBManager.close(conn);
			
*/		
			dbPool.freeConnection(conn);
			DBManager.close(null, pstmt);
		}
		
		searchInfo.put("BLOCKSIZE",Integer.toString(BLOCKSIZE));
		searchInfo.put("ROWSIZE",Integer.toString(ROWSIZE));
		searchInfo.put("nowPage",Integer.toString(nowPage));
		searchInfo.put("nowBlock",Integer.toString(nowBlock));
		searchInfo.put("totcnt",Integer.toString(totcnt));
		searchInfo.put("type",type);
		searchInfo.put("keyword",keyword);
		
		return list;		
	}
	
	
	@SuppressWarnings({"rawtypes", "unchecked"})
	public boolean doWrite(Map brdInfo) throws Exception {
		//Connection conn = DBManager.getConnection();
		Connection conn = dbPool.getConnection(); 
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
			/*DBManager.close(rs);
			DBManager.close(pstmt);
			DBManager.close(conn);*/
			dbPool.freeConnection(conn);
			DBManager.close(null, pstmt);
		}	
	}
}
