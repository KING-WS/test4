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
public class AdminMsgController {
    @Autowired
    SimpMessagingTemplate template;

    @Autowired
    ChatService chatService;

    @MessageMapping("/adminreceiveto") // 특정 Id에게 전송
    public void adminreceiveto(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        String id = msg.getSendid();
        String target = msg.getReceiveid();
        log.info("-------------------------1");
        log.info(target);

        // DB에 메시지 저장하는 로직 추가
        ChatMessage chatMessage = new ChatMessage();
        chatMessage.setSenderId(msg.getSendid());
        chatMessage.setReceiverId(msg.getReceiveid());
        chatMessage.setContent(msg.getContent1());
        chatService.insertMessage(chatMessage);

        template.convertAndSend("/adminsend/to/"+target,msg);
        log.info("-------------------------2");

    }
}