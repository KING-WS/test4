
package edu.sm.controller;

import edu.sm.app.dto.ChatMessage;
import edu.sm.app.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/chat")
public class ChatRestController {

    @Autowired
    private ChatService chatService;

    @GetMapping("/history")
    public List<ChatMessage> getHistory(@RequestParam String user1, @RequestParam String user2) {
        return chatService.getChatHistory(user1, user2);
    }
}
