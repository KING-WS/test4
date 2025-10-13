package edu.sm.app.service;

import edu.sm.app.dto.Report;

import edu.sm.app.repository.ReportRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;



import java.util.List;



@Service

@RequiredArgsConstructor

public class ReportService {



    private final ReportRepository reportRepository;



    public List<Report> get() throws Exception {

        return reportRepository.selectAll();

    }



    public int getReportCount() {

        return reportRepository.selectCount();

    }

}
