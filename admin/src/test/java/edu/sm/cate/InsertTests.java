package edu.sm.cate;

import edu.sm.app.dto.Cate;
import edu.sm.app.service.CateService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.beans.factory.annotation.Autowired;


@SpringBootTest
@Slf4j
public class InsertTests {
    @Autowired
    CateService cateService;
    @Test
    void contextLoads() throws Exception {
        Cate cate = Cate.builder().cateId(40).cateName("가방").build();
        try {
            cateService.register(cate);
            log.info("ok");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
