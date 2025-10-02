package edu.sm.app.repository;

import edu.sm.app.dto.ChatMessage;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface ChatMessageRepository extends SmRepository<ChatMessage, Integer> {
    List<ChatMessage> selectAllByUser(String sendId, String receiveId) throws Exception;
}
