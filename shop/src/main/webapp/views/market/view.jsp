<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="col-sm-10">
    <!-- Product Image -->
    <div class="row mb-4"> <%-- 이미지와 상품 정보를 묶는 row, 하단 여백 추가 --%>
        <div class="col-md-6 text-center"> <%-- 중간 크기 화면 이상에서 6컬럼 차지 (이미지) --%>
            <div class="product-image-container" style="height: 400px; display: flex; align-items: center; justify-content: center; background-color: #f8f9fa; border: 1px solid #dee2e6;">
                <c:if test="${p.productImg != null and not empty p.productImg}">
                    <img  src="<c:url value='/imgs/${p.productImg}'/>" class="img-fluid" style="max-height: 100%; max-width: 100%; object-fit: cover;" alt="${p.productName}">
                </c:if>
                <c:if test="${p.productImg == null or empty p.productImg}">
                    <span class="text-muted">No Image</span>
                </c:if>
            </div>
        </div>

        <!-- Product Info -->
        <div class="col-md-6 d-flex flex-column justify-content-center"> <%-- 중간 크기 화면 이상에서 6컬럼 차지 (상품 정보) --%>
            <h2 class="mb-2">${p.productName}</h2> <%-- 하단 여백 추가 --%>
            <h4 class="mb-3"><span class="badge badge-secondary">${p.cateName}</span></h4> <%-- 하단 여백 추가 --%>
            <h1 class="mb-4"><fmt:formatNumber value="${p.productPrice}" pattern="#,###" /> 원</h1> <%-- 하단 여백 추가 --%>
        </div>
    </div>

    <hr class="my-4"> <%-- 상하단 여백이 있는 구분선 --%>

    <!-- Product Description -->
    <div class="product-description mb-4" style="white-space: pre-wrap;"> <%-- 주석 해제 및 하단 여백 추가 --%>
        <h4>상품 설명</h4> <%-- 상품 설명 제목 추가 --%>
        <p>${p.productDesc}</p>
    </div>

    <hr class="my-4"> <%-- 상하단 여백이 있는 구분선 --%>

    <!-- Product Location Map -->
    <div class="mb-4"> <%-- 하단 여백 추가 --%>
        <h4>거래 희망 장소</h4>
        <div id="static_map" style="width:100%;height:300px; border: 1px solid #dee2e6;"></div> <%-- 지도 테두리 추가 --%>
    </div>

    <hr class="my-4"> <%-- 상하단 여백이 있는 구분선 --%>

    <div class="text-right">
        <a href="<c:url value='/market/map5'/>" class="btn btn-primary">목록으로</a>
    </div>
</div>

<script>
    // Run this script only if the product has location data
    <c:if test="${p.lat != null and p.lng != null}">
    $(function() {
        let lat = ${p.lat};
        let lng = ${p.lng};

        let mapContainer = document.getElementById('static_map');
        let mapOption = {
            center: new kakao.maps.LatLng(lat, lng),
            level: 4, // Zoom level
            draggable: false, // 지도 드래그 비활성화 (정적 지도에 적합)
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
</script>
