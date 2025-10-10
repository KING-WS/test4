package edu.sm.app.service;

import edu.sm.app.msg.Msg;
import edu.sm.app.dto.ChatRoom;
import edu.sm.common.frame.ChatMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor // final 필드에 대한 생성자를 자동으로 만들어줍니다.
public class ChatService {

    // Service는 Mapper를 사용해서 DB 작업을 수행합니다.
    private final ChatMapper chatMapper;

    /**
     * 두 사용자 간의 채팅방을 찾거나, 없으면 새로 생성합니다.
     * 이전에 우리가 완성한 로직입니다.
     * @param myId 나의 ID
     * @param partnerId 상대방 ID
     * @return 방 번호 (roomId)
     */
    @Transactional // 두 개 이상의 DB 작업이 하나의 단위처럼 동작하게 함
    public long findOrCreateRoom(String myId, String partnerId) {
        ChatRoom room = chatMapper.findRoomByParticipants(myId, partnerId);

        if (room != null) {
            return room.getRoomId();
        } else {
            ChatRoom newRoom = new ChatRoom(myId, partnerId);
            chatMapper.createRoom(newRoom);
            return newRoom.getRoomId();
        }
    }

    /**
     * 특정 방의 메시지를 가져옵니다. (권한 확인 로직 포함)
     * @param roomId 방 번호
     * @param memberId 현재 로그인한 사용자 ID
     * @return 메시지 목록
     */
    public List<Msg> getMessages(long roomId, String memberId) {
        // 1. roomId로 채팅방 정보를 가져옵니다.
        ChatRoom room = chatMapper.findRoomById(roomId);

        // 2. [보안] 이 방의 참여자가 맞는지 확인합니다.
        if (room == null || (!room.getUser1Id().equals(memberId) && !room.getUser2Id().equals(memberId))) {
            throw new SecurityException("채팅방에 접근할 권한이 없습니다.");
        }

        // 3. 권한이 확인되면 메시지를 반환합니다.
        return chatMapper.findMessagesByRoomId(roomId);
    }

    /**
     * 메시지를 DB에 저장합니다.
     * @param message 저장할 메시지
     */
    public void saveMessage(Msg message) {
        chatMapper.saveMessage(message);
    }
}