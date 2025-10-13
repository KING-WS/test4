package edu.sm.app.service;

import edu.sm.app.dto.LoginHistory;
import edu.sm.app.repository.LoginHistoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LoginHistoryService {

    private final LoginHistoryRepository loginHistoryRepository;

    public void addLoginHistory(String custId) {
        LoginHistory loginHistory = new LoginHistory();
        loginHistory.setCustId(custId);
        loginHistoryRepository.insert(loginHistory);
    }
}
