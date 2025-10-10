package edu.sm.marker;

import edu.sm.app.dto.Marker;
import edu.sm.app.service.MarkerService;
import edu.sm.controller.MainController;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
public class RegisterTest {
    @Autowired
    MarkerService markerService;

    void contextLoads() throws Exception {
        Marker marker = Marker.builder()
                .target(305)
                .title("가라아게")
                .img("ss1.jpg")
                .lat(33.2650)
                .lng(126.420)
                .loc(300)
                .build();

        markerService.register(marker);

        log.info("마커 정보: {}", marker);

    }
}
