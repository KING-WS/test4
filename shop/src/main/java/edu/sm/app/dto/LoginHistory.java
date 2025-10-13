package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LoginHistory {
    private int logId;
    private String custId;
    private Date loginTime;
}
