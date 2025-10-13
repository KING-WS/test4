package edu.sm.app.repository;


import com.github.pagehelper.Page;
import edu.sm.app.dto.*;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface ProductRepository extends SmRepository<Product, Integer> {
    Page<Product> getpage() throws Exception;
    Page<Product> getpageSearch(ProductSearch productSearch) throws Exception;
    List<Product> searchProductList(ProductSearch productSearch) throws Exception;
    List<Cate> getAllCate() throws Exception;
    public List<Product> findByCustId(String custId);

    List<Product> selectByIds(List<Integer> ids);

    void updateChatCount(int productId);
}