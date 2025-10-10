package edu.sm.common.frame;

import edu.sm.app.msg.Msg;
import edu.sm.app.dto.ChatRoom;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 채팅 관련 데이터베이스 작업을 위한 MyBatis Mapper 인터페이스
 * 이 인터페이스의 메서드를 호출하면 ChatMapper.xml의 SQL이 실행됩니다.
 */
@Mapper // Spring Boot가 이 인터페이스를 MyBatis 매퍼로 인식하도록 합니다.
public interface ChatMapper {

    /**
     * 두 참여자의 ID를 이용해 채팅방 정보를 조회합니다.
     * @param user1Id 참여자1 ID
     * @param user2Id 참여자2 ID
     * @return 조회된 채팅방 정보 객체, 없으면 null
     */
    ChatRoom findRoomByParticipants(@Param("user1Id") String user1Id, @Param("user2Id") String user2Id);

    /**
     * 새로운 채팅방을 데이터베이스에 생성합니다.
     * useGeneratedKeys 설정에 의해 chatRoom 객체의 roomId 필드에 생성된 ID가 채워집니다.
     * @param chatRoom 생성할 채팅방 정보 객체
     */
    void createRoom(ChatRoom chatRoom);

    /**
     * 새로운 메시지를 데이터베이스에 저장합니다.
     * @param message 저장할 메시지 정보 객체
     */
    void saveMessage(Msg message);

    /**
     * 특정 채팅방에 속한 모든 메시지를 시간순으로 정렬하여 조회합니다.
     * @param roomId 메시지를 조회할 채팅방의 ID (long 타입)
     * @return 메시지 객체 리스트
     */
    List<Msg> findMessagesByRoomId(long roomId);

    /**
     * roomId를 이용하여 채팅방 정보를 조회합니다. (보안 확인용)
     * @param roomId 조회할 채팅방의 ID
     * @return 조회된 채팅방 정보 객체, 없으면 null
     */
    ChatRoom findRoomById(long roomId);
}