<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script>
  $(function(){
      $('#update_btn').click(()=>{
        let c = confirm('수정 하시겠습니까 ?');
        if(c == true){
          $('#product_update_form').attr('enctype', 'multipart/form-data');
          $('#product_update_form').attr('method', 'post');
          $('#product_update_form').attr('action','<c:url value="/market/updateimpl"/> ');
          $('#product_update_form').submit();
        }
      });
  });
</script>
<%-- Center Page --%>
<div class="col-sm-9">
  <h2>상품 수정 페이지</h2>
  <form id="product_update_form">
    <img src="<c:url value='/imgs/${p.productImg}'/>" style="max-width: 300px; margin-bottom: 15px;">
    <div class="form-group">
      <label for="id">상품 ID:</label>
      <p id="id">${p.productId}</p>
      <input type="hidden" name="productId" value="${p.productId}">
      <input type="hidden" name="productImg" value="${p.productImg}">
    </div>
    <div class="form-group">
      <label for="name">상품명:</label>
      <input type="text" class="form-control" value="${p.productName}"  id="name" name="productName">
    </div>
    <div class="form-group">
      <label for="price">가격:</label>
      <input type="number" class="form-control" value="${p.productPrice}" id="price" name="productPrice">
    </div>
    <div class="form-group">
      <label for="pimg">새 상품 이미지:</label>
      <input type="file" class="form-control" id="pimg" name="productImgFile">
    </div>
    <div class="form-group">
      <label for="cate">카테고리:</label>
      <select class="form-control" id="cate" name="cateId">
        <c:forEach var="cate" items="${cateList}">
          <option value="${cate.cateId}" <c:if test="${cate.cateId == p.cateId}">selected</c:if>>
            ${cate.cateName}
          </option>
        </c:forEach>
      </select>
    </div>
    <div class="form-group">
        <label for="desc">상품 설명:</label>
        <textarea class="form-control" id="desc" name="productDesc" rows="5">${p.productDesc}</textarea>
    </div>
    <div class="form-group">
      <label for="rdate">등록일:</label>
      <p id="rdate">
        <fmt:parseDate value="${ p.productRegdate }"
                       pattern="yyyy-MM-dd HH:mm:ss" var="parsedDateTime" type="both" />
        <fmt:formatDate pattern="yyyy년MM월dd일 HH시mm분ss시" value="${ parsedDateTime }" />
      </p>
    </div>
    <button type="button" class="btn btn-primary" id="update_btn">수정 완료</button>
    <a href="<c:url value='/market/myitems'/>" class="btn btn-secondary">취소</a>
  </form>

</div>
