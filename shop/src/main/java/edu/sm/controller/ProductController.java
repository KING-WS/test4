package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.dto.Product;
import edu.sm.app.service.ProductService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Slf4j
@RequestMapping("/product")
@RequiredArgsConstructor
public class ProductController {
    final ProductService productService;

    String dir="product/";

    @RequestMapping("/get")
    public String get(Model model) throws Exception {
        model.addAttribute("plist", productService.get());
        model.addAttribute("center", dir + "get");
        return "index";
    }

    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam("id") int id, HttpSession session) throws Exception {
        Cust cust = (Cust) session.getAttribute("cust");
        String custId = (cust != null) ? cust.getCustId() : null;

        Product product = productService.get(id, custId);
        model.addAttribute("p", product);
        model.addAttribute("center", dir + "detail");
        return "index";
    }
}
