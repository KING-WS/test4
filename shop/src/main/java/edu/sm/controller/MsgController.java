package edu.sm.controller;

import edu.sm.app.msg.Msg;

import edu.sm.app.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor // final 필드에 대한 생성자를 자동으로 만들어줍니다.
public class MsgController {

    // [변경점 1] "요리사(ChatService)"를 부를 수 있도록 준비합니다.
    private final ChatService chatService;
    private final SimpMessagingTemplate template;

    /**
     * 클라이언트가 '/chat/message'로 메시지를 보내면 이 메서드가 받아서 처리합니다.
     * 기존의 receiveall, receiveme, receiveto를 이 하나로 통합하여 사용합니다.
     */
    @MessageMapping("/chat/message")
    public void message(Msg message) {

        // [변경점 2] "웨이터"가 "요리사"에게 요리를 만들라고 지시합니다.
        // 즉, 컨트롤러가 서비스에게 "메시지를 DB에 저장해줘" 라고 요청합니다.
        chatService.saveMessage(message);

        // [변경점 3] 요리(DB 저장)가 끝난 메시지를 모든 손님에게 보여줍니다.
        // 해당 채팅방을 구독하고 있는 모든 클라이언트에게 메시지를 다시 보냅니다.
        // 프론트엔드에서는 '/topic/room/{roomId}'를 구독해야 합니다.
        template.convertAndSend("/topic/room/" + message.getRoomId(), message);
    }
}