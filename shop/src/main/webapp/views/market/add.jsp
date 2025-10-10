<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Center Page --%>
<div class="col-sm-9">
  <h2>상품 등록 페이지</h2>
  <form action="/market/registerimpl" method="post" enctype="multipart/form-data">
    <div class="form-group">
      <label for="name">상품명:</label>
      <input type="text" class="form-control" placeholder="상품명을 입력하세요" id="name" name="productName">
    </div>
    <div class="form-group">
      <label for="price">가격:</label>
      <input type="number" class="form-control" placeholder="가격을 입력하세요" id="price" name="productPrice">
    </div>
    <div class="form-group">
      <label for="desc">상품 설명:</label>
      <textarea class="form-control" id="desc" name="productDesc" rows="5" placeholder="상품 설명을 입력하세요"></textarea>
    </div>
    <div class="form-group">
      <label for="pimg">상품 이미지:</label>
      <input type="file" class="form-control" placeholder="이미지를 선택하세요" id="pimg" name="productImgFile">
    </div>
    <div class="form-group">
      <label for="cate">카테고리:</label>
      <select class="form-control" id="cate" name="cateId">
        <c:forEach var="cate" items="${cateList}">
          <option value="${cate.cateId}">${cate.cateName}</option>
        </c:forEach>
      </select>
    </div>
    <div class="form-group">
      <label for="lat">위도:</label>
      <input type="text" class="form-control" id="lat" name="lat" value="0" readonly>
    </div>
    <div class="form-group">
      <label for="lng">경도:</label>
      <input type="text" class="form-control" id="lng" name="lng" value="0" readonly>
    </div>
    <button type="submit" class="btn btn-primary">등록</button>
  </form>

  <script>
    $(function() {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
          // 위치 정보 가져오기 성공
          $('#lat').val(position.coords.latitude);
          $('#lng').val(position.coords.longitude);
        }, function(error) {
          // 실패 시, 기본 위치(서울 시청)로 설정
          //36.799302, 127.075077
          $('#lat').val(36.799302);
          $('#lng').val(127.075077);
        });
      } else {
        // 브라우저가 지원하지 않을 경우, 기본 위치로 설정
        $('#lat').val(36.799302);
        $('#lng').val(127.075077);
      }
    });
  </script>
</div>