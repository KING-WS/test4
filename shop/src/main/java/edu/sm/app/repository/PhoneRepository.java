package edu.sm.app.repository;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface PhoneRepository {
    List<Map<String, Object>> getSalesByBrand();
    List<Map<String, Object>> getAverageSalesByBrand();
}