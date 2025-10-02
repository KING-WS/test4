package edu.sm.app.service;

import edu.sm.app.dto.ChatWaitSession;
import edu.sm.app.repository.ChatWaitSessionRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatWaitSessionService implements SmService<ChatWaitSession, Integer> {

    private final ChatWaitSessionRepository repository;

    @Override
    public void register(ChatWaitSession chatWaitSession) throws Exception {
        repository.insert(chatWaitSession);
    }

    @Override
    public void modify(ChatWaitSession chatWaitSession) throws Exception {
        repository.update(chatWaitSession);
    }

    @Override
    public void remove(Integer integer) throws Exception {
        repository.delete(integer);
    }

    @Override
    public ChatWaitSession get(Integer integer) throws Exception {
        return repository.select(integer);
    }

    @Override
    public List<ChatWaitSession> get() throws Exception {
        return repository.selectAll();
    }

    public ChatWaitSession getByCustId(String custId) throws Exception {
        return repository.selectByCustId(custId);
    }

    public List<ChatWaitSession> getByStatus(String status) throws Exception {
        return repository.selectByStatus(status);
    }

    public List<ChatWaitSession> getByAdminIdAndStatus(String adminId, String status) throws Exception {
        return repository.selectByAdminIdAndStatus(adminId, status);
    }

    public void claimSession(int sessionId, String adminId) throws Exception {
        repository.updateAdmin(sessionId, adminId);
    }
}
