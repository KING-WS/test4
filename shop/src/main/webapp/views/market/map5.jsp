<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Center Page --%>
<style>
  #map{
    width: auto;
    height: 400px;
    border: 2px solid red;
  }
  #content{
    width:auto;
    height:500px;
    border: 2px solid red;
    overflow: auto;
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
          if(item.img) {
            iwContent += `<img src="<c:url value='/imgs/\${item.img}'/>" width="80">`;
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
        result += `<p>
                    <a href="<c:url value='/market/detail?id=\${item.productId}'/>">
                      `;
        if(item.img) {
          result += `<img width="30px" src="<c:url value='/imgs/\${item.img}'/> ">`;
        }
        result += ` \${item.productName} - \${item.productPrice.toLocaleString()}원
                    </a>
                   </p>`;
      });

      $('#content').html(result);
      this.showMarkers(this.map);
    }

  }
  $(function(){
    map5.init();
  });
</script>
