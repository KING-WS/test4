
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .unread-dot {
    display: inline-block;
    width: 8px;
    height: 8px;
    background-color: #dc3545; /* Bootstrap danger color */
    border-radius: 50%;
  }
</style>

<div class="col-sm-12">
  <h2>내 채팅 목록</h2>
  <p>나에게 메시지를 보낸 사용자 목록입니다. 아이디를 클릭하여 대화를 시작하세요.</p>

  <div class="list-group">
    <c:choose>
      <c:when test="${empty chatPartners}">
        <a href="#" class="list-group-item">아직 받은 메시지가 없습니다.</a>
      </c:when>
      <c:otherwise>
        <c:forEach var="partnerInfo" items="${chatPartners}">
          <button type="button" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" 
                  data-toggle="modal" data-target="#chatModal" data-target-id="${partnerInfo.partnerId}">
            <span>
              <strong>${partnerInfo.partnerId}</strong> 님과의 대화
            </span>
            <c:if test="${partnerInfo.hasUnread}">
              <span class="unread-dot"></span>
            </c:if>
          </button>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div>
