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
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9122c6ed65a3629b19d62bab6d93ffaf&libraries=services"></script>
    
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
        location.reload(); // 페이지 새로고침
    });
});
</script>

<%-- ReportModal --%>
<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="reportModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="reportModalLabel">신고하기</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="reportForm">
                    <input type="hidden" id="reportCustId" name="reportedCustId">
                    <div class="form-group">
                        <label for="reportReason">신고 사유</label>
                        <textarea class="form-control" id="reportReason" name="reason" rows="4" placeholder="신고 사유를 입력해주세요."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <button type="button" class="btn btn-danger" id="submitReportBtn">신고 제출</button>
            </div>
        </div>
    </div>
</div>

<script>
    // jQuery를 사용하는 경우
    $(document).ready(function() {
        $('#reportModal').on('show.bs.modal', function (event) {
            // 모달을 연 버튼을 가져옴
            var button = $(event.relatedTarget);

            // 버튼의 data-target-id 값을 가져옴
            var custId = button.data('target-id');

            // 모달을 가져옴
            var modal = $(this);

            // 모달 안의 숨겨진 input 필드에 custId 값을 설정
            modal.find('#reportCustId').val(custId);
        });

        // '신고 제출' 버튼 클릭 시 동작
        $('#submitReportBtn').on('click', function() {
            var reportedId = $('#reportCustId').val();
            var reportContent = $('#reportReason').val();

            if (!reportContent) {
                alert('신고 사유를 입력해주세요.');
                return;
            }

            // 서버로 신고 데이터를 전송하는 Ajax 코드
            $.ajax({
                url: '<c:url value="/cust/addReport"/>', // 요청을 보낼 URL
                type: 'POST', // HTTP 메소드
                data: {
                    reportedId: reportedId,
                    reportContent: reportContent
                },
                success: function(response) {
                    // 서버로부터 응답을 성공적으로 받았을 때
                    if (response === 'success') {
                        alert('신고가 성공적으로 접수되었습니다.');
                    } else if (response === 'fail_login') {
                        alert('로그인이 필요합니다.');
                    } else {
                        alert('신고 접수 중 오류가 발생했습니다.');
                    }
                    // 모달 닫기 및 내용 초기화
                    $('#reportModal').modal('hide');
                    $('#reportReason').val('');
                },
                error: function(xhr, status, error) {
                    // 서버 요청 실패 시
                    alert('서버와 통신 중 오류가 발생했습니다.');
                    console.error("AJAX Error: ", status, error);
                }
            });
        });
    });
</script>

</body>
</html>