package edu.sm.controller;
import edu.sm.app.msg.Msg;
import edu.sm.app.service.ChatService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController // 이 컨트롤러는 View(페이지)가 아닌 데이터(JSON)를 반환합니다.
@RequiredArgsConstructor
public class ChatRoomController {

    private final ChatService chatService;

    // 채팅방을 생성하거나 기존 방 번호를 반환하는 API
    @PostMapping("/api/chatroom")
    public long getOrCreateRoom(@RequestParam String partnerId, HttpSession session) {
        // 실제 내 아이디는 세션에서 안전하게 가져와야 합니다.
        // "loginId" 부분은 실제 세션에 저장한 이름으로 변경하세요.
        String myId = (String) session.getAttribute("loginId");
        return chatService.findOrCreateRoom(myId, partnerId);
    }

    // 특정 채팅방의 메시지를 가져오는 API
    @GetMapping("/api/chatroom/{roomId}/messages")
    public List<Msg> getRoomMessages(@PathVariable long roomId, HttpSession session) {
        String myId = (String) session.getAttribute("loginId");
        return chatService.getMessages(roomId, myId);
    }
}