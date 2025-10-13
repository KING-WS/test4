package edu.sm.controller;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.DailyLoginDTO;
import edu.sm.app.service.ChartService;
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

    @RequestMapping("/")
    public String main(Model model) {
        model.addAttribute("sseUrl", sseUrl);
        return "index";
    }

    @RequestMapping("/chart")
    public String chart(Model model) {
        List<DailyLoginDTO> dailyLoginStats = chartService.getDailyLoginStats();
        ObjectMapper objectMapper = new ObjectMapper();
        String chartData = "";
        try {
            chartData = objectMapper.writeValueAsString(dailyLoginStats);
        } catch (JsonProcessingException e) {
            log.error("Error converting chart data to JSON", e);
        }
        model.addAttribute("chartData", chartData);
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