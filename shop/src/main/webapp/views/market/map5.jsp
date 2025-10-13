<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Center Page --%>
<style>
  #map{
    width: auto;
    height: 400px;
    /*border: 2px solid red;*/
  }
  #content{
    width:auto;
    height:500px;
    /*border: 2px solid red;*/
    overflow: auto;
    border: 1px solid #6c757d;

  }

  .content-container {
    flex: 1; /* 3:1 비율로 공간 차지 */
    display: flex;
    flex-direction: column;
  }
  /* --- 상품 목록 스타일 추가 --- */
  .product-item {
    display: flex; /* 이미지와 텍스트를 가로로 정렬 */
    align-items: center; /* 세로 중앙 정렬 */
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 10px;
    margin-bottom: 10px;
    text-decoration: none; /* 링크 밑줄 제거 */
    color: #333; /* 기본 텍스트 색상 */
    transition: background-color 0.2s;
  }
  .product-item:hover {
    background-color: #f5f5f5; /* 마우스 올렸을 때 배경색 변경 */
  }
  .product-item img {
    width: 80px;
    height: 80px;
    object-fit: cover; /* 이미지가 비율을 유지하며 꽉 차도록 설정 */
    border-radius: 5px;
    margin-right: 15px; /* 이미지와 텍스트 사이 간격 */
  }
</style>

<div class="col-sm-10">
  <div class="row">
    <div class="col-sm-8 col-lg-6">
      <h2>주변 상품</h2>
      <button id="cate_all_btn" class="btn btn-info">전체</button>
      <button id="cate_1_btn" class="btn btn-primary">전자기기</button>
      <button id="cate_2_btn" class="btn btn-primary">생활용품</button>
      <button id="cate_3_btn" class="btn btn-primary">가구</button>
      <button id="cate_4_btn" class="btn btn-primary">의류</button>
      <button id="cate_5_btn" class="btn btn-primary">도서</button>
      <button id="cate_6_btn" class="btn btn-primary">스포츠/레저</button>
      <button id="cate_7_btn" class="btn btn-primary">기타</button>
      <div id="map" style="margin-top:10px;"></div>
    </div>
    <div class="col-sm-4 col-lg-6">
      <div id="content"></div>
    </div>
  </div>
</div>

<script>
  const map5 = {
    map:null,
    category:null,
    markers:[],
    showMarkers:function(map){
      $(this.markers).each((index,item)=>{
        item.setMap(map);
      });
    },
    init:function(){
      this.makeMap(36.800209, 127.074968);
      this.getData(); // Load all items initially

      $('#cate_all_btn').click(()=>{
        this.category = null;
        this.getData();
      });
      $('#cate_1_btn').click(()=>{
        this.category = 1;
        this.getData();
      });
      $('#cate_2_btn').click(()=>{
        this.category = 2;
        this.getData();
      });
      $('#cate_3_btn').click(()=>{
        this.category = 3;
        this.getData();
      });
      $('#cate_4_btn').click(()=>{
        this.category = 4;
        this.getData();
      });
      $('#cate_5_btn').click(()=>{
        this.category = 5;
        this.getData();
      });
      $('#cate_6_btn').click(()=>{
        this.category = 6;
        this.getData();
      });
      $('#cate_7_btn').click(()=>{
        this.category = 7;
        this.getData();
      });
    },
    makeMap:function(lat, lng){
      var mapContainer = document.getElementById('map');
      var mapOption = {
        center: new kakao.maps.LatLng(lat, lng),
        level: 5
      };
      this.map = new kakao.maps.Map(mapContainer, mapOption);

      var mapTypeControl = new kakao.maps.MapTypeControl();
      this.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      var zoomControl = new kakao.maps.ZoomControl();
      this.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
    },
    getData:function(){
      let ajaxData = {};
      if (this.category != null) {
        ajaxData.category = this.category;
      }
      $.ajax({
        url:'<c:url value="/getitems"/>',
        data: ajaxData,
        success:(result)=>{
          this.makeMarkers(result);
        },
        error:()=>{ alert('AJAX Error'); }
      });
    },

    makeMarkers:function(datas){
      // Clear previous markers from the map and the list
      this.showMarkers(null);
      this.markers = [];
      $('#content').html('');

      let result = '';

      $(datas).each((index,item)=>{
        // Add a null check for lat/lng
        if(item.lat != null && item.lng != null) {
          let markerPosition  = new kakao.maps.LatLng(item.lat, item.lng);
          let marker = new kakao.maps.Marker({
            position: markerPosition
          });

          let iwContent = `<h6>\${item.productName}</h6>
                        <p>가격: \${item.productPrice.toLocaleString()}원</p>`;
          if(item.productImg) {
            iwContent += `<img src="<c:url value='/imgs/\${item.productImg}'/>" width="80">`;
          }

          let infowindow = new kakao.maps.InfoWindow({
            content : iwContent,
            removable : true
          });

          kakao.maps.event.addListener(marker, 'mouseover', ()=> {
            infowindow.open(this.map, marker);
          });
          kakao.maps.event.addListener(marker, 'mouseout', ()=> {
            infowindow.close();
          });
          kakao.maps.event.addListener(marker, 'click', ()=> {
            location.href = '<c:url value="/market/detail?id='+item.productId+'"/>';
          });

          this.markers.push(marker);
        }

        // Make Content List (show all items, even those without location)
        // 카드 형태의 HTML 구조로 변경
        result += `<a href="<c:url value='/market/detail?id=\${item.productId}'/>" class="product-item">`;

        if(item.productImg) {
          result += `<img src="<c:url value='/imgs/\${item.productImg}'/>">`;
        } else {
          // 이미지가 없을 경우 기본 이미지 표시
          result += `<img src="<c:url value='/imgs/default.png'/>">`;
        }

        result += `<div>
                     <strong>\${item.productName}</strong><br>
                     <span>\${item.productPrice.toLocaleString()}원</span>
                   </div></a>`;
      });

      $('#content').html(result);
      this.showMarkers(this.map);
    }

  }
  $(function(){
    map5.init();
  });
</script>
