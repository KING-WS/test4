package edu.sm.controller;

import edu.sm.app.dto.Cate;
import edu.sm.app.dto.Product;
import edu.sm.app.service.ChatService;
import edu.sm.app.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import edu.sm.app.dto.Cust;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@Slf4j
@RequestMapping("/market")
@RequiredArgsConstructor
public class MarketController {

    final ProductService productService;
    final ChatService chatService;
    String dir="market/";

    @ModelAttribute("unreadChatCount")
    public int getUnreadChatCount(HttpSession session) {
        Cust cust = (Cust) session.getAttribute("cust");
        if (cust != null) {
            return chatService.countUnreadMessages(cust.getCustId());
        }
        return 0;
    }

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
    public String registerimpl(Model model, Product product, HttpSession session) throws Exception {
        Cust cust = (Cust) session.getAttribute("cust");
        if (cust != null) {
            product.setCustId(cust.getCustId());
        } else {
            // Optional: Handle case where user is not logged in, maybe redirect to login
            return "redirect:/login";
        }
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

    @RequestMapping("/myitems")
    public String myitems(Model model, HttpSession session) throws Exception {
        Cust cust = (Cust) session.getAttribute("cust");
        if (cust == null) {
            return "redirect:/login";
        }
        List<Product> list = productService.getMyItems(cust.getCustId());
        model.addAttribute("plist", list);
        model.addAttribute("center", dir+"myitems");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @RequestMapping("/edit")
    public String edit(Model model, @RequestParam("id") int id) throws Exception {
        Product product = productService.get(id);
        List<Cate> cateList = productService.getAllCate();
        model.addAttribute("p", product);
        model.addAttribute("cateList", cateList);
        model.addAttribute("left", dir+"left");
        model.addAttribute("center", dir+"edit");
        return "index";
    }

    @RequestMapping("/updateimpl")
    public String updateimpl(Model model, Product product) throws Exception {
        productService.modify(product);
        return "redirect:/market/detail?id="+product.getProductId();
    }

    @RequestMapping("/delete")
    public String delete(Model model, @RequestParam("id") int id) throws Exception {
        productService.remove(id);
        return "redirect:/market/myitems";
    }
}
