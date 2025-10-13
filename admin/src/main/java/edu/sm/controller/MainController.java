package edu.sm.controller;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.CategoryProductCountDTO;
import edu.sm.app.dto.DailyLoginDTO;
import edu.sm.app.service.ChartService;
import edu.sm.app.repository.ProductRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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
    private final ProductRepository productRepository;

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

        int totalProducts = 0;
        try {
            totalProducts = productRepository.countAll();
        } catch (Exception e) {
            log.error("Error getting total products count", e);
        }

        model.addAttribute("totalProducts", totalProducts);
        model.addAttribute("lineChartData", lineChartData);
        model.addAttribute("pieChartData", pieChartData);
        model.addAttribute("center","chart");
        return "index";
    }

    @RequestMapping("/api/products/count")
    @ResponseBody
    public int getProductCount() {
        int totalProducts = 0;
        try {
            totalProducts = productRepository.countAll();
        } catch (Exception e) {
            log.error("Error getting total products count", e);
        }
        return totalProducts;
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