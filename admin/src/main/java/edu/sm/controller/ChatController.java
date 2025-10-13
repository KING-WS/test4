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
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@Slf4j
@RequestMapping("/chat")
@RequiredArgsConstructor
public class ChatController {

    String dir="chat/";

    @RequestMapping("/report")
    public String report(Model model) {
        model.addAttribute("center",dir+"report");
        return "index";
    }

    @RequestMapping("/get")
    public String get(Model model) {
        model.addAttribute("center",dir+"get");
        return "index";
    }
}
