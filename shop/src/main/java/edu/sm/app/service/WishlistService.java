package edu.sm.app.service;

import edu.sm.app.dto.Wishlist;
import edu.sm.app.repository.WishlistRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class WishlistService {

    private final WishlistRepository wishlistRepository;

    public void addWishlist(Wishlist wishlist) {
        wishlistRepository.insert(wishlist);
    }

    public void removeWishlist(Wishlist wishlist) {
        wishlistRepository.delete(wishlist);
    }

    public boolean isWishlisted(String custId, int productId) {
        return wishlistRepository.get(new Wishlist(custId, productId)) > 0;
    }

    public List<Wishlist> getWishlistByCustId(String custId) {
        return wishlistRepository.getByCustId(custId);
    }
}
