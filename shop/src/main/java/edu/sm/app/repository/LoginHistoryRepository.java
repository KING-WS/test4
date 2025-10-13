package edu.sm.app.repository;

import edu.sm.app.dto.LoginHistory;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface LoginHistoryRepository {
    void insert(LoginHistory loginHistory);
}
