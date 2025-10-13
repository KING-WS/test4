package edu.sm.controller;

import com.github.pagehelper.PageInfo;
import edu.sm.app.dto.Cust;
import edu.sm.app.dto.CustSearch;
import edu.sm.app.service.CustService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import edu.sm.app.service.ReportService;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@Slf4j
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportController {

    String dir="report/";
    final ReportService reportService;


    @RequestMapping("/get")
    public String get(Model model) throws Exception {
        List<edu.sm.app.dto.Report> rlist = reportService.get();
        model.addAttribute("report", rlist);
        model.addAttribute("center",dir+"get");
        return "index";
    }
}
