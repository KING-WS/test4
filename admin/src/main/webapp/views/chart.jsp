<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 로그 파일 URL (정적 매핑: /logs/** -> LOGS_DIR) --%>
<c:url var="log1" value="/logs/maininfo.log"/>
<c:url var="log2" value="/logs/maininfo1.log"/>
<c:url var="log3" value="/logs/maininfo2.log"/>
<c:url var="log4" value="/logs/maininfo3.log"/>

<div class="row">
    <div class="col-xl-6 col-lg-6">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Live Data 1</h6>
            </div>
            <div class="card-body">
                <div id="container1" style="height: 300px;"></div>
            </div>
        </div>
    </div>

    <div class="col-xl-6 col-lg-6">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Live Data2</h6>
            </div>
            <div class="card-body">
                <div id="container2" style="height: 300px;"></div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-xl-6 col-lg-6">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Live Data 3</h6>
            </div>
            <div class="card-body">
                <div id="container3" style="height: 300px;"></div>
            </div>
        </div>
    </div>

    <div class="col-xl-6 col-lg-6">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Live Data 4</h6>
            </div>
            <div class="card-body">
                <div id="container4" style="height: 300px;"></div>
            </div>
        </div>
    </div>
</div>

<script>
    // index.jsp에서 Highcharts + window.LiveChart 가 로드된 뒤 실행되도록 load 이벤트 사용
    window.addEventListener('load', () => {
        // 각각 "다른 차트 타입"으로 호출 예시
        // 타입 후보: 'areaspline', 'line', 'spline', 'column', 'area', 'bar', 'scatter' 등
        LiveChart.start({
            containerId: 'container1',
            url: '${log1}',
            seriesName: 'Live Data 1',
            type: 'areaspline',
            yTitle: ''
        });

        LiveChart.start({
            containerId: 'container2',
            url: '${log2}',
            seriesName: 'Live Data2',
            type: 'column',       // 로그인 로그는 막대형으로
            yTitle: ''
        });

        LiveChart.start({
            containerId: 'container3',
            url: '${log3}',
            seriesName: 'Live Data 3',
            type: 'line',         // 라인 차트
            yTitle: ''
        });

        LiveChart.start({
            containerId: 'container4',
            url: '${log4}',
            seriesName: 'Live Data 4',
            type: 'spline',       // 스플라인
            yTitle: ''
        });
    });
</script>

<script>
    // 전역 헬퍼: 모든 JSP에서 재사용
    window.LiveChart = (function () {
        function parseLogText(text) {
            if (!text) return [];
            const lines = text.trim().split(/\r?\n/);
            const pts = [];
            for (const line of lines) {
                const idx = line.indexOf(',');
                if (idx < 0) continue;
                const tsStr = line.slice(0, idx).trim();   // "YYYY-MM-DD HH:mm:ss"
                const valStr = line.slice(idx + 1).trim(); // "123"
                const t = Date.parse(tsStr.replace(' ', 'T')); // 로컬시간 파싱
                const y = Number(valStr);
                if (Number.isFinite(t) && Number.isFinite(y)) pts.push([t, y]);
            }
            return pts;
        }

        async function fetchLog(url) {
            const res = await fetch(url, { cache: 'no-store' });
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return await res.text();
        }

        // type: 'areaspline' | 'line' | 'spline' | 'column' | 'area' ...
        async function start({ containerId, url, seriesName, type = 'areaspline', yTitle = '' }) {
            const chart = Highcharts.chart(containerId, {
                chart: { type: type,
                    backgroundColor: '#FFFFFF',      // 전체 배경색
                    plotBackgroundColor: '#FAFAFA',  // 그래프가 그려지는 영역의 배경색
                    borderColor: '#00FD59FF',          // 전체 차트 테두리 색상
                    borderWidth: 1                   // 테두리 두께
                     },
                title: { text: null },
                xAxis: { type: 'datetime' },
                yAxis: { title: { text: yTitle || null } },
                legend: { enabled: false },
                credits: { enabled: false },
                tooltip: { xDateFormat: '%Y-%m-%d %H:%M:%S' },
                series: [{ name: seriesName, data: [] }]
            });

            async function tick() {
                try {
                    const text = await fetchLog(url);
                    const points = parseLogText(text);
                    chart.series[0].setData(points, true, false, false);
                } catch (e) {
                    // 파일 없거나 롤링 중일 수 있음 → 조용히 스킵
                } finally {
                    setTimeout(tick, 2000); // 2초마다 갱신
                }
            }
            tick();
            return chart;
        }

        return { start };
    })();
</script>
