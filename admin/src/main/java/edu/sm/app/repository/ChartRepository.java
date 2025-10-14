package edu.sm.app.repository;

import edu.sm.app.dto.CategoryProductCountDTO;
import edu.sm.app.dto.DailyLoginDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface ChartRepository {
    List<DailyLoginDTO> selectDailyLoginStats();
    List<CategoryProductCountDTO> selectProductCountByCategory();
}
