package edu.sm.controller;

import edu.sm.app.service.LoggerService;
import edu.sm.app.service.LoggerService1;
import edu.sm.app.service.LoggerService2;
import edu.sm.app.service.LoggerService3;
import edu.sm.util.FileUploadUtil;
import edu.sm.util.WeatherUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
@Slf4j
public class MainRestController {

    private final LoggerService loggerService;
    private final LoggerService1 loggerService1;
    private final LoggerService2 loggerService2;
    private final LoggerService3 loggerService3;

    @Value("${app.key.wkey}")
    String wkey;

    @RequestMapping("/getwt1")
    public Object getwt1(@RequestParam("loc") String loc) throws IOException, ParseException {
        return WeatherUtil.getWeather(loc,wkey);
    }
    @RequestMapping("/savedata")
    public Object savedata(@RequestParam("data") String data) throws IOException {
        log.info(data);
        loggerService.save(data);
        return "OK";
    }
    @RequestMapping("/savedata1")
    public Object savedata1(@RequestParam("data") String data) throws IOException {
        log.info(data);
        loggerService1.save1(data);
        return "OK";
    }
    @RequestMapping("/savedata2")
    public Object savedata2(@RequestParam("data") String data) throws IOException {
        log.info(data);
        loggerService2.save2(data);
        return "OK";
    }
    @RequestMapping("/savedata3")
    public Object savedata3(@RequestParam("data") String data) throws IOException {
        log.info(data);
        loggerService3.save3(data);
        return "OK";
    }


    @RequestMapping("/saveaudio")
    public Object saveaudio(@RequestParam("file") MultipartFile file) throws IOException {
        FileUploadUtil.saveFile(file, "C:/smspring/audios/");
        return "OK";
    }
    @RequestMapping("/saveimg")
    public Object saveimg(@RequestParam("file") MultipartFile file) throws IOException {
        FileUploadUtil.saveFile(file, "C:/smspring/imgs/");
        return "OK";
    }
}






