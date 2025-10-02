package edu.sm.controller;

import edu.sm.app.dto.Admin;
import edu.sm.app.service.AdminService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Slf4j
@RequiredArgsConstructor
public class LoginController {

    final AdminService adminService;
    final BCryptPasswordEncoder bCryptPasswordEncoder;

    @RequestMapping("/loginimpl")
    public String loginimpl(Model model, @RequestParam("id") String id,
                            @RequestParam("pwd") String pwd,
                            HttpSession httpSession) throws Exception {
        Admin dbAdmin = adminService.get(id);
        if (dbAdmin != null && bCryptPasswordEncoder.matches(pwd, dbAdmin.getAdminPwd())) {
            httpSession.setAttribute("admin", dbAdmin);
            return "redirect:/";
        }
        // You can add an attribute to the model to show a login failure message.
        // model.addAttribute("loginError", "Invalid credentials");
        return "redirect:/";
    }

    @RequestMapping("/logoutimpl")
    public String logout(HttpSession httpSession) {
        if (httpSession != null) {
            httpSession.invalidate();
        }
        return "redirect:/";
    }
}
