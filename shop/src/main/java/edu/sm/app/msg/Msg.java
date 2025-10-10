package edu.sm.app.msg;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
public class Msg {
    private int roomId;
    private String sendid;
    private String receiveid;
    private String content1;
}