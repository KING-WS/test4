<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  /* 전체 컨텐츠를 감싸는 메인 래퍼 스타일 */

  /* 페이지 상단 제목 스타일 */
  .page-title {
    background: linear-gradient(135deg, #667eea, #764ba2);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    font-size: 2.5rem;
    font-weight: 700;
    text-align: center;
    margin-bottom: 40px;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
  }

  /* 폼 그룹 스타일 */
  .form-group {
    margin-bottom: 25px;
  }

  /* 라벨 스타일 */
  .form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #555;
    font-size: 14px;
  }

  /* 폼 입력 요소(input, select, textarea) 공통 스타일 */
  .form-input {
    width: 100%;
    padding: 12px 18px;
    border: 1px solid #ddd;
    border-radius: 10px;
    font-size: 16px;
    transition: all 0.3s ease;
    box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
  }

  .form-input:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
  }

  /* 파일 입력창 커스텀 스타일 */
  .form-input[type="file"] {
    padding: 8px;
    background: #f9f9f9;
  }

  /* 상품 이미지 미리보기 스타일 */
  .product-preview-img {
    max-width: 300px;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    margin-bottom: 20px;
    border: 3px solid white;
  }

  /* 정보 표시 텍스트 스타일 (ID, 등록일) */
  .info-text {
    font-size: 16px;
    color: #333;
    padding: 10px 0;
  }

  /* 버튼 컨테이너 */
  .button-container {
    margin-top: 30px;
    display: flex;
    gap: 15px; /* 버튼 사이 간격 */
  }

  /* 버튼 공통 스타일 */
  .btn-custom {
    flex-grow: 1; /* 버튼이 동일한 너비를 가지도록 함 */
    border: none;
    color: white;
    padding: 15px 30px;
    border-radius: 12px;
    font-weight: 700;
    font-size: 18px;
    cursor: pointer;
    transition: all 0.3s ease;
    text-align: center;
    text-decoration: none;
    position: relative;
    overflow: hidden;
  }

  .btn-custom::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.25), transparent);
    transition: left 0.5s;
  }

  .btn-custom:hover::before {
    left: 100%;
  }

  .btn-custom:hover {
    transform: translateY(-3px);
  }

  /* 수정 완료 버튼 스타일 */
  .btn-update {
    background: linear-gradient(135deg, #667eea, #764ba2);
    box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
  }
  .btn-update:hover {
    box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
  }

  /* 취소 버튼 스타일 */
  .btn-cancel {
    background: #6c757d;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
  }
  .btn-cancel:hover {
    background: #5a6268;
    box-shadow: 0 8px 25px rgba(0,0,0,0.2);
  }

</style>

<div class="col-sm-10">
  <div class="content-wrapper">
    <h1 class="page-title">상품 수정</h1>
    <form id="product_update_form">
      <div class="text-center">
        <img src="<c:url value='/imgs/${p.productImg}'/>" class="product-preview-img">
      </div>
      <input type="hidden" name="productId" value="${p.productId}">
      <input type="hidden" name="productImg" value="${p.productImg}">

      <div class="form-group">
        <label>상품 ID</label>
        <p class="info-text">${p.productId}</p>
      </div>
      <div class="form-group">
        <label for="name">상품명</label>
        <input type="text" class="form-input" value="${p.productName}" id="name" name="productName">
      </div>
      <div class="form-group">
        <label for="price">가격</label>
        <input type="number" class="form-input" value="${p.productPrice}" id="price" name="productPrice">
      </div>
      <div class="form-group">
        <label for="pimg">새 상품 이미지</label>
        <input type="file" class="form-input" id="pimg" name="productImgFile">
      </div>
      <div class="form-group">
        <label for="cate">카테고리</label>
        <select class="form-input" id="cate" name="cateId">
          <c:forEach var="cate" items="${cateList}">
            <option value="${cate.cateId}" <c:if test="${cate.cateId == p.cateId}">selected</c:if>>
                ${cate.cateName}
            </option>
          </c:forEach>
        </select>
      </div>
      <div class="form-group">
        <label for="desc">상품 설명</label>
        <textarea class="form-input" id="desc" name="productDesc" rows="5">${p.productDesc}</textarea>
      </div>
      <div class="form-group">
        <label>등록일</label>
        <p class="info-text">
          <fmt:parseDate value="${p.productRegdate}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDateTime" type="both" />
          <fmt:formatDate pattern="yyyy년 MM월 dd일 HH:mm" value="${parsedDateTime}" />
        </p>
      </div>

      <div class="button-container">
        <button type="button" class="btn-custom btn-update" id="update_btn">수정 완료</button>
        <a href="<c:url value='/market/myitems'/>" class="btn-custom btn-cancel">취소</a>
      </div>
    </form>
  </div>
</div>

<script>
  $(function(){
    $('#update_btn').click(()=>{
      let c = confirm('수정 하시겠습니까?');
      if(c == true){
        $('#product_update_form').attr('enctype', 'multipart/form-data');
        $('#product_update_form').attr('method', 'post');
        $('#product_update_form').attr('action','<c:url value="/market/updateimpl"/>');
        $('#product_update_form').submit();
      }
    });
  });
</script>
