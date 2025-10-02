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
public class ChatMessage {
    private int messageId;
    private String sendId;
    private String receiveId;
    private String content1;
    private Date sendTime;
}
