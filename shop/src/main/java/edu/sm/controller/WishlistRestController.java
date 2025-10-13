package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.dto.Wishlist;
import edu.sm.app.service.WishlistService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/wishlist")
@RequiredArgsConstructor
public class WishlistRestController {

    private final WishlistService wishlistService;

    @PostMapping("/toggle")
    public ResponseEntity<?> toggleWishlist(@RequestBody Wishlist wishlist, HttpSession session) {
        Cust cust = (Cust) session.getAttribute("cust");
        if (cust == null) {
            return ResponseEntity.status(401).body("로그인이 필요합니다.");
        }
        wishlist.setCustId(cust.getCustId());

        boolean isWishlisted = wishlistService.isWishlisted(wishlist.getCustId(), wishlist.getProductId());

        if (isWishlisted) {
            wishlistService.removeWishlist(wishlist);
        } else {
            wishlistService.addWishlist(wishlist);
        }

        Map<String, Object> response = new HashMap<>();
        response.put("wishlistStatus", !isWishlisted);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/status")
    public ResponseEntity<?> getWishlistStatus(@RequestParam int productId, HttpSession session) {
        Cust cust = (Cust) session.getAttribute("cust");
        if (cust == null) {
            return ResponseEntity.ok(Map.of("wishlistStatus", false)); // 로그인 안했을때는 항상 false
        }

        boolean isWishlisted = wishlistService.isWishlisted(cust.getCustId(), productId);
        Map<String, Object> response = new HashMap<>();
        response.put("wishlistStatus", isWishlisted);
        return ResponseEntity.ok(response);
    }
}
