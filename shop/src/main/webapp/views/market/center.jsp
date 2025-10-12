<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .main-content-wrapper {
    display: flex;
    gap: 20px; /* 그리드와 컨텐츠 사이의 간격 */
  }
  .product-grid-container {
    flex: 3; /* 3:1 비율로 공간 차지 */
  }
  .content-container {
    flex: 1; /* 3:1 비율로 공간 차지 */
  }
  .product-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr); /* 한 줄에 3개의 아이템을 표시 */
    gap: 20px;
    padding: 20px;
  }

  .product-card {
    border: 1px solid #ddd;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
    background: white;
    cursor: pointer;
    text-decoration: none;
    color: inherit;
    display: block;
  }

  .product-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    text-decoration: none;
    color: inherit;
  }

  .product-card:visited {
    color: inherit;
    text-decoration: none;
  }

  .product-image {
    width: 100%;
    height: 250px;
    object-fit: cover;
    background: #f8f9fa;
  }

  .product-info {
    padding: 15px;
  }

  .product-title {
    font-size: 14px;
    font-weight: 500;
    color: #333;
    margin-bottom: 8px;
    line-height: 1.4;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }

  .product-price {
    font-size: 16px;
    font-weight: bold;
    color: #e74c3c;
    margin-bottom: 5px;
  }

  .product-date {
    font-size: 12px;
    color: #666;
  }

  .welcome-section {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 30px;
    border-radius: 10px;
    margin-bottom: 30px;
    text-align: center;
  }

  .welcome-section h2 {
    margin-bottom: 10px;
    font-size: 28px;
  }

  .welcome-section h5 {
    opacity: 0.9;
    font-weight: 300;
  }

  .content{
    height:400px;
    border: 2px solid red;
    overflow: auto;
  }
</style>

<div class="col-sm-10">
  <div class="welcome-section">
    <h2>짭근마켓에 오신 것을 환영합니다</h2>
    <h5>다양한 상품을 만나보세요</h5>
  </div>

  <div class="main-content-wrapper">
    <div class="product-grid-container">
      <div class="product-grid">
        <c:choose>
          <c:when test="${productList == null || empty productList}">
            <div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
              <h4>등록된 상품이 없습니다.</h4>
              <p>첫 번째 상품을 등록해보세요!</p>
            </div>
          </c:when>
          <c:otherwise>
            <c:forEach var="product" items="${productList}">
              <a href="/market/detail?id=${product.productId}" class="product-card">
                <c:choose>
                  <c:when test="${not empty product.productImg}">
                    <img src="/imgs/${product.productImg}" alt="${product.productName}" class="product-image">
                  </c:when>
                  <c:otherwise>
                    <div class="product-image" style="display: flex; align-items: center; justify-content: center; background: #f8f9fa; color: #999;">
                      <span>이미지 없음</span>
                    </div>
                  </c:otherwise>
                </c:choose>
                <div class="product-info">
                  <div class="product-title">
                      ${product.productName}
                  </div>
                  <div class="product-price">
                    <fmt:formatNumber type="number" pattern="#,###원" value="${product.productPrice}" />
                  </div>
                  <div class="product-date">
                    <c:set var="now" value="<%=new java.util.Date()%>" />
                    <c:set var="regDate" value="${product.productRegdate}" />
                    <c:choose>
                      <c:when test="${regDate != null}">
                        <fmt:parseDate value="${regDate}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDate" />
                        <c:set var="daysDiff" value="${(now.time - parsedDate.time) / (1000 * 60 * 60 * 24)}" />
                        <c:choose>
                          <c:when test="${daysDiff < 1}">
                            <fmt:formatNumber type="number" maxFractionDigits="0" value="${daysDiff * 24}" />시간 전
                          </c:when>
                          <c:otherwise>
                            <fmt:formatNumber type="number" maxFractionDigits="0" value="${daysDiff}" />일 전
                          </c:otherwise>
                        </c:choose>
                      </c:when>
                      <c:otherwise>
                        등록일 없음
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </a>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    <div class="content-container">
      <div class="content">
        <h5>dddd</h5>
      </div>
    </div>
  </div>

</div>