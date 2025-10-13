package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DailyLoginDTO {
    private String loginDay;
    private int userCount;
}
