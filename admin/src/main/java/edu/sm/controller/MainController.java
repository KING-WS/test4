package edu.sm.controller;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.CategoryProductCountDTO;
import edu.sm.app.dto.DailyLoginDTO;
import edu.sm.app.service.ChartService;
import edu.sm.app.service.ReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor
public class MainController {

    @Value("${app.url.sse}")
    String sseUrl;
    @Value("${app.url.websocketurl}")
    String websocketurl;

    private final ChartService chartService;
    private final ReportService reportService;

    @RequestMapping("/")
    public String main(Model model) {
        ObjectMapper objectMapper = new ObjectMapper();

        // Data for Line Chart
        List<DailyLoginDTO> dailyLoginStats = chartService.getDailyLoginStats();
        String lineChartData = "[]";
        try {
            lineChartData = objectMapper.writeValueAsString(dailyLoginStats);
        } catch (JsonProcessingException e) {
            log.error("Error converting line chart data to JSON", e);
        }

        // Data for Pie Chart
        List<CategoryProductCountDTO> productCountByCategory = chartService.getProductCountByCategory();
        String pieChartData = "[]";
        try {
            pieChartData = objectMapper.writeValueAsString(productCountByCategory);
        } catch (JsonProcessingException e) {
            log.error("Error converting pie chart data to JSON", e);
        }

        model.addAttribute("lineChartData", lineChartData);
        model.addAttribute("pieChartData", pieChartData);

        int todayVisitorCount = 0;
        if (dailyLoginStats != null && !dailyLoginStats.isEmpty()) {
            todayVisitorCount = dailyLoginStats.get(dailyLoginStats.size() - 1).getUserCount();
        }
        model.addAttribute("todayVisitorCount", todayVisitorCount);

        int pendingReportCount = reportService.getReportCount();
        model.addAttribute("pendingReportCount", pendingReportCount);

        String mostReportedUser = reportService.getMostReportedUser();
        model.addAttribute("mostReportedUser", mostReportedUser);

        model.addAttribute("center","chart");
        return "index";
    }

    @RequestMapping("/chart")
    public String chart(Model model) {
        ObjectMapper objectMapper = new ObjectMapper();

        // Data for Line Chart
        List<DailyLoginDTO> dailyLoginStats = chartService.getDailyLoginStats();
        String lineChartData = "[]";
        try {
            lineChartData = objectMapper.writeValueAsString(dailyLoginStats);
        } catch (JsonProcessingException e) {
            log.error("Error converting line chart data to JSON", e);
        }

        // Data for Pie Chart
        List<CategoryProductCountDTO> productCountByCategory = chartService.getProductCountByCategory();
        String pieChartData = "[]";
        try {
            pieChartData = objectMapper.writeValueAsString(productCountByCategory);
        } catch (JsonProcessingException e) {
            log.error("Error converting pie chart data to JSON", e);
        }

        model.addAttribute("lineChartData", lineChartData);
        model.addAttribute("pieChartData", pieChartData);
        model.addAttribute("center","chart");
        return "index";
    }
    @RequestMapping("/chat")
    public String chat(Model model) {
        model.addAttribute("websocketurl",websocketurl);
        model.addAttribute("center","chat");
        return "index";
    }
    @RequestMapping("/websocket")
    public String websocket(Model model) {
        model.addAttribute("websocketurl",websocketurl);
        model.addAttribute("center","websocket");
        return "index";
    }

}
