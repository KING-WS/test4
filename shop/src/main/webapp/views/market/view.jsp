<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>


  /* 상품 이미지 스타일 */
  .product-image-container {
    text-align: center;
    margin-bottom: 30px;
  }

  .product-image {
    width: 100%;
    max-width: 600px; /* 이미지 최대 너비 */
    height: auto;
    border-radius: 15px;
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
    border: 3px solid white;
  }

  .no-image-placeholder {
    width: 100%;
    max-width: 600px;
    height: 400px;
    margin: auto;
    background-color: #e9ecef;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 15px;
    color: #aaa;
    font-size: 1.5rem;
    font-weight: 500;
  }

  /* 상품 정보 섹션 */
  .product-info-section {
    text-align: center;
    margin-bottom: 30px;
  }

  .product-name {
    font-size: 2.8rem;
    font-weight: 700;
    color: #2c3e50;
    margin-bottom: 10px;
  }

  .product-category {
    display: inline-block;
    background: #e9ecef;
    color: #555;
    padding: 6px 15px;
    border-radius: 20px;
    font-weight: 600;
    font-size: 1rem;
    margin-bottom: 15px;
  }

  .seller-info {
    font-size: 1.1rem;
    color: #666;
    margin-bottom: 20px;
  }

  .product-price {
    font-size: 3rem;
    font-weight: 700;
    background: linear-gradient(135deg, #667eea, #764ba2);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin: 20px 0;
  }

  /* 설명 및 지도 섹션 */
  .section-box {
    background: #f8f9fa;
    padding: 25px;
    border-radius: 15px;
    margin-bottom: 30px;
  }

  .section-title {
    font-size: 1.5rem;
    font-weight: 600;
    color: #333;
    margin-bottom: 15px;
    padding-bottom: 10px;
    border-bottom: 2px solid #e0e0e0;
  }

  .product-description p {
    font-size: 1.1rem;
    color: #555;
    line-height: 1.8;
    white-space: pre-wrap; /* 줄바꿈 및 공백 유지 */
  }

  #static_map {
    width: 100%;
    height: 350px;
    border-radius: 12px;
  }

  /* 버튼 공통 스타일 */
  .btn-custom {
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
    display: inline-block;
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
    text-decoration: none;
    color: white;
  }

  /* 채팅 버튼 스타일 */
  .btn-chat {
    background: linear-gradient(135deg, #28a745, #218838);
    box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
  }
  .btn-chat:hover {
    box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
  }

  /* 목록으로 버튼 스타일 */
  .btn-list {
    background: #6c757d;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
  }
  .btn-list:hover {
    background: #5a6268;
    box-shadow: 0 8px 25px rgba(0,0,0,0.2);
  }

</style>

<div class="col-sm-10">
    <!-- Product Image -->
    <div class="row">
        <div class="col-12 text-center">
            <c:if test="${p.productImg != null and not empty p.productImg}">
                <img src="<c:url value='/imgs/${p.productImg}'/>"
                     style="width: 100%; max-width: 500px; height: auto; border-radius: 8px;"
                     alt="${p.productName}">
            </c:if>
            <c:if test="${p.productImg == null or empty p.productImg}">
                <div style="height: 600px; width: 100%; max-width: 700px; margin: auto; background-color: #e9ecef; display: flex; align-items: center; justify-content: center; border-radius: 8px;">
                    <span>No Image</span>
                </div>
            </c:if>
        </div>
    </div>

    <hr>

    <!-- Product Info -->
    <h2>${p.productName}</h2>
    <h4><span class="badge badge-secondary">${p.cateName}</span></h4>
    <h5><strong>판매자:</strong> ${p.custId}</h5>
    <h5><strong>채팅 횟수:</strong> ${p.chatCount}</h5>

    <button id="wishlist-btn" class="btn btn-secondary btn-custom btn-lg my-2">
        <i class="fa fa-heart-o"></i>
    </button>
    <button type="button" class="btn-custom btn-chat btn-lg my-2" data-toggle="modal" data-target="#chatModal" data-target-id="${p.custId}" data-product-id="${p.productId}" data-product-name="${p.productName}">
        판매자와 채팅하기
    </button>
    <button type="button" class="btn-custom btn-danger btn-lg my-2" data-toggle="modal" data-target="#reportModal" data-target-id="${p.custId}" data-product-id="${p.productId}">신고하기</button>
    <h1><fmt:formatNumber value="${p.productPrice}" pattern="#,###" /> 원</h1>

    <hr>

    <!-- Product Description -->
    <div class="section-box">
      <h4 class="section-title">상품 설명</h4>
      <div class="product-description">
        <p>${p.productDesc}</p>
      </div>
    </div>

    <!-- Product Location Map -->
    <div class="section-box">
      <h4 class="section-title">거래 희망 장소</h4>
      <div id="static_map"></div>
    </div>

    <div class="text-right mt-4">
      <a href="<c:url value='/market/map5'/>" class="btn-custom btn-list">목록으로</a>
    </div>
  </div>
</div>

<script>
    $(document).ready(function() {
        const productId = ${p.productId};

        // 찜 상태 확인
        $.ajax({
            url: '/api/wishlist/status',
            type: 'GET',
            data: { productId: productId },
            success: function(response) {
                updateWishlistButton(response.wishlistStatus);
            }
        });

        // 찜 버튼 클릭 이벤트
        $('#wishlist-btn').on('click', function() {
            $.ajax({
                url: '/api/wishlist/toggle',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ productId: productId }),
                success: function(response) {
                    updateWishlistButton(response.wishlistStatus);
                },
                error: function(xhr) {
                    if (xhr.status === 401) {
                        alert('로그인이 필요합니다.');
                        window.location.href = '/login';
                    }
                }
            });
        });

        function updateWishlistButton(isWishlisted) {
            const btn = $('#wishlist-btn');
            const icon = btn.find('i');
            if (isWishlisted) {
                btn.removeClass('btn-secondary').addClass('btn-danger');
                icon.removeClass('fa-heart-o').addClass('fa-heart');
            } else {
                btn.removeClass('btn-danger').addClass('btn-secondary');
                icon.removeClass('fa-heart').addClass('fa-heart-o');
            }
        }

        // 지도 스크립트
        <c:if test="${p.lat != null and p.lng != null}">
        $(function() {
            let lat = ${p.lat};
            let lng = ${p.lng};

    let mapContainer = document.getElementById('static_map');
    let mapOption = {
      center: new kakao.maps.LatLng(lat, lng),
      level: 4, // Zoom level
      draggable: false, // Disable drag
      scrollwheel: false, // Disable zoom
      keyboardShortcuts: false // Disable keyboard shortcuts
    };

    // Create map
    let map = new kakao.maps.Map(mapContainer, mapOption);

    // Create marker
    let marker = new kakao.maps.Marker({
      position: new kakao.maps.LatLng(lat, lng)
    });

    // Display marker on the map
    marker.setMap(map);
  });
  </c:if>
    });
</script>