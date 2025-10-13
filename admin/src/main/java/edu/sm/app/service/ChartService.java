package edu.sm.app.service;

import edu.sm.app.dto.DailyLoginDTO;
import edu.sm.app.repository.ChartRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ChartService {

    private final ChartRepository chartRepository;

    public List<DailyLoginDTO> getDailyLoginStats() {
        return chartRepository.selectDailyLoginStats();
    }
}
