
package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChatMessage {
    private int messageId;
    private String senderId;
    private String receiverId;
    private String content;
    private Date sentAt;
    private boolean isRead;
    private int productId;
}
