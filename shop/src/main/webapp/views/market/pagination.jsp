<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- pagination start -->
<div class="col text-center ">
  <ul class="pagination justify-content-center">
    <c:choose>
      <c:when test="${productList.getPrePage() != 0}">
        <li class="page-item">
          <a class="page-link" href="<c:url value="${target}?pageNo=${productList.getPrePage()}&productName=${ps.productName}&cateId=${ps.cateId}" />">Previous</a>
        </li>
      </c:when>
      <c:otherwise>
        <li class="page-item disabled">
          <a class="page-link" href="#">Previous</a>
        </li>
      </c:otherwise>
    </c:choose>

    <c:forEach begin="${productList.getNavigateFirstPage()}" end="${productList.getNavigateLastPage()}" var="page">
      <c:choose>
        <c:when test="${productList.getPageNum() == page}">
          <li class="page-item active">
            <a class="page-link" href="<c:url value="${target}?pageNo=${page}&productName=${ps.productName}&cateId=${ps.cateId}" />">${page}</a>
          </li>
        </c:when>
        <c:otherwise>
          <li class="page-item">
            <a class="page-link" href="<c:url value="${target}?pageNo=${page}&productName=${ps.productName}&cateId=${ps.cateId}" />">${page}</a>
          </li>
        </c:otherwise>
      </c:choose>
    </c:forEach>

    <c:choose>
      <c:when test="${productList.getNextPage() != 0}">
        <li class="page-item">
          <a class="page-link" href="<c:url value="${target}?pageNo=${productList.getNextPage()}&productName=${ps.productName}&cateId=${ps.cateId}" />">Next</a>
        </li>
      </c:when>
      <c:otherwise>
        <li class="page-item disabled">
          <a class="page-link" href="#">Next</a>
        </li>
      </c:otherwise>
    </c:choose>
  </ul>
</div>
<!-- pagination end -->
