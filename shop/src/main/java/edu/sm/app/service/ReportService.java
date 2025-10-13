package edu.sm.app.service;

import edu.sm.app.dto.Report;
import edu.sm.app.repository.ReportRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReportService implements SmService<Report, Integer> {

    final ReportRepository reportRepository;

    @Override
    public void register(Report report) throws Exception {
        // Repository를 호출하여 DB에 데이터를 삽입합니다.
        reportRepository.insert(report);
    }

    // 아래 메소드들은 SmService 인터페이스에 의해 요구되지만,
    // 이번 기능에서는 사용되지 않으므로 비워둡니다.
    @Override
    public void modify(Report report) throws Exception {}

    @Override
    public void remove(Integer integer) throws Exception {}

    @Override
    public Report get(Integer integer) throws Exception {
        return null;
    }

    @Override
    public List<Report> get() throws Exception {
        return null;
    }
}
