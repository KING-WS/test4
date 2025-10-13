package edu.sm.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageInfo;
import edu.sm.app.dto.Cate;
import edu.sm.app.dto.Product;
import edu.sm.app.service.ChatService;
import edu.sm.app.dto.ProductSearch;
import edu.sm.app.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import edu.sm.app.dto.Cust;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

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
    public String main(@RequestParam(value="pageNo", defaultValue = "1") int pageNo, Model model) throws Exception {
        PageInfo<Product> p = new PageInfo<>(productService.getPage(pageNo, 9), 5);
        List<Cate> cateList = productService.getAllCate();
        model.addAttribute("cateList", cateList);
        model.addAttribute("productList", p);
        model.addAttribute("target", "/market");
        model.addAttribute("center",dir+"center");
        model.addAttribute("left",dir+"left");
        return "index";
    }

    @RequestMapping("/search")
    public String search(@RequestParam(value="pageNo", defaultValue = "1") int pageNo, ProductSearch ps, Model model) throws Exception {
        PageInfo<Product> p = new PageInfo<>(productService.getSearchPage(pageNo, 9, ps), 5);
        List<Cate> cateList = productService.getAllCate();
        model.addAttribute("cateList", cateList);
        model.addAttribute("productList", p);
        model.addAttribute("ps", ps);
        model.addAttribute("target", "/market/search");
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

    @GetMapping("/api/products/price-ranking")
    @ResponseBody
    public ResponseEntity<List<Product>> getPriceRanking() {
        try {
            List<Product> productList = productService.get();
            List<Product> sortedList = productList.stream()
                .sorted(Comparator.comparing(Product::getProductPrice).reversed())
                .limit(10)
                .collect(Collectors.toList());
            return new ResponseEntity<>(sortedList, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error getting price ranking", e);
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/api/products/regdate-ranking")
    @ResponseBody
    public ResponseEntity<List<Product>> getRegDateRanking() {
        try {
            List<Product> productList = productService.get();
            // 등록일을 기준으로 내림차순 정렬 후 상위 10개만 선택
            List<Product> sortedList = productList.stream()
                .sorted(Comparator.comparing(Product::getProductRegdate).reversed())
                .limit(10)
                .collect(Collectors.toList());
            return new ResponseEntity<>(sortedList, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error getting regdate ranking", e);
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping("/myitems")
    public String myitems(@RequestParam(value = "page", defaultValue = "1") int page, Model model, HttpSession session) throws Exception {
        Cust cust = (Cust) session.getAttribute("cust");
        if (cust == null) {
            return "redirect:/login";
        }
        List<Product> list = productService.getMyItems(cust.getCustId());

        // Manual pagination
        int pageSize = 9;
        com.github.pagehelper.Page<Product> pageList = new com.github.pagehelper.Page<>(page, pageSize);
        pageList.setTotal(list.size());
        pageList.addAll(list.stream()
                .skip((long)(page - 1) * pageSize)
                .limit(pageSize)
                .collect(Collectors.toList()));

        PageInfo<Product> p = new PageInfo<>(pageList, 5);

        model.addAttribute("plist", p.getList());
        model.addAttribute("pageMaker", p);
        model.addAttribute("target", "/market/myitems");
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
