package edu.sm.controller;

import edu.sm.app.dto.ChatMessage;
import edu.sm.app.msg.Msg;
import edu.sm.app.service.ChatService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
@Slf4j
@Controller
public class MsgController {
    @Autowired
    SimpMessagingTemplate template;

    @Autowired
    ChatService chatService;

    @MessageMapping("/receiveall") // 모두에게 전송
    public void receiveall(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        System.out.println(msg);
        template.convertAndSend("/send",msg);
    }
    @MessageMapping("/receiveme") // 나에게만 전송 ex)Chatbot
    public void receiveme(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        System.out.println(msg);

        String id = msg.getSendid();
        template.convertAndSend("/send/"+id,msg);
    }
    @MessageMapping("/receiveto") // 특정 Id에게 전송
    public void receiveto(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        String id = msg.getSendid();
        String target = msg.getReceiveid();

        // Create ChatMessage object and save to database via ChatService
        ChatMessage chatMessage = new ChatMessage();
        chatMessage.setSenderId(msg.getSendid());
        chatMessage.setReceiverId(msg.getReceiveid());
        chatMessage.setContent(msg.getContent1());
        chatMessage.setProductId(msg.getProductId());
        chatService.insertMessage(chatMessage);

        log.info("-------------------------");
        log.info(target);

        template.convertAndSend("/send/to/"+target,msg);
    }
}