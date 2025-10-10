package edu.sm;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ShopApplicationTests {

    @Test
    void contextLoads() {
        String str = "충청남도 아산시 탕정면 호산리";
        String result [] = str.split(" ");
        System.out.println(result.length);
        System.out.println(result[result.length-1]);
    }

}
