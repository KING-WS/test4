// Chart3.jsp 에 만들엇슴

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #container{
    width:500px;
    border: 2px solid red;
  }
</style>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  .chart-container {
    width: 48%;
    border: 1px solid #ddd;
    display: inline-block;
  }
</style>
<script>
  let chart3 = {
    init: function () {
      this.getdata();
    },
    getdata: function () {
      $.ajax({
        url: '<c:url value="/chart/phonesales"/>',
        success: (data) => {
          this.displayTotal(data.totalSalesSeries);
          this.displayAverage(data.averageSalesSeries);
        }
      });
    },
    displayTotal: function (seriesData) {
      Highcharts.chart('containerTotal', {
        chart: {
          type: 'line'
        },
        title: {
          text: '브랜드별 월별 매출 합계'
        },
        xAxis: {
          categories: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
        },
        yAxis: {
          title: {
            text: '매출 합계 (원)'
          }
        },
        plotOptions: {
          line: {
            dataLabels: {
              enabled: true
            },
            enableMouseTracking: false
          }
        },
        series: seriesData
      });
    },
    displayAverage: function (seriesData) {
      Highcharts.chart('containerAverage', {
        chart: {
          type: 'line'
        },
        title: {
          text: '브랜드별 월별 매출 평균'
        },
        xAxis: {
          categories: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
        },
        yAxis: {
          title: {
            text: '매출 평균 (원)'
          }
        },
        plotOptions: {
          line: {
            dataLabels: {
              enabled: true
            },
            enableMouseTracking: false
          }
        },
        series: seriesData
      });
    }
  }
  $(function () {
    chart3.init();
  });
</script>

<div class="col-sm-10">
  <h2>브랜드별 월별 매출 분석</h2>
  <div id="containerTotal" class="chart-container"></div>
  <div id="containerAverage" class="chart-container"></div>
</div>


<div class="col-sm-10">
  <h2>브랜드별 월별 매출</h2>
  <div id="container"></div>

</div>