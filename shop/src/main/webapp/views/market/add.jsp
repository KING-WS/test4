<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
    margin-bottom: 40px; /* 폼과의 간격 확보 */
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
  }

  /* 폼 그룹 스타일 */
  .form-group {
    margin-bottom: 25px; /* 각 폼 요소 사이의 간격 */
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

  /* 읽기 전용 필드 스타일 */
  .form-input[readonly] {
    background-color: #e9ecef;
    cursor: not-allowed;
  }

  /* 등록 버튼 스타일 */
  .btn-submit {
    width: 100%;
    background: linear-gradient(135deg, #667eea, #764ba2);
    border: none;
    color: white;
    padding: 15px 30px;
    border-radius: 12px;
    font-weight: 700;
    font-size: 18px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
    position: relative;
    overflow: hidden;
    margin-top: 20px; /* 폼과의 간격 */
  }

  .btn-submit::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.25), transparent);
    transition: left 0.5s;
  }

  .btn-submit:hover::before {
    left: 100%;
  }

  .btn-submit:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
  }

</style>

<div class="col-sm-10">
  <div class="content-wrapper">
    <h1 class="page-title">상품 등록</h1>
    <form action="/market/registerimpl" method="post" enctype="multipart/form-data">
      <div class="form-group">
        <label for="name">상품명</label>
        <input type="text" class="form-input" placeholder="상품명을 입력하세요" id="name" name="productName">
      </div>
      <div class="form-group">
        <label for="price">가격</label>
        <input type="number" class="form-input" placeholder="가격을 입력하세요" id="price" name="productPrice">
      </div>
      <div class="form-group">
        <label for="desc">상품 설명</label>
        <textarea class="form-input" id="desc" name="productDesc" rows="5" placeholder="상품 설명을 입력하세요"></textarea>
      </div>
      <div class="form-group">
        <label for="pimg">상품 이미지</label>
        <input type="file" class="form-input" id="pimg" name="productImgFile">
      </div>
      <div class="form-group">
        <label for="cate">카테고리</label>
        <select class="form-input" id="cate" name="cateId">
          <c:forEach var="cate" items="${cateList}">
            <option value="${cate.cateId}">${cate.cateName}</option>
          </c:forEach>
        </select>
      </div>
      <div class="form-group">
        <label for="lat">위도</label>
        <input type="text" class="form-input" id="lat" name="lat" value="0" readonly>
      </div>
      <div class="form-group">
        <label for="lng">경도</label>
        <input type="text" class="form-input" id="lng" name="lng" value="0" readonly>
      </div>
      <button type="submit" class="btn-submit">등록하기</button>
    </form>
  </div>
</div>

<script>
  $(function() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        // 위치 정보 가져오기 성공
        $('#lat').val(position.coords.latitude);
        $('#lng').val(position.coords.longitude);
      }, function(error) {
        // 실패 시, 기본 위치(선문대)로 설정
        $('#lat').val(36.799079);
        $('#lng').val(127.075027);
      });
    } else {
      // 브라우저가 지원하지 않을 경우, 기본 위치로 설정
      $('#lat').val(36.799079);
      $('#lng').val(127.075027);
    }
  });
</script>
