package edu.sm.controller;

import edu.sm.app.dto.ChatDot;
import edu.sm.app.dto.Cust;
import edu.sm.app.service.ChatService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Collections;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/chat")
public class ChatController {

    @Value("${app.url.websocketurl}")
    String webSocketUrl;

    String dir="chat/";

    @Autowired
    ChatService chatService;

    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center",dir+"center");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/chat1")
    public String chat1(Model model) throws Exception {
        model.addAttribute("websocketurl",webSocketUrl);
        model.addAttribute("center",dir+"chat1");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/chat2")
    public String chat2(Model model) {
        model.addAttribute("websocketurl",webSocketUrl);
        model.addAttribute("center",dir+"chat2");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/chat3")
    public String map2(Model model) {
        model.addAttribute("websocketurl",webSocketUrl);
        model.addAttribute("center",dir+"chat3");
        model.addAttribute("left",dir+"left");
        return "index";
    }

    @GetMapping("/list")
    public String chatList(Model model, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        String currentUserId = null;

        if (session != null && session.getAttribute("cust") != null) {
            Cust cust = (Cust) session.getAttribute("cust");
            currentUserId = cust.getCustId();
        }

        if (currentUserId == null) {
            log.error("Could not find user in session. Redirecting to login.");
            return "redirect:/login";
        }

        log.info("Fetching chat partners for user: {}", currentUserId);

        List<ChatDot> chatPartners = chatService.getChatPartners(currentUserId);
        log.info("Found {} chat partners.", chatPartners.size());

        model.addAttribute("chatPartners", chatPartners);
        model.addAttribute("center", "chat/list");
        model.addAttribute("left", "blank"); // Set to a blank view
        return "index";
    }

    @GetMapping("/modal_view")
    public String chatModal(Model model) {
        model.addAttribute("websocketurl", webSocketUrl);
        return "chat/chat_modal";
    }
}