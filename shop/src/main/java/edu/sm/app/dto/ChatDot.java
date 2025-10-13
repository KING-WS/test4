
package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChatDot {
    private String partnerId;
    private boolean hasUnread;
    private Integer productId;
    private String productName;
}
