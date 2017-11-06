package co.kr.ucs.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import co.kr.ucs.dao.DBConnectionPool;
import co.kr.ucs.dao.DBConnectionPoolManager;
import co.kr.ucs.dao.DBManager;

@SuppressWarnings({"rawtypes", "unchecked"})
public class BoardService {

	private static final Logger logger = LoggerFactory.getLogger(BoardService.class);

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
		int totcnt = 0;//resultSet 순회시 대입됨, 질의 결과 총 반환되는 row의 갯수
		
		int nowBlock = Integer.parseInt((String)searchInfo.get("block")==null?"1":(String)searchInfo.get("block")); //네비게이터; 현재 어떤 그룹을 보고있는가
		//null이면 1블럭
		int nowPage = Integer.parseInt((String)searchInfo.get("page")==null?"1":(String)searchInfo.get("page")); //네비게이터; 현재 어떤 페이지를 보고있는가
		//null이면 1페이지
		
		int maxRowNum = ROWSIZE * (nowPage);//페이지 네비게이터 최대 페이지
		int minRowNum = ROWSIZE * (nowPage-1)+1;//페이지 네비게이터 최소페이지
		

		String type = "";//검색 타입
		String keyword = "";//검색 키워드
		
		ArrayList<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
				
		try{	
			
			/*
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
			*/
			/* 기존 쿼리의 문제점
			 * String의 + 연산은 임시 중간 객체를 생성하기 때문에 메모리 소모가 많고 느리다? (+= 일 경우에만...)
			 * COUNT(*) OVER()로 인해 풀 스캔을 수행한다고 한다. -> 따로 TOTCNT를 구하는 쿼리 작동하도록
			 * WHERE RNUM > ? AND RUNM <= 구간이 비효율적이라고 한다. -> 인라인뷰 2개로 활용 
			 */

			type = (String) searchInfo.get("type");
			keyword = (String) searchInfo.get("keyword");
			
			String searchCondition = "";
			
			if((type != null || "".equals(type)) && (keyword != null || "".equals(keyword))){
				if("title".equals(type)){
					searchCondition = " AND B.TITLE LIKE '%"+keyword+"%'";
				}else if("name".equals(type)){
					searchCondition = " AND U.USER_NM LIKE '%"+keyword+"%'";
				}
			}else{
				type = "";
				keyword = "";
			}
			
			StringBuffer query = new StringBuffer();
			
			query.append("	SELECT (SELECT COUNT(*) FROM BOARD) AS TOTCNT, Y.RNUM, Y.SEQ, Y.TITLE, Y.CONTENTS, Y.REG_ID, TO_CHAR(Y.REG_DATE,'yyyy-mm-dd') AS REG_DATE, Y.MOD_ID, Y.MOD_DATE, Y.REG_NM");
			query.append(" 	FROM("); 
			query.append(" 		SELECT ROWNUM AS RNUM, X.SEQ, X.TITLE, X.CONTENTS, X.REG_ID, X.REG_DATE, X.MOD_ID, X.MOD_DATE, REG_NM"); 
			query.append(" 		FROM(");
			query.append(" 				SELECT B.SEQ, B.TITLE, B.CONTENTS, B.REG_ID, B.REG_DATE, B.MOD_ID, B.MOD_DATE, U.USER_NM AS REG_NM");
			query.append(" 				FROM BOARD B, CM_USER U");
			query.append(" 				WHERE B.REG_ID = U.USER_ID");
			query.append(				searchCondition);
			query.append(" 				ORDER BY SEQ DESC)X");
			query.append(" 		WHERE ROWNUM <= ? )Y");
			query.append(" 	WHERE Y.RNUM >=?");
			
			logger.info("query : {}", query);

			pstmt = conn.prepareStatement(query.toString());
			pstmt.setInt(1, maxRowNum);
			pstmt.setInt(2, minRowNum);
						
			rs = pstmt.executeQuery();
			Map brdInfo;
			while(rs.next()){
				if(rs.isFirst()){
					totcnt = rs.getInt("TOTCNT");
				}
				brdInfo = new HashMap();
				
				brdInfo.put("SEQ",rs.getString("SEQ"));
				brdInfo.put("TITLE",rs.getString("TITLE"));
 				brdInfo.put("CONTENTS",rs.getString("CONTENTS"));
				brdInfo.put("REG_ID",rs.getString("REG_ID"));
				brdInfo.put("REG_NM",rs.getString("REG_NM"));
				brdInfo.put("REG_DATE",rs.getString("REG_DATE"));
				brdInfo.put("MOD_DATE",rs.getString("MOD_DATE"));
				
				list.add((HashMap<String, String>) brdInfo);
			}
			
		}catch(Exception e){
			e.printStackTrace();
			logger.error("에러 : {}", e.getMessage());
		}finally{
			logger.info(dbPool.freeConnection(conn));
			DBManager.close(rs, pstmt);
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
	
	public Map getDetailView(String seq) throws Exception {
		Connection conn = dbPool.getConnection(); 
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		HashMap<String, String> brdInfo = new HashMap<String, String>();
		
		try{	

			StringBuffer query = new StringBuffer(); 
			
			query.append(" SELECT A.SEQ, A.TITLE, A.CONTENTS, A.REG_ID, TO_CHAR(A.REG_DATE,'yyyy-mm-dd') REG_DATE, A.MOD_DATE, B.USER_NM AS REG_NM");
			query.append(" FROM BOARD A, CM_USER B");
			query.append(" WHERE A.REG_ID = B.USER_ID");
			query.append(" AND SEQ = ?");

			pstmt = conn.prepareStatement(query.toString());
			pstmt.setString(1, seq);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				brdInfo.put("SEQ",rs.getString("SEQ"));
				brdInfo.put("TITLE",rs.getString("TITLE"));
				brdInfo.put("CONTENTS",rs.getString("CONTENTS"));
				brdInfo.put("REG_ID",rs.getString("REG_ID"));
				brdInfo.put("REG_NM",rs.getString("REG_NM"));
				brdInfo.put("REG_DATE",rs.getString("REG_DATE"));
				brdInfo.put("MOD_DATE",rs.getString("MOD_DATE"));
			}
			
		} catch (Exception e){
				e.printStackTrace();
		}finally{
			dbPool.freeConnection(conn);
			DBManager.close(rs, pstmt);
		}
		return brdInfo;	
	}
	
	public boolean doWrite(Map brdInfo) throws Exception {
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
			//logger.info("DB 연결종료");
			dbPool.freeConnection(conn);
			DBManager.close(rs, pstmt);
		}	
	}
}
