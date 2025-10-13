
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
  .unread-dot {
    display: inline-block;
    width: 8px;
    height: 8px;
    background-color: #dc3545; /* Bootstrap danger color */
    border-radius: 50%;
  }
  .avatar-placeholder {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background-color: #667eea;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    margin-right: 15px;
    text-transform: uppercase;
  }
  .media-body h6 {
    font-weight: 600;
    margin-bottom: 0;
  }
  .list-group-item-action {
    padding: 15px;
  }
</style>

<div class="col-sm-10">
  <h2>내 채팅 목록</h2>
  <p>나에게 메시지를 보낸 사용자 목록입니다. 아이디를 클릭하여 대화를 시작하세요.</p>

  <div class="list-group">
    <c:choose>
      <c:when test="${empty chatPartners}">
        <a href="#" class="list-group-item">아직 받은 메시지가 없습니다.</a>
      </c:when>
      <c:otherwise>
        <c:forEach var="convo" items="${chatPartners}">
          <button type="button" class="list-group-item list-group-item-action"
                  data-toggle="modal" data-target="#chatModal"
                  data-target-id="${convo.partnerId}"
                  data-product-id="${convo.productId}"
                  data-product-name="${convo.productName}">
            <div class="media">
              <div class="avatar-placeholder">
                <span>${fn:substring(convo.partnerId, 0, 1)}</span>
              </div>
              <div class="media-body">
                <div class="d-flex justify-content-between">
                  <h6 class="mt-0 mb-1">${convo.partnerId}</h6>
                  <c:if test="${convo.hasUnread}">
                    <span class="unread-dot"></span>
                  </c:if>
                </div>
                <p class="mb-0 small text-muted">문의 상품: ${convo.productName}</p>
              </div>
            </div>
          </button>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div>
