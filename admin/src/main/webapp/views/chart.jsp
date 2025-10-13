<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    $(()=>{
        // --- Function to update product count --- //
        const updateProductCount = () => {
            fetch('/api/products/count?_=' + new Date().getTime())
                .then(response => response.json())
                .then(data => {
                    document.getElementById('total-products-count').innerText = data;
                })
                .catch(error => console.error('Error fetching product count:', error));
        };

        // --- Initial Load and Interval --- //
        updateProductCount(); // Initial call
        setInterval(updateProductCount, 5000); // Refresh every 5 seconds

        // --- 1. 일별 접속자 수 (Line Chart) --- //
        const lineChartData = JSON.parse('${lineChartData}');
        const lineCategories = lineChartData.map(item => item.loginDay);
        const lineData = lineChartData.map(item => item.userCount);

        Highcharts.chart('line-chart-container', {
            chart: { type: 'areaspline' },
            title: { text: '일별 접속자 수' },
            xAxis: {
                categories: lineCategories,
                title: { text: '날짜' }
            },
            yAxis: {
                min: 0,
                title: { text: '접속자 수 (명)' }
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
                    color: '#4e73df',
                    fillColor: {
                        linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                        stops: [
                            [0, '#4e73df'],
                            [1, 'rgba(78, 115, 223, 0)']
                        ]
                    },
                    threshold: null,
                    marker: { lineWidth: 1, lineColor: null, fillColor: 'white' }
                }
            },
            series: [{
                name: '일별 접속자',
                data: lineData
            }]
        });

        // --- 2. 카테고리별 상품 수 (Pie Chart) --- //
        const pieChartData = JSON.parse('${pieChartData}');
        const pieData = pieChartData.map(item => ({
            name: item.categoryName,
            y: item.productCount
        }));

        Highcharts.chart('pie-chart-container', {
            chart: {
                type: 'pie'
            },
            title: {
                text: '카테고리별 상품 수'
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b> ({point.y}개)'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                    }
                }
            },
            series: [{
                name: '상품 수',
                colorByPoint: true,
                data: pieData
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
    <div class="row d-none d-md-flex">

        <!-- Earnings (Monthly) Card Example -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                오늘의 접속자 수</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${todayVisitorCount}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-users fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Total Products Card -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Total Products</div>
                            <div id="total-products-count" class="h5 mb-0 font-weight-bold text-gray-800">${totalProducts}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-box fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Most Reported User Card -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-danger shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">
                                신고 최다 유저</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${mostReportedUser}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-bomb fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Pending Requests Card Example -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                신고 접수</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${pendingReportCount}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-flag fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Content Row -->
    <div class="row">

        <!-- Area Chart -->
        <div class="col-xl-8 col-lg-7">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">일별 접속자 수</h6>
                </div>
                <div class="card-body">
                    <div id="line-chart-container" style="width:100%; height:400px;"></div>
                </div>
            </div>
        </div>

        <!-- Pie Chart -->
        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">카테고리별 상품 수</h6>
                </div>
                <div class="card-body">
                    <div id="pie-chart-container" style="width:100%; height:400px;"></div>
                </div>
            </div>
        </div>
    </div>

</div>
