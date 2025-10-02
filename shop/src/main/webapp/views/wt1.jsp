<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* 컨트롤러 영역을 감싸는 컨테이너 */
    .control-container {
        display: flex; /* Flexbox 레이아웃 적용 */
        align-items: center; /* 세로 중앙 정렬 */
        gap: 10px; /* 요소 사이의 간격 */
        margin-bottom: 20px; /* 지도와의 간격 */
        /* 필요하다면 전체 너비를 제한할 수 있습니다. 예를 들어, max-width: 800px; */
    }

    #result {
        /* width: 400px;  이 부분을 주석 처리하거나 삭제합니다. */
        /* 또는 필요한 최소 너비로 줄일 수 있습니다. */
        min-width: 200px; /* 내용이 충분히 보일 수 있는 최소 너비 */
        max-width: 600px; /* 너무 길어지지 않도록 최대 너비 설정 (선택 사항) */
        flex-grow: 1; /* 남은 공간을 채우도록 설정 */
        border: 2px solid red;
        padding: 5px; /* 내부 여백 추가 */
        box-sizing: border-box; /* 패딩과 테두리를 너비에 포함 */
        height: auto; /* 내용에 따라 높이 자동 조절 */
    }

    #map {
        width: 100%;
        height: 350px;
    }
</style>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_APP_KEY"></script>

<script>
    // (2) 메인 로직을 처리하는 객체
    let wt1 = {
        // (3) 지도에 표시할 지역별 좌표 정보
        locations: {
            "108": { name: "전국", lat: 36.3, lng: 127.8, level: 12 },
            "109": { name: "서울", lat: 37.566826, lng: 126.9786567, level: 8 },
            "110": { name: "인천", lat: 37.4562557, lng: 126.7052062, level: 8 },
            "133": { name: "천안", lat: 36.8153, lng: 127.1139, level: 8 },
            "143": { name: "대구", lat: 35.8714, lng: 128.6014, level: 8 },
            "159": { name: "부산", lat: 35.1796, lng: 129.0756, level: 8 }
        },
        map: null,
        marker: null,

        // (4) 초기화 함수
        init: function() {
            this.initMap(); // 지도 생성

            $('#get_btn').click(() => {
                let locValue = $('#loc').val();
                this.getData(locValue); // 날씨 데이터 요청
                this.panTo(locValue);   // 지도 이동
            });
        },

        // (5) 카카오맵 생성 함수
        initMap: function() {
            const container = document.getElementById('map');
            const initialLocation = this.locations["108"];
            const options = {
                center: new kakao.maps.LatLng(initialLocation.lat, initialLocation.lng),
                level: initialLocation.level
            };
            this.map = new kakao.maps.Map(container, options);
            this.marker = new kakao.maps.Marker({ position: this.map.getCenter() });
            this.marker.setMap(this.map);
        },

        // (6) 선택한 지역으로 지도를 이동시키는 함수
        panTo: function(locValue) {
            const targetLocation = this.locations[locValue];
            const moveLatLon = new kakao.maps.LatLng(targetLocation.lat, targetLocation.lng);
            this.map.panTo(moveLatLon);
            this.map.setLevel(targetLocation.level);
            this.marker.setPosition(moveLatLon);
        },

        // (7) 서버에 날씨 데이터를 AJAX로 요청하는 함수
        getData: function(loc) {
            $.ajax({
                url: '<c:url value="/getwt1"/>',
                data: { 'loc': loc },
                success: (data) => {
                    console.log(data);
                    this.display(data);
                }
            });
        },

        // (8) 날씨 정보를 화면에 표시하는 함수
        display: function(data) {
            // API 응답 구조에 따라 실제 데이터 경로를 정확히 지정해야 합니다.
            const txt = data.response.body.items.item[0].wfSv;
            $('#result').html(txt);
        }
    }

    // (9) 페이지 로딩이 완료되면 스크립트 실행
    $(function() {
        wt1.init();
    });
</script>

<div class="col-sm-10">
    <h2>Weather 1 Page</h2>

    <div class="control-container">
        <select id="loc">
            <option value="108">전국</option>
            <option value="109">서울</option>
            <option value="110">인천</option>
            <option value="133">천안</option>
            <option value="143">대구</option>
            <option value="159">부산</option>
        </select>
        <button id="get_btn">get</button>
        <div id="result"></div>
    </div>

    <h5 id="status"></h5>

    <div id="map"></div>

</div>