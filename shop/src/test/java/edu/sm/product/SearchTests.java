package edu.sm.product;

import edu.sm.app.dto.Product;
import edu.sm.app.dto.ProductSearch;
import edu.sm.app.service.ProductService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
public class SearchTests {
    @Autowired
    ProductService productService;

    @Test
    void contextLoads() {
        ProductSearch productSearch = new ProductSearch();
        productSearch.setProductName("바지");
        productSearch.setStartPrice(10000);
        productSearch.setEndPrice(15000);
        productSearch.setCateId(10);

        try {
            productService.searchProductList(productSearch).forEach(product -> {
                log.info(product.toString());
            });
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
