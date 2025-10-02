package edu.sm.cust;

import edu.sm.app.dto.Cust;
import edu.sm.app.service.CustService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
class UpdateTests {
    @Autowired
    CustService custService;
    @Test
    void contextLoads() throws Exception {
        Cust cust = Cust.builder()
                .custId("id22")
                .custPwd("pwd22")
                .custName("김말자")
                .custAddr("천안시")
                .build();
        custService.modify(cust);

        log.info(custService.get("id22").toString());
    }

}
