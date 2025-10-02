package edu.sm.app.repository;

import edu.sm.app.dto.ChatWaitSession;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface ChatWaitSessionRepository extends SmRepository<ChatWaitSession, Integer> {
    ChatWaitSession selectByCustId(String custId) throws Exception;
    List<ChatWaitSession> selectByStatus(String status) throws Exception;
    List<ChatWaitSession> selectByAdminIdAndStatus(String adminId, String status) throws Exception;
    void updateAdmin(int sessionId, String adminId) throws Exception;
}
