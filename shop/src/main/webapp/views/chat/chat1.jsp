<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 이 파일은 index.jsp에 포함(include)되므로 <html>, <head>, <body> 태그가 필요 없습니다. --%>

<%-- CSS 스타일 --%>
<style>
    .chat-container { display: flex; height: 80vh; border: 1px solid #ccc; width: 100%;}
    #chat-list-container { width: 30%; border-right: 1px solid #ccc; display: flex; flex-direction: column; background-color: #f9f9f9; }
    .chat-list-header { padding: 15px; font-weight: bold; border-bottom: 1px solid #eee; text-align: center; }
    .start-chat-area { padding: 10px; border-bottom: 1px solid #ccc; display: flex; }
    .start-chat-area input { flex-grow: 1; border: 1px solid #ccc; padding: 8px; border-radius: 5px; }
    .start-chat-area button { border: none; background-color: #007bff; color: white; padding: 8px 12px; margin-left: 5px; border-radius: 5px; cursor: pointer; }
    #chat-list { list-style: none; padding: 0; margin: 0; overflow-y: auto; flex-grow: 1; }
    #chat-room-container { width: 70%; display: flex; flex-direction: column; }
    #chat-room-header { padding: 15px; border-bottom: 1px solid #ccc; background-color: #f1f1f1; text-align: center;}
    #messages { flex-grow: 1; overflow-y: auto; padding: 10px; }
    .message { padding: 8px 12px; margin-bottom: 5px; border-radius: 18px; max-width: 70%; line-height: 1.4; }
    .my-message { background-color: #ffeb33; align-self: flex-end; }
    .other-message { background-color: #f0f0f0; align-self: flex-start; }
    .message-input { display: flex; padding: 10px; border-top: 1px solid #ccc; }
    #message-text { flex-grow: 1; border: 1px solid #ccc; border-radius: 15px; padding: 10px; }
    #send-btn { border: none; background-color: #ffeb33; font-weight: bold; padding: 10px 15px; margin-left: 10px; border-radius: 15px; cursor: pointer; }
</style>

<h4 style="display: none" id="user_id">${sessionScope.cust.custId}</h4>

<div class="chat-container">
    <div id="chat-list-container">
        <div class="chat-list-header"><h3>채팅 목록</h3></div>
        <div class="start-chat-area">
            <input type="text" id="partner-id-input" placeholder="상대방 ID 입력">
            <button id="start-chat-btn">시작</button>
        </div>
        <ul id="chat-list"></ul>
    </div>
    <div id="chat-room-container">
        <div id="chat-room-header"><h3 id="current-chat-target">상대방을 선택하세요</h3></div>
        <div id="messages" style="display: flex; flex-direction: column;"></div>
        <div class="message-input">
            <input type="text" id="message-text" placeholder="메시지를 입력하세요..." disabled>
            <button id="send-btn" disabled>전송</button>
        </div>
    </div>
</div>

<script>
    // 스크립트 코드는 JSP와 무관하므로 <c:url> 등을 사용하지 않습니다.
    const chat = {
        myId: '',
        stompClient: null,
        currentRoomId: null,
        currentSubscription: null,

        init: function () {
            this.myId = $('#user_id').text();
            if (!this.myId) {
                console.error("로그인 ID를 찾을 수 없습니다.");
                return;
            }
            this.connect();

            $('#send-btn').on('click', () => this.sendMessage());
            $('#message-text').on('keypress', (e) => { if (e.key === 'Enter') this.sendMessage(); });
            $('#start-chat-btn').on('click', () => {
                const partnerId = $('#partner-id-input').val();
                if (!partnerId || partnerId.trim() === '') {
                    alert('상대방의 ID를 입력하세요.');
                    return;
                }
                if (partnerId === this.myId) {
                    alert('자기 자신과는 대화할 수 없습니다.');
                    return;
                }
                this.openChatRoom(partnerId);
                $('#partner-id-input').val('');
            });
        },

        connect: function () {
            const socket = new SockJS('/chat');
            this.stompClient = Stomp.over(socket);
            this.stompClient.connect({}, (frame) => {
                console.log('WebSocket Connected: ' + frame);
            });
        },

        openChatRoom: async function (partnerId) {
            try {
                const roomId = await $.post('/api/chatroom', { partnerId: partnerId });
                this.currentRoomId = roomId;

                $('#messages').empty();
                // [정상 코드] JavaScript 변수를 사용하기 위해 백틱(`) 사용
                const messages = await $.get(`/api/chatroom/${this.currentRoomId}/messages`);
                messages.forEach(msg => this.displayMessage(msg, true));

                if (this.currentSubscription) {
                    this.currentSubscription.unsubscribe();
                }
                // [정상 코드] JavaScript 변수를 사용하기 위해 백틱(`) 사용
                this.currentSubscription = this.stompClient.subscribe(`/topic/room/${this.currentRoomId}`, (msg) => {
                    this.displayMessage(JSON.parse(msg.body), false);
                });

                $('#current-chat-target').text(`${partnerId} 님과의 대화`);
                $('#message-text, #send-btn').prop('disabled', false);
                $('#message-text').focus();

            } catch (error) {
                console.error("채팅방 입장에 실패했습니다.", error);
                alert("채팅방 입장에 실패했습니다. 서버 로그를 확인하세요.");
            }
        },

        sendMessage: function () {
            const content = $('#message-text').val();
            if (content.trim() === '' || !this.currentRoomId) return;

            const msg = { 'roomId': this.currentRoomId, 'sendid': this.myId, 'content1': content };
            this.stompClient.send('/chat/message', {}, JSON.stringify(msg));
            $('#message-text').val('');
        },

        displayMessage: function(msg, isHistory) {
            const side = msg.sendid === this.myId ? 'my-message' : 'other-message';
            const messageHtml = `<div class="message ${side}">${msg.content1}</div>`;
            const messagesContainer = $('#messages');

            if (isHistory) {
                messagesContainer.prepend(messageHtml);
            } else {
                messagesContainer.append(messageHtml);
                messagesContainer.scrollTop(messagesContainer[0].scrollHeight);
            }
        }
    };

    $(() => {
        chat.init();
    });
</script>