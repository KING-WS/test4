
package edu.sm.app.repository;

import edu.sm.app.dto.ChatMessage;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ChatRepository {
    void insertMessage(ChatMessage message);
    List<ChatMessage> getChatHistory(String userId1, String userId2);
    List<String> getChatPartners(String userId);
}
