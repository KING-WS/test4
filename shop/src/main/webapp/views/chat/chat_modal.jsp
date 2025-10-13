
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat</title>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
    <style>
      /* Basic reset and font settings */
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        background-color: #f0f2f5;
      }
      .chat-wrapper, .chat-wrapper * {
        box-sizing: border-box;
      }

      /* Main chat container, adapted for modal/iframe */
      .chat-wrapper {
        display: flex;
        flex-direction: column;
        height: 100vh; /* Fill the full height of the iframe */
        width: 100%;
        background-color: #fff;
        border: none; /* No border needed inside iframe */
      }

      /* Header */
      .chat-header {
        padding: 12px 15px;
        background-color: #f7f7f7;
        border-bottom: 1px solid #e0e0e0;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 10px;
        flex-shrink: 0;
      }
      .chat-header h3 {
        margin: 0;
        font-size: 16px;
        font-weight: 600;
        color: #333;
        white-space: nowrap;
      }
      .chat-header .target-input-group {
        display: flex;
        align-items: center;
        gap: 5px;
        width: 100%;
      }
      .chat-header .target-input-group label {
        font-size: 14px;
        font-weight: 500;
        white-space: nowrap;
      }
      .chat-header .target-input-group input {
        width: 100%;
        border: 1px solid #ccc;
        border-radius: 8px;
        padding: 5px 10px;
        background: #eee;
      }
      .chat-header .video-call-btn {
        padding: 5px 10px;
        border-radius: 8px;
        background-color: #17a2b8;
        color: white;
        border: none;
        cursor: pointer;
        font-size: 13px;
        font-weight: 500;
        white-space: nowrap;
      }
      .chat-header .video-call-btn:hover {
        background-color: #138496;
      }
      .chat-status {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        font-weight: 500;
        white-space: nowrap;
      }
      .status-indicator {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background-color: #ccc;
      }
      .status-indicator.connected {
        background-color: #28a745;
      }

      /* Messages area */
      .chat-messages {
        flex-grow: 1;
        padding: 20px;
        overflow-y: auto;
        background-color: #f0f2f5;
        display: flex;
        flex-direction: column;
      }

      /* Message bubbles */
      .message-bubble {
        max-width: 75%;
        padding: 10px 16px;
        border-radius: 18px;
        margin-bottom: 10px;
        line-height: 1.4;
        word-wrap: break-word;
      }
      .message-meta {
        font-size: 12px;
        color: #6c757d;
        margin-bottom: 4px;
        font-weight: 500;
      }
      .my-message {
        align-self: flex-end;
        background-color: #007bff;
        color: white;
      }
      .my-message .message-meta {
        text-align: right;
        color: #e0e0e0;
      }
      .other-message {
        align-self: flex-start;
        background-color: #ffffff;
        color: #333;
        border: 1px solid #e9e9eb;
      }
      .other-message .message-meta {
        color: #555;
      }

      /* Input area */
      .chat-input-area {
        padding: 10px 15px;
        border-top: 1px solid #e0e0e0;
        background-color: #fff;
        display: flex;
        gap: 10px;
        flex-shrink: 0;
      }
      .chat-input-area input {
        flex-grow: 1;
        border: 1px solid #ccc;
        border-radius: 20px;
        padding: 10px 15px;
        font-size: 16px;
      }
      .chat-input-area input:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 0 2px rgba(0,123,255,.25);
      }
      .chat-input-area button {
        border: none;
        background-color: #007bff;
        color: white;
        padding: 10px 20px;
        border-radius: 20px;
        cursor: pointer;
        font-size: 16px;
        font-weight: 600;
        transition: background-color 0.2s;
      }
      .chat-input-area button:hover {
        background-color: #0056b3;
      }
    </style>
</head>
<body>

<div class="chat-wrapper">
  <div class="chat-header">
    <h3>
      <c:out value="${sessionScope.cust.custId}"/>님
    </h3>
    <div class="target-input-group">
      <label for="chat-target-id">To:</label>
      <input type="text" id="chat-target-id" placeholder="상대방 ID 입력" readonly>
    </div>
    <button id="video-call-btn" class="video-call-btn">영상통화</button>
    <div id="chat-status" class="chat-status">
      <div id="status-indicator" class="status-indicator"></div>
      <span id="status-text">연결 중...</span>
    </div>
  </div>

  <div id="chat-messages" class="chat-messages">
    <%-- Messages will be dynamically added here --%>
  </div>

  <div class="chat-input-area">
    <input type="text" id="chat-message-input" placeholder="메시지를 입력하세요...">
    <button id="chat-send-btn">전송</button>
  </div>
</div>

<script>
  const chat3Url = '<c:url value="/chat/chat3" />';

  document.addEventListener("DOMContentLoaded", function() {

    const urlParams = new URLSearchParams(window.location.search);
    const targetId = urlParams.get('target');
    if (targetId) {
      document.getElementById('chat-target-id').value = targetId;
    }

    const chatClient = {
      id: '${sessionScope.cust.custId}',
      stompClient: null,
      elements: {
        statusIndicator: document.getElementById('status-indicator'),
        statusText: document.getElementById('status-text'),
        messageArea: document.getElementById('chat-messages'),
        targetIdInput: document.getElementById('chat-target-id'),
        messageInput: document.getElementById('chat-message-input'),
        sendBtn: document.getElementById('chat-send-btn'),
        videoCallBtn: document.getElementById('video-call-btn')
      },

      init: function() {
        if (!this.id) {
          this.setConnected(false, '로그인 필요');
          console.error("Customer ID is not available in session.");
          this.elements.sendBtn.disabled = true;
          this.elements.messageInput.disabled = true;
          return;
        }
        this.addEventListeners();
        this.connect();
        this.loadHistory();
      },

      addEventListeners: function() {
        this.elements.sendBtn.addEventListener('click', () => this.sendMessage());
        this.elements.messageInput.addEventListener('keypress', (e) => {
          if (e.key === 'Enter') {
            e.preventDefault();
            this.sendMessage();
          }
        });

        this.elements.videoCallBtn.addEventListener('click', () => {
            const targetId = this.elements.targetIdInput.value;
            if (!targetId) {
                alert('상대방 ID가 지정되지 않았습니다.');
                return;
            }
            // Open in the parent window to avoid nested popups
            const url = chat3Url + '?caller=' + this.id + '&callee=' + targetId;
            window.open(url, '_blank', 'width=1000,height=800');
        });
      },

      loadHistory: async function() {
        const targetId = this.elements.targetIdInput.value;
        if (!targetId) return;

        try {
          const response = await fetch('/api/chat/history?user1=' + this.id + '&user2=' + targetId);
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          const history = await response.json();
          
          this.elements.messageArea.innerHTML = '';

          history.forEach(msg => {
            const isMyMessage = msg.senderId === this.id;
            const displayMsg = {
                sendid: msg.senderId,
                content1: msg.content
            };
            this.displayMessage(displayMsg, isMyMessage);
          });

          // Scroll to the bottom after history is loaded
          this.elements.messageArea.scrollTop = this.elements.messageArea.scrollHeight;
        } catch (error) {
          console.error('Error fetching chat history:', error);
        }
      },

      connect: function() {
        try {
          const socket = new SockJS('${websocketurl}chat');
          this.stompClient = Stomp.over(socket);

          this.stompClient.connect({}, (frame) => {
            this.setConnected(true, '연결됨');
            console.log('Connected: ' + frame);

            this.stompClient.subscribe('/send/to/' + this.id, (msg) => {
              const messageData = JSON.parse(msg.body);
              this.displayMessage(messageData, false);
            });

          }, (error) => {
            this.setConnected(false, '연결 실패');
            console.error('Connection error: ' + error);
          });
        } catch (e) {
          console.error("SockJS or Stomp library not found.", e);
          this.setConnected(false, '라이브러리 오류');
        }
      },

      sendMessage: function() {
        const targetId = this.elements.targetIdInput.value;
        const content = this.elements.messageInput.value;

        if (targetId.trim() === '' || content.trim() === '') {
          alert('상대방 ID와 메시지를 모두 입력해주세요.');
          return;
        }

        const msg = {
          'sendid': this.id,
          'receiveid': targetId,
          'content1': content
        };

        this.stompClient.send('/receiveto', {}, JSON.stringify(msg));

        this.displayMessage(msg, true);
        this.elements.messageInput.value = '';
        this.elements.messageInput.focus();
      },

      displayMessage: function(msg, isMyMessage) {
        const bubble = document.createElement('div');
        const meta = document.createElement('div');
        const content = document.createElement('div');

        bubble.className = isMyMessage ? 'message-bubble my-message' : 'message-bubble other-message';
        meta.className = 'message-meta';

        meta.textContent = msg.sendid;
        content.textContent = msg.content1;

        bubble.appendChild(meta);
        bubble.appendChild(content);

        this.elements.messageArea.appendChild(bubble);
        this.elements.messageArea.scrollTop = this.elements.messageArea.scrollHeight;
      },

      setConnected: function(isConnected, statusText) {
        this.elements.statusText.textContent = statusText;
        if (isConnected) {
          this.elements.statusIndicator.classList.add('connected');
        } else {
          this.elements.statusIndicator.classList.remove('connected');
        }
      }
    };

    chatClient.init();

  });
</script>

</body>
</html>
