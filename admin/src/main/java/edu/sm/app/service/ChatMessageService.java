package edu.sm.app.service;

import edu.sm.app.dto.ChatMessage;
import edu.sm.app.repository.ChatMessageRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatMessageService implements SmService<ChatMessage, Integer> {

    private final ChatMessageRepository chatMessageRepository;

    @Override
    public void register(ChatMessage chatMessage) throws Exception {
        chatMessageRepository.insert(chatMessage);
    }

    @Override
    public void modify(ChatMessage chatMessage) throws Exception {
        chatMessageRepository.update(chatMessage);
    }

    @Override
    public void remove(Integer integer) throws Exception {
        chatMessageRepository.delete(integer);
    }

    @Override
    public ChatMessage get(Integer integer) throws Exception {
        return chatMessageRepository.select(integer);
    }

    @Override
    public List<ChatMessage> get() throws Exception {
        return chatMessageRepository.selectAll();
    }

    public List<ChatMessage> getHistory(String sendId, String receiveId) throws Exception {
        return chatMessageRepository.selectAllByUser(sendId, receiveId);
    }
}
