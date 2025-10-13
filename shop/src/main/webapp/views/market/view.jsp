<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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

    <button id="wishlist-btn" class="btn btn-outline-danger btn-lg my-2">
        <i class="fa fa-heart-o"></i> 찜
    </button>
    <button type="button" class="btn btn-success btn-lg my-2" data-toggle="modal" data-target="#chatModal" data-target-id="${p.custId}" data-product-id="${p.productId}">
        판매자와 채팅하기
    </button>
    <button type="button" class="btn btn-danger btn-lg my-2" data-toggle="modal" data-target="#reportModal" data-target-id="${p.custId}">신고하기</button>
    <h1><fmt:formatNumber value="${p.productPrice}" pattern="#,###" /> 원</h1>

    <hr>

    <!-- Product Description -->
    <div class="product-description" style="margin-bottom: 20px; white-space: pre-wrap;">
        <p>${p.productDesc}</p>
    </div>

    <!-- Product Location Map -->
    <h4>거래 희망 장소</h4>
    <div id="static_map" style="width:100%;height:300px;"></div>

    <hr>

    <div class="text-right">
        <a href="<c:url value='/market/map5'/>" class="btn btn-primary">목록으로</a>
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
            if (isWishlisted) {
                btn.removeClass('btn-outline-danger').addClass('btn-danger');
                btn.find('i').removeClass('fa-heart-o').addClass('fa-heart');
            } else {
                btn.removeClass('btn-danger').addClass('btn-outline-danger');
                btn.find('i').removeClass('fa-heart').addClass('fa-heart-o');
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
                level: 4,
                draggable: false,
                scrollwheel: false,
                keyboardShortcuts: false
            };

            let map = new kakao.maps.Map(mapContainer, mapOption);

            let marker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(lat, lng)
            });

            marker.setMap(map);
        });
        </c:if>
    });
</script>