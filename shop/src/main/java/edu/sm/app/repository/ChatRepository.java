
package edu.sm.app.repository;

import edu.sm.app.dto.ChatDot;
import edu.sm.app.dto.ChatMessage;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ChatRepository {
    void insertMessage(ChatMessage message);
    List<ChatMessage> getChatHistory(String userId1, String userId2);
    List<ChatDot> getChatPartners(String userId);
    void markAsRead(String receiverId, String senderId);
    int countUnreadMessages(String userId);
}
