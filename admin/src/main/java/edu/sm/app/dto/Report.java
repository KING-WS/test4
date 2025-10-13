package edu.sm.app.dto;

import lombok.*;

import java.sql.Timestamp;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class Report {
    private int reportId;
    private String reporterId;
    private String reportedId;
    private String reportContent;
    private Timestamp reportDate;
}

