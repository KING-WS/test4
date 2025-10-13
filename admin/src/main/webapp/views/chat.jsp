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

    /* 전체 레이아웃 */
    .chat-container {
        display: flex;
        width: 100%;
        max-width: 1000px; /* 너비 확장 */
        margin: 20px auto;
        height: 80vh; /* 높이 조정 */
        min-height: 600px;
        border: 1px solid #e0e0e0;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        background-color: #fff;
    }

    /* 사용자 목록 (왼쪽) */
    .chat-user-list {
        width: 280px;
        border-right: 1px solid #e0e0e0;
        display: flex;
        flex-direction: column;
        background-color: #f7f9fa;
    }
    .user-list-header {
        padding: 16px 20px;
        border-bottom: 1px solid #e0e0e0;
    }
    .user-list-header h3 {
        margin: 0; font-size: 18px; font-weight: 600;
    }
    .user-list-items {
        overflow-y: auto;
        flex-grow: 1;
    }
    .user-item {
        padding: 15px 20px;
        cursor: pointer;
        border-bottom: 1px solid #eef1f3;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .user-item:hover {
        background-color: #f0f2f5;
    }
    .user-item.active {
        background-color: #007bff;
        color: white;
    }
    .user-item .new-message-badge {
        background-color: #dc3545;
        color: white;
        font-size: 11px;
        font-weight: bold;
        padding: 3px 8px;
        border-radius: 12px;
    }

    /* 채팅창 (오른쪽) */
    .chat-wrapper {
        width: 100%;
        flex-grow: 1;
        display: flex;
        flex-direction: column;
        /* 기존 스타일 재정의 */
        margin: 0; border: none; border-radius: 0; box-shadow: none; height: 100%;
    }

    /* 헤더 */
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

<div class="chat-container">
    <div id="chat-user-list" class="chat-user-list">
        <div class="user-list-header">
            <h3>대화 목록</h3>
        </div>
        <div id="user-list-items" class="user-list-items">
            <!-- 동적으로 유저 목록 추가 -->
        </div>
    </div>
    <div class="chat-wrapper">
        <div class="chat-header">
            <h3 id="chat-header-title">1:1 고객 문의</h3>
            <div id="chat-status" class="chat-status">
                <div id="status-indicator" class="status-indicator"></div>
                <span id="status-text">연결 중...</span>
            </div>
        </div>

        <div id="chat-messages" class="chat-messages">
             <div class="no-chat-selected">
                <p>왼쪽 목록에서 대화를 선택하세요.</p>
            </div>
        </div>

        <div id="chat-input-section" class="chat-input-area" style="display: none;">
            <input type="text" id="chat-message-input" placeholder="메시지를 입력하세요...">
            <button id="chat-send-btn">전송</button>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const chatUI = {
            id: '${sessionScope.admin.adminId}',
            stompClient: null,
            currentUserList: new Map(), // key: userId, value: { item: element, badge: element }
            currentTargetId: null,

            elements: {
                statusIndicator: document.getElementById('status-indicator'),
                statusText: document.getElementById('status-text'),
                messageArea: document.getElementById('chat-messages'),
                messageInput: document.getElementById('chat-message-input'),
                sendBtn: document.getElementById('chat-send-btn'),
                userListItems: document.getElementById('user-list-items'),
                chatHeaderTitle: document.getElementById('chat-header-title'),
                inputSection: document.getElementById('chat-input-section'),
                noChatSelected: document.querySelector('.no-chat-selected')
            },

            init: function() {
                if (!this.id) {
                    this.setConnected(false, '로그인 필요');
                    return;
                }
                this.addEventListeners();
                this.connect();
            },

            addEventListeners: function() {
                this.elements.sendBtn.addEventListener('click', () => this.sendMessage());
                this.elements.messageInput.addEventListener('keypress', (e) => {
                    if (e.key === 'Enter') this.sendMessage();
                });
            },

            connect: function() {
                try {
                    const socket = new SockJS('${websocketurl}adminchat');
                    this.stompClient = Stomp.over(socket);
                    this.stompClient.connect({}, (frame) => {
                        this.setConnected(true, '연결됨');
                        console.log('Connected: ' + frame);

                        // 1. 개인 메시지 수신 (기존 로직)
                        this.stompClient.subscribe('/adminsend/to/' + this.id, (msg) => {
                            const messageData = JSON.parse(msg.body);
                            // 메시지가 오면 보낸 사람을 대화 목록에 추가
                            this.addConversation(messageData.sendid);
                            this.displayMessage(messageData, false);
                        });

                        // 2. 새로운 고객 문의 알림 수신
                        this.stompClient.subscribe('/topic/admin/inbox', (msg) => {
                            const messageData = JSON.parse(msg.body);
                            this.addConversation(messageData.sendid);
                        });

                    }, (error) => {
                        this.setConnected(false, '연결 실패');
                        setTimeout(() => this.connect(), 5000);
                    });
                } catch (e) {
                    this.setConnected(false, '라이브러리 오류');
                }
            },

            addConversation: function(userId) {
                if (!userId || this.currentUserList.has(userId)) {
                    // 이미 목록에 있거나 userId가 없으면 알림 배지만 업데이트
                    if(this.currentUserList.has(userId) && userId !== this.currentTargetId){
                        this.currentUserList.get(userId).badge.style.display = 'block';
                    }
                    return;
                }

                const userItem = document.createElement('div');
                userItem.className = 'user-item';
                userItem.dataset.userId = userId;
                userItem.textContent = userId;

                const badge = document.createElement('span');
                badge.className = 'new-message-badge';
                badge.textContent = 'new';
                badge.style.display = 'block'; // 처음엔 항상 보이게
                userItem.appendChild(badge);

                userItem.addEventListener('click', () => this.selectConversation(userId));

                this.elements.userListItems.prepend(userItem); // 새 유저를 맨 위에 추가
                this.currentUserList.set(userId, { item: userItem, badge: badge });
            },

            selectConversation: function(userId) {
                if (this.currentTargetId === userId) return;

                this.currentTargetId = userId;

                // 모든 아이템에서 'active' 클래스 제거
                this.currentUserList.forEach(user => {
                    user.item.classList.remove('active');
                });

                // 현재 선택된 아이템에 'active' 클래스 추가 및 배지 숨김
                const selectedUser = this.currentUserList.get(userId);
                selectedUser.item.classList.add('active');
                selectedUser.badge.style.display = 'none';

                this.elements.messageArea.innerHTML = ''; // 메시지 창 비우기
                this.elements.chatHeaderTitle.textContent = `${userId}님과의 대화`;
                this.elements.inputSection.style.display = 'flex';
                if(this.elements.noChatSelected) this.elements.noChatSelected.style.display = 'none';

                // TODO: 여기에 해당 유저와의 과거 대화 기록을 불러오는 로직 추가
            },

            sendMessage: function() {
                const content = this.elements.messageInput.value;
                if (content.trim() === '' || !this.currentTargetId) {
                    return;
                }

                const msg = {
                    'sendid': this.id,
                    'receiveid': this.currentTargetId,
                    'content1': content
                };

                this.stompClient.send('/adminreceiveto', {}, JSON.stringify(msg));
                this.displayMessage(msg, true);
                this.elements.messageInput.value = '';
            },

            displayMessage: function(msg, isMyMessage) {
                // 현재 선택된 대화의 메시지만 표시
                const chatPartnerId = isMyMessage ? msg.receiveid : msg.sendid;
                if (chatPartnerId !== this.currentTargetId) {
                    if(!isMyMessage) { // 내가 보낸 메시지가 아닌 경우에만 알림
                        this.addConversation(msg.sendid);
                    }
                    return;
                }

                const bubble = document.createElement('div');
                const meta = document.createElement('div');
                const content = document.createElement('div');

                bubble.className = isMyMessage ? 'message-bubble my-message' : 'message-bubble other-message';
                meta.className = 'message-meta';
                meta.textContent = isMyMessage ? '나' : msg.sendid;
                content.textContent = msg.content1;

                bubble.appendChild(meta);
                bubble.appendChild(content);
                this.elements.messageArea.appendChild(bubble);
                this.elements.messageArea.scrollTop = this.elements.messageArea.scrollHeight;
            },

            setConnected: function(isConnected, statusText) {
                this.elements.statusText.textContent = statusText;
                this.elements.statusIndicator.classList.toggle('connected', isConnected);
            }
        };

        chatUI.init();
    });
</script>