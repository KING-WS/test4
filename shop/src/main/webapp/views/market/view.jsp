<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="col-sm-10">
    <!-- Product Image -->
    <div class="row">
        <div class="col-12 text-center">
            <c:if test="${p.productImg != null and not empty p.productImg}">
                <img src="<c:url value='/imgs/${p.productImg}'/>" class="img-fluid" style="max-height: 400px;" alt="${p.productName}">
            </c:if>
            <c:if test="${p.productImg == null or empty p.productImg}">
                <div style="height: 400px; width: 100%; background-color: #e9ecef; display: flex; align-items: center; justify-content: center;">
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
    <button type="button" class="btn btn-success btn-lg my-2" data-toggle="modal" data-target="#chatModal" data-target-id="${p.custId}">
        판매자와 채팅하기
    </button>
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
    // Run this script only if the product has location data
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
</script>
