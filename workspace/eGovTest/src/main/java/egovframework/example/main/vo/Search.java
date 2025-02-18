package egovframework.example.main.vo;

/**
 * 검색 기능을 위한 클래스
 * Pagination 클래스를 상속받아 페이징 기능과 함께 사용
 */
public class Search extends Pagination {
	
	// 검색 유형 (예: 제목, 내용, 작성자 등)
	private String searchType;
	// 검색어
	private String keyword;
	
	// 검색 유형을 반환
	public String getSearchType() {
		return searchType;
	}
	
	// 검색 유형을 설정
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	
	// 검색어 반환
	public String getKeyword() {
		return keyword;
	}
	
	// 검색어를 설정
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	
}
