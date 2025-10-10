package edu.sm.controller;

import edu.sm.app.dto.Marker;
import edu.sm.app.dto.Product;
import edu.sm.app.service.MarkerService;
import edu.sm.app.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Slf4j
@RequestMapping("/map")
@RequiredArgsConstructor
public class MapController {

    final MarkerService markerService;
    final ProductService productService;

    String dir="map/";

    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center",dir+"center");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/go")
    public String go(Model model, @RequestParam("target") int target) throws Exception {
        Marker marker = markerService.get(target);
        model.addAttribute("marker",marker);
        model.addAttribute("center",dir+"go");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/map1")
    public String map1(Model model) {
        model.addAttribute("center",dir+"map1");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/map2")
    public String map2(Model model) {
        model.addAttribute("center",dir+"map2");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/map3")
    public String map3(Model model) {
        model.addAttribute("center",dir+"map3");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/map4")
    public String map4(Model model) {
        model.addAttribute("center",dir+"map4");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/map5")
    public String map5(Model model) {
        model.addAttribute("center",dir+"map5");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/register")
    public String register(Model model) {
        model.addAttribute("center",dir+"register");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/registerimpl")
    public String registerimpl(Model model, Product product, Marker marker) throws Exception {
        productService.register(product);

        marker.setTitle(product.getProductName());
        marker.setImg(product.getProductImg());
        marker.setTarget(product.getProductId());

        markerService.register(marker);
        return "redirect:/map/map5";
    }
}
