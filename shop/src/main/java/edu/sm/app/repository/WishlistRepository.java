package edu.sm.app.repository;

import edu.sm.app.dto.Wishlist;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface WishlistRepository {
    void insert(Wishlist wishlist);
    void delete(Wishlist wishlist);
    int get(Wishlist wishlist);
    List<Wishlist> getByCustId(String custId);
}
