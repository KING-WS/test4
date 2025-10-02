<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
  이 페이지는 독립적으로 작동하며,
  index.jsp에 의해 포함될 때 외부 CSS/JS와 충돌하지 않도록 설계되었습니다.
--%>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
  /* 폰트 및 전체 박스 스타일 초기화 */
  .chat-wrapper, .chat-wrapper * {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    box-sizing: border-box;
  }

  /* 채팅 전체를 감싸는 컨테이너 */
  .chat-wrapper {
    width: 100%;
    max-width: 700px; /* 최대 너비 */
    margin: 20px auto; /* 페이지 중앙 정렬 */
    border: 1px solid #e0e0e0;
    border-radius: 12px;
    overflow: hidden; /* 둥근 모서리 적용 */
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    display: flex;
    flex-direction: column;
    height: 70vh; /* 화면 높이의 70% */
    min-height: 500px;
    background-color: #fff;
  }

  /* 헤더 */
  .chat-header {
    padding: 16px 20px;
    background-color: #f7f7f7;
    border-bottom: 1px solid #e0e0e0;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  .chat-header h3 {
    margin: 0;
    font-size: 18px;
    font-weight: 600;
  }
  .chat-status {
    display: flex;
    align-items: center;
    gap: 8px; /* 아이콘과 텍스트 간격 */
    font-size: 14px;
    font-weight: 500;
  }
  .status-indicator {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    background-color: #ccc; /* 기본: 연결 끊김 */
  }
  .status-indicator.connected {
    background-color: #28a745; /* 연결됨: 초록색 */
  }

  /* 메시지 영역 */
  .chat-messages {
    flex-grow: 1; /* 남는 공간 모두 차지 */
    padding: 20px;
    overflow-y: auto; /* 메시지 많아지면 스크롤 */
    background-color: #f9f9f9;
    display: flex;
    flex-direction: column;
  }

  /* 각 메시지 말풍선 */
  .message-bubble {
    max-width: 75%;
    padding: 12px 18px;
    border-radius: 20px;
    margin-bottom: 8px;
    line-height: 1.5;
    word-wrap: break-word;
  }
  .message-meta {
    font-size: 12px;
    color: #888;
    margin-bottom: 4px;
  }

  /* 내가 보낸 메시지 */
  .my-message {
    align-self: flex-end; /* 오른쪽 정렬 */
    background-color: #007bff;
    color: white;
  }
  .my-message .message-meta {
    text-align: right;
    color: #e0e0e0;
  }

  /* 상대가 보낸 메시지 */
  .other-message {
    align-self: flex-start; /* 왼쪽 정렬 */
    background-color: #e9e9eb;
    color: black;
  }

  /* 메시지 입력 영역 */
  .chat-input-area {
    padding: 15px 20px;
    border-top: 1px solid #e0e0e0;
    background-color: #f7f7f7;
    display: flex;
    gap: 10px; /* 입력창과 버튼 간격 */
  }
  .chat-input-area input {
    flex-grow: 1;
    border: 1px solid #ccc;
    border-radius: 20px;
    padding: 10px 15px;
    font-size: 16px;
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
  }
  .chat-input-area button:hover {
    background-color: #0056b3;
  }
</style>

<div class="chat-wrapper">
  <div class="chat-header">
    <h3>1:1 고객 문의</h3>
    <div id="chat-status" class="chat-status">
      <div id="status-indicator" class="status-indicator"></div>
      <span id="status-text">연결 중...</span>
    </div>
  </div>

  <div id="chat-messages" class="chat-messages">
  </div>

  <div class="chat-input-area">
    <input type="text" id="chat-target-id" value="id07" placeholder="고객 ID" style="flex-grow: 0.5;">
    <input type="text" id="chat-message-input" placeholder="메시지를 입력하세요...">
    <button id="chat-send-btn">전송</button>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function() {
    const chatUI = {
      id: '${sessionScope.admin.adminId}',
      stompClient: null,

      // HTML 요소 캐싱
      elements: {
        statusIndicator: document.getElementById('status-indicator'),
        statusText: document.getElementById('status-text'),
        messageArea: document.getElementById('chat-messages'),
        targetIdInput: document.getElementById('chat-target-id'),
        messageInput: document.getElementById('chat-message-input'),
        sendBtn: document.getElementById('chat-send-btn')
      },

      init: function() {
        if (!this.id) {
          this.setConnected(false, '로그인 필요');
          console.error("Admin ID is not available.");
          return;
        }
        this.addEventListeners();
        this.connect();
      },

      addEventListeners: function() {
        this.elements.sendBtn.addEventListener('click', () => this.sendMessage());
        this.elements.messageInput.addEventListener('keypress', (e) => {
          if (e.key === 'Enter') {
            this.sendMessage();
          }
        });
      },

      connect: function() {
        try {
          const socket = new SockJS('${websocketurl}adminchat');
          this.stompClient = Stomp.over(socket);
          this.stompClient.connect({}, (frame) => {
            this.setConnected(true, '연결됨');
            console.log('Connected: ' + frame);

            this.stompClient.subscribe('/adminsend/to/' + this.id, (msg) => {
              const messageData = JSON.parse(msg.body);
              this.displayMessage(messageData, false);
            });
          }, (error) => {
            this.setConnected(false, '연결 실패');
            console.log('Connection error: ' + error);
            setTimeout(() => this.connect(), 5000); // 5초 후 재연결 시도
          });
        } catch (e) {
          console.error("SockJS or Stomp not found. Check library loading.", e);
          this.setConnected(false, '라이브러리 오류');
        }
      },

      sendMessage: function() {
        const targetId = this.elements.targetIdInput.value;
        const content = this.elements.messageInput.value;

        if (content.trim() === '' || targetId.trim() === '') {
          return;
        }

        const msg = {
          'sendid': this.id,
          'receiveid': targetId,
          'content1': content
        };

        this.stompClient.send('/adminreceiveto', {}, JSON.stringify(msg));
        this.displayMessage(msg, true);
        this.elements.messageInput.value = ''; // 입력창 비우기
      },

      displayMessage: function(msg, isMyMessage) {
        const bubble = document.createElement('div');
        const meta = document.createElement('div');
        const content = document.createElement('div');

        // 클래스 설정
        bubble.className = isMyMessage ? 'message-bubble my-message' : 'message-bubble other-message';
        meta.className = 'message-meta';

        // 내용 설정
        meta.textContent = isMyMessage ? '나' : msg.sendid;
        content.textContent = msg.content1;

        // 조립
        bubble.appendChild(meta);
        bubble.appendChild(content);

        // 화면에 추가
        this.elements.messageArea.appendChild(bubble);

        // 스크롤 맨 아래로
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

    chatUI.init();
  });
</script>