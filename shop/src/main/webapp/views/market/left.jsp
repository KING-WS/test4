<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="col-sm-2">
  <p>짭근마켓</p>
  <ul class="nav nav-pills flex-column">
    <li class="nav-item">
      <a class="nav-link" href="<c:url value="/market/add"/>">상품 등록</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="<c:url value="/market/map5"/>">주변 상품 지도</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="<c:url value="/market/myitems"/>">내 상품 관리</a>
    </li>
  </ul>
  <hr class="d-sm-none">
</div>
