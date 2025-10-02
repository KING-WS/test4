package edu.sm.app.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class Admin {
    private String adminId;
    private String adminPwd;
    private String adminRole;
}
