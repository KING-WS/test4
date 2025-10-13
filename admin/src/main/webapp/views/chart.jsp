<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    $(()=>{
        // Controller에서 전달받은 JSON 데이터를 JavaScript 객체로 파싱
        const chartData = JSON.parse('${chartData}');

        // Highcharts에 사용할 데이터 형식으로 가공
        const categories = chartData.map(item => item.loginDay);
        const data = chartData.map(item => item.userCount);

        Highcharts.chart('container', {
            chart: {
                type: 'areaspline' // 채워진 꺾은선 그래프
            },
            title: {
                text: '일별 접속자 수' // 차트 제목
            },
            xAxis: {
                categories: categories,
                title: {
                    text: '날짜'
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: '접속자 수 (명)'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y} 명</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                areaspline: {
                    color: '#4e73df', // 기존 테마와 유사한 파란색 계열로 변경
                    fillColor: {
                        linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                        stops: [
                            [0, '#4e73df'],
                            [1, 'rgba(78, 115, 223, 0)']
                        ]
                    },
                    threshold: null,
                    marker: {
                        lineWidth: 1,
                        lineColor: null,
                        fillColor: 'white'
                    }
                }
            },
            series: [{
                name: '일별 접속자',
                data: data
            }]
        });
    });
</script>

<!-- Begin Page Content -->
<div class="container-fluid">

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">통계 대시보드</h1>
    </div>

    <!-- Content Row -->
    <div class="row">

        <!-- Daily Login Chart -->
        <div class="col-xl-12 col-lg-12">
            <div class="card shadow mb-4">
                <!-- Card Header -->
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">일별 접속자 수</h6>
                </div>
                <!-- Card Body -->
                <div class="card-body">
                    <div id="container" style="width:100%; height:400px;"></div>
                </div>
            </div>
        </div>

    </div>

</div>