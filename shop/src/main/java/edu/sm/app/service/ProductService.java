package edu.sm.app.service;


import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import edu.sm.app.dto.*;
import edu.sm.app.repository.ProductRepository;
import edu.sm.common.frame.SmService;
import edu.sm.util.FileUploadUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductService implements SmService<Product, Integer> {

    final ProductRepository productRepository;

    @Value("${app.dir.uploadimgsdir}")
    String imgDir;

    @Override
    public void register(Product product) throws Exception {
        if(product.getProductImgFile() != null){
            product.setProductImg(product.getProductImgFile().getOriginalFilename());
            FileUploadUtil.saveFile(product.getProductImgFile(), imgDir);
        }

        // Add random offset to lat/lng to make the map look more natural
        if (product.getLat() != null && product.getLng() != null) {
            double lat = product.getLat();
            double lng = product.getLng();

            // Random offset within approx. +/- 500m
            // 0.01 degrees is roughly 1.11km
            double latOffset = (Math.random() - 0.5) * 0.01; // approx -0.005 to +0.005
            double lngOffset = (Math.random() - 0.5) * 0.01;

            product.setLat(lat + latOffset);
            product.setLng(lng + lngOffset);
        }

        productRepository.insert(product);
    }

    @Override
    public void modify(Product product) throws Exception {
        // 새로운 이미지기 있는지 검사
        if(product.getProductImgFile().isEmpty()){
            productRepository.update(product);
        }
        // 신규 이미지 사용
        else{
            FileUploadUtil.deleteFile(product.getProductImg(), imgDir);
            FileUploadUtil.saveFile(product.getProductImgFile(), imgDir);
            product.setProductImg(product.getProductImgFile().getOriginalFilename());
            productRepository.update(product);
        }

    }

    @Override
    public void remove(Integer s) throws Exception {
        Product product = this.get(s);
        // FileUploadUtil.deleteFile(product.getProductImg(), imgDir);
        productRepository.delete(s);
    }

    @Override
    public List<Product> get() throws Exception {
        return productRepository.selectAll();
    }

    @Override
    public Product get(Integer s) throws Exception {
        return productRepository.select(s);
    }
    public List<Product> searchProductList(ProductSearch productSearch) throws Exception {
        return productRepository.searchProductList(productSearch);
    }
    public Page<Product> getPage(int pageNo) throws Exception {
        PageHelper.startPage(pageNo, 3); // 3: 한화면에 출력되는 개수
        return productRepository.getpage();
    }
    public List<Cate> getAllCate() throws Exception {
        return productRepository.getAllCate();
    }
    public List<Product> getMyItems(String custId) throws Exception {
        return productRepository.findByCustId(custId);
    }
}