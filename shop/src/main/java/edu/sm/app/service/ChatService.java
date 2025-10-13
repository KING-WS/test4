
package edu.sm.app.service;

import edu.sm.app.dto.ChatMessage;
import edu.sm.app.repository.ChatRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
public class ChatService {

    @Autowired
    ChatRepository chatRepository;

    @Transactional
    public void insertMessage(ChatMessage message) {
        log.info("Saving message to DB: {}", message);
        chatRepository.insertMessage(message);
    }

    public List<String> getChatPartners(String userId) {
        return chatRepository.getChatPartners(userId);
    }

    public List<ChatMessage> getChatHistory(String user1, String user2) {
        return chatRepository.getChatHistory(user1, user2);
    }
}
