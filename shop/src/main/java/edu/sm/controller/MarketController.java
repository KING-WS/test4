package edu.sm.controller;

import edu.sm.app.dto.Cate;
import edu.sm.app.dto.Product;
import edu.sm.app.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@Slf4j
@RequestMapping("/market")
@RequiredArgsConstructor
public class MarketController {

    final ProductService productService;
    String dir="market/";

    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center",dir+"center");
        model.addAttribute("left",dir+"left");
        return "index";
    }

    @RequestMapping("/add")
    public String add(Model model) throws Exception {
        List<Cate> cateList = productService.getAllCate();
        model.addAttribute("cateList", cateList);
        model.addAttribute("center",dir+"add");
        model.addAttribute("left",dir+"left");
        return "index";
    }

    @RequestMapping("/registerimpl")
    public String registerimpl(Model model, Product product) throws Exception {
        productService.register(product);
        return "redirect:/market/map5";
    }

    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam("id") int id) throws Exception {
        Product product = productService.get(id);
        model.addAttribute("p", product);
        model.addAttribute("left", dir+"left");
        model.addAttribute("center", dir+"view");
        return "index";
    }

    @RequestMapping("/map5")
    public String map5(Model model) {
        model.addAttribute("center",dir+"map5");
        model.addAttribute("left",dir+"left");
        return "index";
    }
}
