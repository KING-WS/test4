<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- StompJS와 SockJS 라이브러리를 로드해야 합니다. 이미 프로젝트에 포함되어 있다면 이 부분은 필요 없습니다. --%>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

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
    gap: 15px;
  }
  .chat-header h3 {
    margin: 0;
    font-size: 18px;
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
    gap: 8px; /* 아이콘과 텍스트 간격 */
    font-size: 14px;
    font-weight: 500;
    white-space: nowrap;
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
    background-color: #f0f2f5;
    display: flex;
    flex-direction: column;
  }

  /* 각 메시지 말풍선 */
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
    background-color: #ffffff;
    color: #333;
    border: 1px solid #e9e9eb;
  }
  .other-message .message-meta {
    color: #555;
  }


  /* 메시지 입력 영역 */
  .chat-input-area {
    padding: 15px 20px;
    border-top: 1px solid #e0e0e0;
    background-color: #fff;
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
    <%-- 메시지 버블이 여기에 동적으로 추가됩니다. --%>
  </div>

  <div class="chat-input-area">
    <input type="text" id="chat-message-input" placeholder="메시지를 입력하세요...">
    <button id="chat-send-btn">전송</button>
  </div>
</div>

<script>
  const chat3Url = '<c:url value="/chat/chat3" />';

  // 페이지 로드가 완료되면 채팅 기능 초기화
  document.addEventListener("DOMContentLoaded", function() {

    // URL에서 'target' 파라미터 값을 가져와서 'To:' 필드에 설정
    const urlParams = new URLSearchParams(window.location.search);
    const targetId = urlParams.get('target');
    if (targetId) {
      document.getElementById('chat-target-id').value = targetId;
    }

    const chatClient = {
      // 1. JSP Expression Language를 사용해 현재 사용자 ID를 직접 설정
      id: '${sessionScope.cust.custId}',
      stompClient: null,

      // HTML 요소를 미리 찾아 변수에 저장 (효율성)
      elements: {
        statusIndicator: document.getElementById('status-indicator'),
        statusText: document.getElementById('status-text'),
        messageArea: document.getElementById('chat-messages'),
        targetIdInput: document.getElementById('chat-target-id'),
        messageInput: document.getElementById('chat-message-input'),
        sendBtn: document.getElementById('chat-send-btn'),
        videoCallBtn: document.getElementById('video-call-btn')
      },

      // 초기화 함수
      init: function() {
        if (!this.id) {
          this.setConnected(false, '로그인 필요');
          console.error("Customer ID is not available in session.");
          this.elements.sendBtn.disabled = true;
          this.elements.messageInput.disabled = true;
          return;
        }
        this.addEventListeners(); // 이벤트 핸들러 등록
        this.connect(); // 웹소켓 자동 연결 시작
        this.loadHistory(); // 대화 기록 불러오기
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

        this.elements.videoCallBtn.addEventListener('click', () => {
            const targetId = this.elements.targetIdInput.value;
            if (!targetId) {
                alert('상대방 ID가 지정되지 않았습니다.');
                return;
            }
            const url = chat3Url + '?caller=' + this.id + '&callee=' + targetId;
            window.open(url, '_blank', 'width=1000,height=800');
        });
      },

      // 대화 기록 불러오기
      loadHistory: async function() {
        const targetId = this.elements.targetIdInput.value;
        if (!targetId) return;

        try {
          const response = await fetch('/api/chat/history?user1=' + this.id + '&user2=' + targetId);
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          const history = await response.json();
          
          this.elements.messageArea.innerHTML = ''; // 기존 메시지 영역 비우기

          history.forEach(msg => {
            const isMyMessage = msg.senderId === this.id;
            // DB에서 가져온 content는 content 필드에 있을 수 있으므로 확인
            const displayMsg = {
                sendid: msg.senderId,
                content1: msg.content
            };
            this.displayMessage(displayMsg, isMyMessage);
          });
        } catch (error) {
          console.error('Error fetching chat history:', error);
        }
      },

      // 웹소켓 서버에 연결
      connect: function() {
        try {
          // 2. 기존 코드의 접속 경로('${websocketurl}chat')를 사용
          const socket = new SockJS('${websocketurl}chat');
          this.stompClient = Stomp.over(socket);

          this.stompClient.connect({}, (frame) => {
            this.setConnected(true, '연결됨');
            console.log('Connected: ' + frame);

            // 3. 메시지 수신 구독 설정 (기존 코드의 경로 '/send/to/고객ID'를 사용)
            this.stompClient.subscribe('/send/to/' + this.id, (msg) => {
              const messageData = JSON.parse(msg.body);
              this.displayMessage(messageData, false); // 받은 메시지이므로 isMyMessage=false
            });

          }, (error) => {
            this.setConnected(false, '연결 실패');
            console.error('Connection error: ' + error);
            // 재연결 로직 (필요시 사용)
            // setTimeout(() => this.connect(), 5000);
          });
        } catch (e) {
          console.error("SockJS or Stomp 라이브러리를 찾을 수 없습니다.", e);
          this.setConnected(false, '라이브러리 오류');
        }
      },

      // 메시지 전송
      sendMessage: function() {
        const targetId = this.elements.targetIdInput.value;
        const content = this.elements.messageInput.value;

        if (targetId.trim() === '' || content.trim() === '') {
          alert('상대방 ID와 메시지를 모두 입력해주세요.');
          return;
        }

        // 4. 서버로 보낼 메시지 객체 생성 (기존 로직과 동일)
        const msg = {
          'sendid': this.id,
          'receiveid': targetId,
          'content1': content
        };

        // 5. 서버의 '/receiveto' 경로로 메시지 전송 (기존 로직과 동일)
        this.stompClient.send('/receiveto', {}, JSON.stringify(msg));

        // 내가 보낸 메시지를 화면에 바로 표시
        this.displayMessage(msg, true);
        this.elements.messageInput.value = ''; // 입력창 비우기
        this.elements.messageInput.focus(); // 다시 입력창에 포커스
      },

      // 화면에 메시지 말풍선 표시
      displayMessage: function(msg, isMyMessage) {
        const bubble = document.createElement('div');
        const meta = document.createElement('div');
        const content = document.createElement('div');

        // 내가 보낸 메시지인지, 상대가 보낸 메시지인지에 따라 CSS 클래스 적용
        bubble.className = isMyMessage ? 'message-bubble my-message' : 'message-bubble other-message';
        meta.className = 'message-meta';

        meta.textContent = msg.sendid; // 보낸 사람 ID 표시
        content.textContent = msg.content1; // 메시지 내용 표시

        bubble.appendChild(meta);
        bubble.appendChild(content);

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