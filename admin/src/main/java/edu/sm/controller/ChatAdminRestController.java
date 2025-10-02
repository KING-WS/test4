package edu.sm.controller;

import edu.sm.app.dto.Admin;
import edu.sm.app.dto.ChatWaitSession;
import edu.sm.app.service.ChatWaitSessionService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.List;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatAdminRestController {

    private final ChatWaitSessionService chatWaitSessionService;

    @GetMapping("/waiting")
    public ResponseEntity<List<ChatWaitSession>> getWaitingSessions() {
        try {
            List<ChatWaitSession> list = chatWaitSessionService.getByStatus("WAITING");
            return new ResponseEntity<>(list, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/my-sessions")
    public ResponseEntity<List<ChatWaitSession>> getMySessions(@RequestParam String adminId) {
        try {
            List<ChatWaitSession> list = chatWaitSessionService.getByAdminIdAndStatus(adminId, "ACTIVE");
            return new ResponseEntity<>(list, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/claim/{sessionId}")
    public ResponseEntity<?> claimSession(@PathVariable int sessionId, @RequestBody java.util.Map<String, String> payload) {
        String adminId = payload.get("adminId");
        if (adminId == null || adminId.isEmpty()) {
            return new ResponseEntity<>("Admin ID is missing", HttpStatus.BAD_REQUEST);
        }
        try {
            chatWaitSessionService.claimSession(sessionId, adminId);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
