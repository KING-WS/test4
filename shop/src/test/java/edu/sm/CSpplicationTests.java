package edu.sm;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvValidationException;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.*;

@SpringBootTest
@Slf4j
class CSpplicationTests {

    @Value("${app.dir.logsdirRead}")
    String dir;

    @Test
    void contextLoads() throws IOException, CsvValidationException {
        CSVReader reader =
                new CSVReader(new InputStreamReader(new FileInputStream(dir+"click.log"), "UTF-8"));
        String[] line;
        //reader.readNext();  // 헤더 건너뜀
        StringBuffer sb = new StringBuffer();
        while ((line = reader.readNext()) != null) {
            sb.append(line[2]).append("\n");
        }
        log.info(sb.toString());
    }

}
