package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class ChatWaitSession {
    private int sessionId;
    private String custId;
    private String adminId;
    private String status;
    private String inquiryType;
    private Date createdAt;
    private Date updatedAt;
}
