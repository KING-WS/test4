<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container">
    <h1>${p.productName}</h1>
    <hr>
    <div class="row">
        <div class="col-md-6">
            <img src="/img/${p.productImg}" class="img-fluid" alt="${p.productName}">
        </div>
        <div class="col-md-6">
            <h2>${p.productName}</h2>
            <p><strong>가격:</strong> ${p.productPrice}원</p>
            <p><strong>판매자:</strong> ${p.custId}</p>
            <p><strong>채팅 횟수:</strong> ${p.chatCount}</p>
            <p><strong>설명:</strong> ${p.productDesc}</p>
            <hr>
            <button id="wishlist-btn" class="btn btn-outline-danger" data-product-id="${p.productId}">
                <i class="fa fa-heart"></i> 찜
            </button>
            <button id="chat-start-btn" class="btn btn-primary" data-receiver-id="${p.custId}" data-product-id="${p.productId}">
                판매자와 채팅하기
            </button>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    const productId = $('#wishlist-btn').data('productId');

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

    // 채팅 시작 버튼 클릭 이벤트
    $('#chat-start-btn').on('click', function() {
        const receiverId = $(this).data('receiver-id');
        const productId = $(this).data('product-id');
        // 이 부분은 기존 채팅 시스템과 연동해야 합니다.
        // 예시: openChatModal(receiverId, productId);
        alert('채팅 시작! (수신자: ' + receiverId + ', 상품ID: ' + productId + ')');
        // 실제 채팅을 시작하는 로직을 여기에 구현해야 합니다.
        // WebSocket으로 메시지를 보낼 때 productId를 포함시켜야 합니다.
    });
});
</script>
