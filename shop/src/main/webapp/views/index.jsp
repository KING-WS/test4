<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bootstrap 4 Website Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bcc88354a0c06049623a690be552d3ac&libraries=services"></script>
    
    <%-- highchart lib   --%>
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@highcharts/grid-lite/grid-lite.js"></script>
    <script src="https://code.highcharts.com/modules/wordcloud.js"></script>
    <script src="https://code.highcharts.com/modules/drilldown.js"></script>
    <script src="https://code.highcharts.com/highcharts-3d.js"></script>
    <script src="https://code.highcharts.com/modules/cylinder.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="https://code.highcharts.com/modules/export-data.js"></script>
    <script src="https://code.highcharts.com/modules/accessibility.js"></script>
    <script src="https://code.highcharts.com/themes/adaptive.js"></script>
    <script src="https://code.highcharts.com/modules/non-cartesian-zoom.js"></script>
    <script src="https://code.highcharts.com/modules/data.js"></script>
    <%-- Web Socket Lib --%>
    <script src="/webjars/sockjs-client/sockjs.min.js"></script>
    <script src="/webjars/stomp-websocket/stomp.min.js"></script>
</head>
<body>

<div class="jumbotron text-center" style="margin-bottom:0">
    <h1>My First Bootstrap 4 Page</h1>
    <h1><spring:message code="site.title"  arguments="aa,bb"  /></h1>
</div>
<ul class="nav justify-content-end">
    <c:choose>
        <c:when test="${sessionScope.cust.custId == null}">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/register"/> ">회원가입</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/login"/>">로그인</a>
            </li>
        </c:when>
        <c:otherwise>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/custinfo?id=${sessionScope.cust.custId}"/> ">${sessionScope.cust.custId} 님</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/logout"/> ">로그아웃</a>
            </li>
        </c:otherwise>
    </c:choose>
</ul>
<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
    <a class="navbar-brand" href="<c:url value="/"/>">홈으로</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="collapsibleNavbar">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/cust"/>">Cust</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/chart"/>">Chart</a>
            </li>
        </ul>
    </div>
</nav>
<div class="container" style="margin-top:30px; margin-bottom: 30px;">
    <div class="row">
        <%-- Left Menu Start ........  --%>
        <c:choose>
            <c:when test="${left == null}">
                <jsp:include page="blank.jsp"/>
            </c:when>
            <c:otherwise>
                <jsp:include page="${left}.jsp"/>
            </c:otherwise>
        </c:choose>

        <%-- Left Menu End ........  --%>
        <c:choose>
            <c:when test="${center == null}">
                <jsp:include page="center.jsp"/>
            </c:when>
            <c:otherwise>
                <jsp:include page="${center}.jsp"/>
            </c:otherwise>
        </c:choose>
        <%-- Center Start ........  --%>

        <%-- Center End ........  --%>
    </div>
</div>

<div class="text-center" style="background-color:black; color: white; margin-bottom:0; max-height: 50px;">
    <p>Footer</p>
</div>

<!-- Chat Modal -->
<div class="modal fade" id="chatModal" tabindex="-1" role="dialog" aria-labelledby="chatModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="chatModalLabel">1:1 Chat</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body p-0">
        <iframe id="chatFrame" src="about:blank" style="width: 100%; height: 70vh; border: none;"></iframe>
      </div>
    </div>
  </div>
</div>

<script>
$(function() {
    const chatModal = $('#chatModal');
    const chatFrame = $('#chatFrame');

    // Modal이 열릴 때 이벤트
    chatModal.on('show.bs.modal', function (event) {
        const button = $(event.relatedTarget); // Modal을 트리거한 버튼
        const targetId = button.data('target-id'); // data-target-id 속성 값 가져오기
        const productId = button.data('product-id');
        const productName = button.data('product-name');

        // iframe의 src를 채팅 페이지 URL로 설정
        let chatUrl = '<c:url value="/chat/modal_view" />' + '?target=' + targetId;
        if (productId) {
            chatUrl += '&productId=' + productId + '&productName=' + encodeURIComponent(productName);
        }
        chatFrame.attr('src', chatUrl);
    });

    // Modal이 닫힐 때 이벤트
    chatModal.on('hidden.bs.modal', function () {
        // iframe의 src를 비워서 리소스를 해제
        chatFrame.attr('src', 'about:blank');
    });
});
</script>

</body>
</html>