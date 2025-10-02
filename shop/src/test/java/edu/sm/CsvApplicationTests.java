package edu.sm;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvValidationException;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.*;

@SpringBootTest
@Slf4j
class CsvApplicationTests {

    @Test
    void contextLoads() throws CsvValidationException, IOException {
        CSVReader reader = new CSVReader(new InputStreamReader(new FileInputStream("C:\\smspring\\logs\\click.log"), "UTF-8"));
        String[] line;
        //reader.readNext();  // 헤더 건너뜀
        StringBuffer sb = new StringBuffer();
        while ((line = reader.readNext()) != null) {
            //log.info("{} {} {}", line[0],line[1],line[2]);
            sb.append(line[2]+"\n");
        }
        log.info("{}", sb.toString());

        String cloudTxt = "C:\\smspring\\logs\\cloud.txt";
        try (
                BufferedWriter bw = new BufferedWriter(new FileWriter(cloudTxt))
        ) {
            bw.write(sb.toString());
        }catch(Exception e){
            log.error("{}",e);
        }

        try(
                BufferedReader br = new BufferedReader(new FileReader(cloudTxt))
        ){
            String str;
            StringBuilder builder = new StringBuilder();

            while ((str = br.readLine()) != null) {
                System.out.println(str);
                builder.append(str).append("\n");
            }
            log.info(builder.toString());


        }catch(Exception e){
            log.error("{}",e);
        }

    }

}
