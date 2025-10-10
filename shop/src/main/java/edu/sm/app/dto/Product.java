package edu.sm.app.dto;

import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.sql.Timestamp;
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class Product {
    private int productId;
    private String productName;
    private int productPrice;
    private String productImg;
    private Timestamp productRegdate;
    private Timestamp productUpdate;
    private int cateId;
    private String cateName;
    private Double lat;
    private Double lng;
    private String productDesc;
    private MultipartFile productImgFile;
}