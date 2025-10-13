package edu.sm.app.repository;

import edu.sm.app.dto.Report;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface ReportRepository extends SmRepository<Report, Integer> {
    int selectCount();
}
