<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  #myitems_table img {
    width: 60px;
    height: 60px;
    object-fit: cover;
  }
</style>

<div class="col-sm-10">
  <h2>내 상품 관리</h2>
  <table id="myitems_table" class="table table-hover">
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
          <td colspan="6" class="text-center">등록한 상품이 없습니다.</td>
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
            <td><a href="<c:url value="/market/detail?id=${p.productId}"/>">${p.productName}</a></td>
            <td><fmt:formatNumber type="number" pattern="###,###원" value="${p.productPrice}" /></td>
            <td>${p.cateName}</td>
            <td>
              <fmt:parseDate value="${p.productRegdate}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDateTime" type="both" />
              <fmt:formatDate pattern="yyyy-MM-dd" value="${parsedDateTime}" />
            </td>
            <td>
              <a href="<c:url value='/market/edit?id=${p.productId}'/>" class="btn btn-sm btn-info">수정</a>
              <a href="<c:url value='/market/delete?id=${p.productId}'/>" class="btn btn-sm btn-danger delete-btn">삭제</a>
            </td>
          </tr>
        </c:forEach>
      </c:otherwise>
    </c:choose>
    </tbody>
  </table>
</div>
<script>
  $(function(){
    $('.delete-btn').click(function(){
      return confirm("정말로 삭제하시겠습니까?");
    });
  });
</script>
