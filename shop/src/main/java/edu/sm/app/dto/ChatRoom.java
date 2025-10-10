package edu.sm.app.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor // MyBatis가 객체를 생성할 때 필요한 기본 생성자
public class ChatRoom {

    // INT(BIGINT) 타입으로 변경한 최종 설계에 맞춘 필드들

    private int roomId;      // 채팅방 고유 ID (DB에서 자동 생성된 숫자)
    private String user1Id;   // 참여자 1
    private String user2Id;   // 참여자 2

    // Service에서 새로운 방을 생성할 때 사용할 생성자
    public ChatRoom(String user1Id, String user2Id) {
        this.user1Id = user1Id;
        this.user2Id = user2Id;
    }
}