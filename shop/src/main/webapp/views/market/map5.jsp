<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Center Page --%>
<style>
  /* 카카오맵이 표시될 영역의 스타일 */
  #map{
    width: 100%;
    height: 450px;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    border: 3px solid #d6d6d6;
    transition: all 0.3s ease;
  }

  /* 지도에 마우스를 올렸을 때의 스타일 */
  #map:hover {
    transform: translateY(-2px);
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
  }

  /* 상품 목록이 표시될 영역의 스타일 */
  #content{
    width: 100%;
    height: 500px;
    overflow-y: auto;
    border-radius: 15px;
    background: linear-gradient(145deg, #f8f9fa, #e9ecef);
    padding: 20px;
    box-shadow: inset 0 2px 10px rgba(0, 0, 0, 0.1);
  }

  /* 페이지 상단 제목('주변 상품 탐색') 스타일 */
  .page-title {
    background: linear-gradient(135deg, #667eea, #764ba2);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    font-size: 2.5rem;
    font-weight: 700;
    text-align: center;
    margin-bottom: 30px;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
  }

  /* 카테고리 버튼들을 감싸는 컨테이너 스타일 */
  .category-buttons {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-bottom: 20px;
    justify-content: center;
  }

  /* 개별 카테고리 버튼 스타일 */
  .category-btn {
    background: linear-gradient(135deg, #667eea, #764ba2);
    border: none;
    color: white;
    padding: 12px 24px;
    border-radius: 25px;
    font-weight: 600;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
    position: relative;
    overflow: hidden;
  }

  /* 버튼에 마우스를 올렸을 때 빛나는 효과를 위한 가상 요소 */
  .category-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
    transition: left 0.5s;
  }


  /* 버튼에 마우스를 올렸을 때의 스타일 */
  .category-btn:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
  }

  /* 현재 활성화된(선택된) 카테고리 버튼 스타일 */
  .category-btn.active {
    background: linear-gradient(135deg, #ff6b6b, #ee5a24);
    box-shadow: 0 6px 20px rgba(255, 107, 107, 0.4);
  }

  /* 목록에 표시되는 각 상품 아이템 스타일 */
  .product-item {
    display: flex;
    align-items: center;
    background: white;
    border-radius: 15px;
    padding: 20px;
    margin-bottom: 15px;
    text-decoration: none;
    color: #333;
    transition: all 0.3s ease;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
    border: 1px solid rgba(255, 255, 255, 0.2);
    position: relative;
    overflow: hidden;
  }

  /* 상품 아이템에 마우스를 올렸을 때 빛나는 효과를 위한 가상 요소 */
  .product-item::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(102, 126, 234, 0.1), transparent);
    transition: left 0.5s;
  }


  /* 상품 아이템에 마우스를 올렸을 때의 스타일 */
  .product-item:hover {
    transform: translateY(-5px) scale(1.02);
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
    background: linear-gradient(135deg, #f8f9ff, #ffffff);
  }

  /* 상품 아이템 내부의 이미지 스타일 */
  .product-item img {
    width: 90px;
    height: 90px;
    object-fit: cover;
    border-radius: 12px;
    margin-right: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    transition: all 0.3s ease;
  }

  /* 상품 아이템에 마우스를 올렸을 때 이미지 스타일 */
  .product-item:hover img {
    transform: scale(1.05);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
  }

  /* 상품 이름과 가격을 감싸는 정보 영역 */
  .product-info {
    flex: 1;
  }

  /* 상품 이름 스타일 */
  .product-name {
    font-size: 1.2rem;
    font-weight: 700;
    color: #2c3e50;
    margin-bottom: 8px;
    line-height: 1.3;
  }

  /* 상품 가격 스타일 */
  .product-price {
    font-size: 1.1rem;
    font-weight: 600;
    color: #e74c3c;
    background: linear-gradient(135deg, #ff6b6b, #ee5a24);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }

  /* 스크롤바 전체 스타일 (크롬, 사파리 등 Webkit 계열 브라우저용) */
  #content::-webkit-scrollbar {
    width: 8px;
  }

  /* 스크롤바의 배경(트랙) 스타일 */
  #content::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 10px;
  }

  /* 스크롤바의 핸들(움직이는 막대) 스타일 */
  #content::-webkit-scrollbar-thumb {
    background: linear-gradient(135deg, #667eea, #764ba2);
    border-radius: 10px;
  }

  /* 스크롤바 핸들에 마우스를 올렸을 때 스타일 */
  #content::-webkit-scrollbar-thumb:hover {
    background: linear-gradient(135deg, #764ba2, #667eea);
  }

  /* 카카오맵 InfoWindow 기본 스타일 오버라이드 */
  .info-window::before,
  .info-window::after {
    display: none !important;
  }

  /* 카카오맵 InfoWindow 전체 스타일 오버라이드 */
  .kakao-maps-info-window,
  .kakao-maps-info-window *,
  .info-window,
  .info-window * {
    border: none !important;
    outline: none !important;
    box-shadow: none !important;
  }

  /* InfoWindow 컨테이너 스타일 */
  .kakao-maps-info-window {
    background: white !important;
    border-radius: 12px !important;
    padding: 0 !important;
    border: none !important;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15) !important;
  }

  /* 카카오맵 InfoWindow 커스텀 스타일 */
  .info-window {
    background: white !important;
    border-radius: 12px !important;
    padding: 15px !important;
    color: #333 !important;
    min-width: 200px !important;
    max-width: 280px !important;
    border: none !important;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15) !important;
    position: relative !important;
  }

  /* 정보창 내부의 제목(h3) 스타일 */
  .info-window h3 {
    margin: 0 0 8px 0;
    font-size: 1.1rem;
    font-weight: 600;
    color: #2c3e50;
  }

  /* 정보창 내부의 가격 스타일 */
  .info-window .price {
    font-size: 1rem;
    font-weight: 600;
    color: #e74c3c;
    margin: 8px 0;
  }

  /* 정보창 내부의 이미지 스타일 */
  .info-window img {
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    margin-top: 10px;
    border: 1px solid #ddd;
  }

  /* 정보창 내부의 '클릭하여 자세히 보기' 힌트 스타일 */
  .info-window .click-hint {
    text-align: center;
    margin-top: 10px;
    font-size: 0.8rem;
    color: #999;
    font-style: italic;
  }

  /* 화면 너비가 768px 이하일 때 적용되는 반응형 디자인 */
  @media (max-width: 768px) {
    .category-buttons {
      flex-direction: column;
      align-items: center;
    }

    .category-btn {
      width: 200px;
    }

    .product-item {
      flex-direction: column;
      text-align: center;
      padding: 15px;
    }

    .product-item img {
      margin-right: 0;
      margin-bottom: 15px;
    }
  }
</style>

<div class="col-sm-10">
  <h1 class="page-title">주변 상품 탐색</h1>

  <div class="category-buttons">
    <button id="cate_all_btn" class="category-btn active">전체</button>
    <button id="cate_1_btn" class="category-btn">전자기기</button>
    <button id="cate_2_btn" class="category-btn">생활용품</button>
    <button id="cate_3_btn" class="category-btn">가구</button>
    <button id="cate_4_btn" class="category-btn">의류</button>
    <button id="cate_5_btn" class="category-btn">도서</button>
    <button id="cate_6_btn" class="category-btn">스포츠/레저</button>
    <button id="cate_7_btn" class="category-btn">기타</button>
  </div>

  <div class="row">
    <div class="col-sm-8 col-lg-6">
      <div id="map"></div>
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

      // 카테고리 버튼 이벤트 리스너
      $('.category-btn').click((e) => {
        // 모든 버튼에서 active 클래스 제거
        $('.category-btn').removeClass('active');
        // 클릭된 버튼에 active 클래스 추가
        $(e.target).addClass('active');

        // 카테고리 ID 추출 및 설정
        const btnId = e.target.id;
        if (btnId === 'cate_all_btn') {
          this.category = null;
        } else {
          this.category = parseInt(btnId.replace('cate_', '').replace('_btn', ''));
        }

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

          // 깔끔한 InfoWindow HTML 구조
          let iwContent = `
            <div class="info-window">
              <h3>\${item.productName}</h3>
              <div class="price">\${item.productPrice.toLocaleString()}원</div>`;

          if(item.productImg) {
            iwContent += `
              <img src="<c:url value='/imgs/\${item.productImg}'/>" width="100" alt="\${item.productName}">`;
          }

          iwContent += `
              <div class="click-hint">
                클릭하여 자세히 보기
              </div>
            </div>`;

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
          result += `<img src="<c:url value='/imgs/\${item.productImg}'/>" alt="\${item.productName}">`;
        } else {
          // 이미지가 없을 경우 기본 이미지 표시
          result += `<img src="<c:url value='/imgs/default.png'/>" alt="기본 이미지">`;
        }

        result += `<div class="product-info">
                     <div class="product-name">\${item.productName}</div>
                     <div class="product-price">\${item.productPrice.toLocaleString()}원</div>
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
