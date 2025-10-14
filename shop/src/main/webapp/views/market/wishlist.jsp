<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="col-sm-10">
    <h2>나의 찜 목록</h2>
    <hr>
    <div class="row">
        <c:choose>
            <c:when test="${not empty plist}">
                <c:forEach items="${plist}" var="p">
                    <div class="col-md-4 mb-4">
                        <div class="card">
                            <a href="/market/detail?id=${p.productId}">
                                <img src="/imgs/${p.productImg}" class="card-img-top" alt="${p.productName}" style="height: 200px; object-fit: cover;">
                            </a>
                            <div class="card-body">
                                <h5 class="card-title">${p.productName}</h5>
                                <p class="card-text">${p.productPrice}원</p>
                                <a href="/market/detail?id=${p.productId}" class="btn btn-primary">상세보기</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12 text-center">
                    <p>찜한 상품이 없습니다.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
