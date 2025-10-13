<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  /* 페이지 제목 스타일 */
  .page-title {
    background: linear-gradient(135deg, #667eea, #764ba2);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    font-size: 2.5rem;
    font-weight: 700;
    text-align: center;
    margin-bottom: 30px;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
  }

  /* 테이블 스타일 */
  #myitems_table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    margin: 0;
    border-color: #6c757d;
  }

  #myitems_table thead th {
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: white;
    padding: 15px 10px;
    text-align: center;
    font-weight: 600;
    font-size: 14px;
    border: none;
    position: relative;
  }

  #myitems_table thead th:first-child {
    border-top-left-radius: 12px;
  }

  #myitems_table thead th:last-child {
    border-top-right-radius: 12px;
  }

  #myitems_table tbody tr {
    transition: all 0.3s ease;
    background: white;
  }

  #myitems_table tbody tr:hover {
    background: linear-gradient(135deg, #f8f9ff, #ffffff);
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  }

  #myitems_table tbody tr:last-child td:first-child {
    border-bottom-left-radius: 12px;
  }

  #myitems_table tbody tr:last-child td:last-child {
    border-bottom-right-radius: 12px;
  }

  #myitems_table tbody td {
    padding: 15px 10px;
    text-align: center;
    border: none;
    border-bottom: 1px solid #f0f0f0;
    vertical-align: middle;
  }

  #myitems_table tbody tr:last-child td {
    border-bottom: none;
  }

  /* 이미지 스타일 */
  #myitems_table img {
    width: 60px;
    height: 60px;
    object-fit: cover;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
    transition: all 0.3s ease;
  }

  #myitems_table tbody tr:hover img {
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  }

  /* 상품명 링크 스타일 */
  #myitems_table a {
    color: #2c3e50;
    text-decoration: none;
    font-weight: 600;
    transition: color 0.3s ease;
  }

  #myitems_table a:hover {
    color: #667eea;
    text-decoration: none;
  }

  /* 가격 스타일 */
  .price-cell {
    font-weight: 600;
    color: #e74c3c;
    font-size: 1.1rem;
  }

  /* 카테고리 스타일 */
  .category-cell {
    background: #f8f9fa;
    padding: 4px 8px;
    border-radius: 12px;
    display: inline-block;
    font-size: 0.9rem;
    color: #666;
  }

  /* 날짜 스타일 */
  .date-cell {
    font-size: 0.9rem;
    color: #666;
  }

  /* 버튼 컨테이너 */
  .btn-container {
    display: flex;
    gap: 8px;
    justify-content: center;
  }

  /* 버튼 스타일 */
  .btn-edit {
    background: linear-gradient(135deg, #667eea, #764ba2);
    border: none;
    color: white;
    padding: 8px 16px;
    border-radius: 20px;
    font-weight: 600;
    font-size: 12px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 3px 10px rgba(102, 126, 234, 0.3);
    text-decoration: none;
    display: inline-block;
    position: relative;
    overflow: hidden;
  }

  .btn-edit::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
    transition: left 0.5s;
  }

  .btn-edit:hover::before {
    left: 100%;
  }

  .btn-edit:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
    text-decoration: none;
    color: white;
  }

  .btn-delete {
    background: linear-gradient(135deg, #ff6b6b, #ee5a24);
    border: none;
    color: white;
    padding: 8px 16px;
    border-radius: 20px;
    font-weight: 600;
    font-size: 12px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 3px 10px rgba(255, 107, 107, 0.3);
    text-decoration: none;
    display: inline-block;
    position: relative;
    overflow: hidden;
  }

  .btn-delete::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
    transition: left 0.5s;
  }

  .btn-delete:hover::before {
    left: 100%;
  }

  .btn-delete:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(255, 107, 107, 0.4);
    text-decoration: none;
    color: white;
  }

  /* 빈 상태 메시지 */
  .empty-message {
    text-align: center;
    padding: 60px 20px;
    color: #666;
    font-size: 1.2rem;
    background: white;
    border-radius: 15px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
    margin: 20px 0;
  }

  .empty-message i {
    font-size: 3rem;
    color: #ccc;
    margin-bottom: 20px;
    display: block;
  }

  /* 페이지네이션 스타일 */
  .pagination {
    justify-content: center;
    margin-top: 30px;
    display: flex;
    padding-left: 0;
    list-style: none;
    border-radius: 0.25rem;
  }

  .page-item .page-link {
    color: #667eea;
    border: 1px solid #dee2e6;
    margin: 0 2px;
    border-radius: 4px;
    transition: all 0.3s ease;
    position: relative;
    display: block;
    padding: 0.5rem 0.75rem;
    margin-left: -1px;
    line-height: 1.25;
    background-color: #fff;
  }

  .page-item.active .page-link {
    z-index: 1;
    color: #fff;
    background: linear-gradient(135deg, #667eea, #764ba2);
    border-color: #667eea;
  }

  .page-item .page-link:hover {
    background-color: #f8f9fa;
    color: #764ba2;
    text-decoration: none;
  }

  .page-item.disabled .page-link {
    color: #6c757d;
    pointer-events: none;
    background-color: #fff;
    border-color: #dee2e6;
  }

  /* 반응형 디자인 */
  @media (max-width: 768px) {
    #myitems_table {
      min-width: 600px;
    }

    .btn-container {
      flex-direction: column;
      gap: 5px;
    }

    .btn-edit, .btn-delete {
      width: 100%;
      font-size: 11px;
      padding: 6px 12px;
    }
  }
</style>

<div class="col-sm-10">
  <h1 class="page-title">내 상품 관리</h1>

  <table id="myitems_table">
    <thead>
    <tr>
      <th>이미지</th>
      <th>상품명</th>
      <th>가격</th>
      <th>카테고리</th>
      <th>등록일</th>
      <th>관리</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
      <c:when test="${empty plist}">
        <tr>
          <td colspan="6" class="empty-message">
            등록한 상품이 없습니다
          </td>
        </tr>
      </c:when>
      <c:otherwise>
        <c:forEach var="p" items="${plist}">
          <tr>
            <td>
              <c:if test="${p.productImg != null and not empty p.productImg}">
                <img src="<c:url value='/imgs/${p.productImg}'/>" alt="${p.productName}">
              </c:if>
            </td>
            <td>
              <a href="<c:url value="/market/detail?id=${p.productId}"/>">${p.productName}</a>
            </td>
            <td class="price-cell">
              <fmt:formatNumber type="number" pattern="###,###원" value="${p.productPrice}" />
            </td>
            <td>
              <span class="category-cell">${p.cateName}</span>
            </td>
            <td class="date-cell">
              <fmt:parseDate value="${p.productRegdate}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDateTime" type="both" />
              <fmt:formatDate pattern="yyyy-MM-dd" value="${parsedDateTime}" />
            </td>
            <td>
              <div class="btn-container">
                <a href="<c:url value='/market/edit?id=${p.productId}'/>" class="btn-edit">수정</a>
                <a href="<c:url value='/market/delete?id=${p.productId}'/>" class="btn-delete delete-btn">삭제</a>
              </div>
            </td>
          </tr>
        </c:forEach>
      </c:otherwise>
    </c:choose>
    </tbody>
  </table>

  <!-- 페이지네이션 -->
  <div class="text-center">
    <ul class="pagination">
      <c:if test="${pageMaker.hasPreviousPage}">
        <li class="page-item">
          <a class="page-link" href="<c:url value='/market/myitems?page=${pageMaker.prePage}'/>">이전</a>
        </li>
      </c:if>
      <c:forEach items="${pageMaker.navigatepageNums}" var="pageNum">
        <li class="page-item ${pageMaker.pageNum == pageNum ? 'active' : ''}">
          <a class="page-link" href="<c:url value='/market/myitems?page=${pageNum}'/>">${pageNum}</a>
        </li>
      </c:forEach>
      <c:if test="${pageMaker.hasNextPage}">
        <li class="page-item">
          <a class="page-link" href="<c:url value='/market/myitems?page=${pageMaker.nextPage}'/>">다음</a>
        </li>
      </c:if>
    </ul>
  </div>

</div>
<script>
  $(function(){
    $('.delete-btn').click(function(){
      return confirm("정말로 삭제하시겠습니까?");
    });
  });
</script>
