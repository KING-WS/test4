<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
    color: #333;
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
    margin-bottom: 12px;
    line-height: 1.5;
    word-wrap: break-word;
  }
  .message-meta {
    font-size: 12px;
    color: #888;
    margin-bottom: 4px;
    font-weight: 500;
  }

  /* 내가 보낸 메시지 (고객) */
  .my-message {
    align-self: flex-end; /* 오른쪽 정렬 */
    background-color: #007bff;
    color: white;
  }
  .my-message .message-meta {
    text-align: right;
    color: #e0e0e0;
  }

  /* 상대가 보낸 메시지 (관리자) */
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
  .chat-input-area input:focus {
    outline: none;
    border-color: #007bff;
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
    <h3>1:1 문의 (<c:out value="${sessionScope.cust.custId}"/>)</h3>
    <div id="chat-status" class="chat-status">
      <div id="status-indicator" class="status-indicator"></div>
      <span id="status-text">연결 중...</span>
    </div>
  </div>

  <div id="chat-messages" class="chat-messages">
  </div>

  <div class="chat-input-area">
    <%-- 받는 사람 ID는 관리자(admin)로 고정. 화면에 보이지 않게 처리 --%>
    <input type="hidden" id="chat-target-id" value="admin">
    <input type="text" id="chat-message-input" placeholder="메시지를 입력하세요...">
    <button id="chat-send-btn">전송</button>
  </div>
</div>

<script>
  // 페이지 로드가 완료되면 채팅 기능 초기화
  document.addEventListener("DOMContentLoaded", function() {

    const chatClient = {
      // 1. 현재 사용자(고객) ID 설정
      id: '${sessionScope.cust.custId}',
      stompClient: null,

      // HTML 요소를 미리 찾아 변수에 저장 (효율성)
      elements: {
        statusIndicator: document.getElementById('status-indicator'),
        statusText: document.getElementById('status-text'),
        messageArea: document.getElementById('chat-messages'),
        targetIdInput: document.getElementById('chat-target-id'),
        messageInput: document.getElementById('chat-message-input'),
        sendBtn: document.getElementById('chat-send-btn')
      },

      // 초기화 함수
      init: function() {
        // 로그인이 안되어 있으면 실행 중단
        if (!this.id) {
          this.setConnected(false, '로그인 필요');
          console.error("Customer ID is not available in session.");
          this.elements.sendBtn.disabled = true;
          this.elements.messageInput.disabled = true;
          return;
        }
        this.addEventListeners(); // 이벤트 핸들러 등록
        this.connect(); // 웹소켓 연결 시작
      },

      // 클릭, 키보드 입력 등 이벤트 관련 설정
      addEventListeners: function() {
        this.elements.sendBtn.addEventListener('click', () => this.sendMessage());
        this.elements.messageInput.addEventListener('keypress', (e) => {
          if (e.key === 'Enter') {
            e.preventDefault(); // 엔터키로 인한 기본 동작(폼 제출 등) 방지
            this.sendMessage();
          }
        });
      },

      // 웹소켓 서버에 연결
      connect: function() {
        try {
          const socket = new SockJS('${websocketurl}adminchat');
          this.stompClient = Stomp.over(socket);

          this.stompClient.connect({}, (frame) => {
            this.setConnected(true, '연결됨');
            console.log('Connected: ' + frame);

            // 2. 메시지 수신 구독 설정 (기존 로직과 동일)
            //    서버가 '/adminsend/to/고객ID' 경로로 메시지를 보내면 이 함수가 실행됨
            this.stompClient.subscribe('/adminsend/to/' + this.id, (msg) => {
              const messageData = JSON.parse(msg.body);
              this.displayMessage(messageData, false); // 받은 메시지이므로 isMyMessage=false
            });

            // 대화 기록 불러오기 함수 호출
            this.loadHistory();

          }, (error) => {
            this.setConnected(false, '연결 실패');
            console.log('Connection error: ' + error);
            setTimeout(() => this.connect(), 5000); // 5초 후 재연결 시도
          });
        } catch (e) {
          console.error("SockJS or Stomp library not found.", e);
          this.setConnected(false, '라이브러리 오류');
        }
      },

      // 과거 대화 기록을 불러오는 함수
      loadHistory: async function() {
        const targetId = this.elements.targetIdInput.value;
        try {
          const response = await fetch('/api/chat/history?user1=' + this.id + '&user2=' + targetId);
          if (!response.ok) {
            throw new Error('Failed to fetch chat history.');
          }
          const history = await response.json();
          // 각 메시지를 화면에 표시
          history.forEach(msg => {
            this.displayMessage(msg, msg.senderId === this.id);
          });
        } catch (error) {
          console.error('Error fetching chat history:', error);
        }
      },

      // 메시지 전송
      sendMessage: function() {
        const targetId = this.elements.targetIdInput.value;
        const content = this.elements.messageInput.value;

        // 내용이 없으면 전송하지 않음
        if (content.trim() === '') {
          return;
        }

        // 3. 서버로 보낼 메시지 객체 생성 (기존 로직과 동일)
        const msg = {
          'sendid': this.id,
          'receiveid': targetId,
          'content1': content
        };

        // 4. 서버의 '/adminreceiveto' 경로로 메시지 전송 (기존 로직과 동일)
        this.stompClient.send('/adminreceiveto', {}, JSON.stringify(msg));
        this.displayMessage({ ...msg, senderId: this.id, content: msg.content1 }, true);
        this.elements.messageInput.value = ''; // 입력창 비우기
        this.elements.messageInput.focus(); // 다시 입력창에 포커스
      },

      // 화면에 메시지 말풍선 표시
      displayMessage: function(msg, isMyMessage) {
        const bubble = document.createElement('div');
        const meta = document.createElement('div');
        const contentDiv = document.createElement('div');

        // 내가 보낸 메시지인지, 상대가 보낸 메시지인지에 따라 CSS 클래스 적용
        bubble.className = isMyMessage ? 'message-bubble my-message' : 'message-bubble other-message';
        meta.className = 'message-meta';

        meta.textContent = msg.senderId || msg.sendid; // 보낸 사람 ID 표시 (과거기록 || 실시간)
        contentDiv.textContent = msg.content || msg.content1; // 메시지 내용 표시 (과거기록 || 실시간)

        bubble.appendChild(meta);
        bubble.appendChild(contentDiv);

        this.elements.messageArea.appendChild(bubble);

        // 스크롤을 항상 맨 아래로 이동
        this.elements.messageArea.scrollTop = this.elements.messageArea.scrollHeight;
      },

      // 연결 상태 UI 업데이트
      setConnected: function(isConnected, statusText) {
        this.elements.statusText.textContent = statusText;
        if (isConnected) {
          this.elements.statusIndicator.classList.add('connected');
        } else {
          this.elements.statusIndicator.classList.remove('connected');
        }
      }
    };

    // 채팅 클라이언트 시작
    chatClient.init();
  });
</script>