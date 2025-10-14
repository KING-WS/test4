package edu.sm.controller;

import edu.sm.app.dto.ChatDot;
import edu.sm.app.service.ChatService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
public class AdminRestController {

    @Autowired
    private ChatService chatService;

    @GetMapping("/api/admin/chat/partners")
    public List<ChatDot> getAdminChatPartners() {
        log.info("### API CALL: /api/admin/chat/partners");
        List<ChatDot> partners = chatService.getChatPartners("admin");
        if (partners != null) {
            log.info("### Service returned {} partners.", partners.size());
        } else {
            log.warn("### Partner list is NULL.");
        }
        return partners;
    }
}
