<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Chat</title>
    <%-- JQuery, SockJS, Stomp.js 라이브러리 로드 (필수!) --%>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <style>
        /* CSS 스타일 (이전과 동일) */
        body { font-family: sans-serif; }
        .chat-container { display: flex; height: 80vh; border: 1px solid #ccc; }
        #chat-list-container { width: 30%; border-right: 1px solid #ccc; display: flex; flex-direction: column; background-color: #f9f9f9; }
        .chat-list-header { padding: 15px; font-weight: bold; border-bottom: 1px solid #eee; }
        #chat-list { list-style: none; padding: 0; margin: 0; overflow-y: auto; flex-grow: 1; }
        #chat-list li { padding: 15px; border-bottom: 1px solid #eee; cursor: pointer; }
        #chat-list li:hover { background-color: #f0f0f0; }
        #chat-list li.active { background-color: #a9d9ff; }
        #chat-list li .last-message { display: block; font-size: 0.8em; color: gray; margin-top: 4px; }
        #chat-room-container { width: 70%; display: flex; flex-direction: column; }
        #chat-room-header { padding: 15px; border-bottom: 1px solid #ccc; background-color: #f1f1f1; }
        #messages { flex-grow: 1; overflow-y: auto; padding: 10px; display: flex; flex-direction: column-reverse; }
        .message { padding: 8px 12px; margin-bottom: 5px; border-radius: 18px; max-width: 60%; line-height: 1.4; }
        .my-message { background-color: #ffeb33; align-self: flex-end; }
        .other-message { background-color: #f0f0f0; align-self: flex-start; }
        .message-input { display: flex; padding: 10px; border-top: 1px solid #ccc; }
        #message-text { flex-grow: 1; border: 1px solid #ccc; border-radius: 15px; padding: 10px; }
        #send-btn { border: none; background-color: #ffeb33; font-weight: bold; padding: 10px 15px; margin-left: 10px; border-radius: 15px; cursor: pointer; }
    </style>
</head>
<body>

<%-- HTML 구조 --%>
<div class="container">
    <h2>Chat Center</h2>
    <h4 style="display: none" id="user_id">${sessionScope.cust.custId}</h4>
    <p><b>My ID:</b> ${sessionScope.cust.custId}</p>

    <div class="chat-container">
        <div id="chat-list-container">
            <div class="chat-list-header"><h3>채팅 목록</h3></div>
            <ul id="chat-list"></ul>
        </div>
        <div id="chat-room-container">
            <div id="chat-room-header"><h3 id="current-chat-target">상대방을 선택하세요</h3></div>
            <div id="messages"></div>
            <div class="message-input">
                <input type="text" id="message-text" placeholder="메시지를 입력하세요..." disabled>
                <button id="send-btn" disabled>전송</button>
            </div>
        </div>
    </div>
</div>

<script>
    let chat = {
        myId: '',
        stompClient: null,
        chatRooms: {},
        currentChatTarget: null,

        init: function () {
            this.myId = $('#user_id').text();
            this.connect();

            $('#send-btn').click(() => this.sendMessage());
            $('#message-text').keypress((e) => { if (e.key === 'Enter') this.sendMessage(); });
            $('#chat-list').on('click', 'li', (e) => {
                let targetId = $(e.currentTarget).data('id');
                this.openChatRoom(targetId);
            });
        },

        connect: function () {
            // ★★★ 변경점 1: 접속 주소를 '/chat'으로 수정 ★★★
            let socket = new SockJS('/chat');
            this.stompClient = Stomp.over(socket);

            this.stompClient.connect({}, (frame) => {
                console.log('Connected: ' + frame);
                // ★★★ 변경점 2: 구독 주소를 '/send/to/'로 수정 ★★★
                // StomWebSocketConfig의 enableSimpleBroker("/send",...) 설정과 MsgController의 전송 로직을 따름
                this.stompClient.subscribe('/send/to/' + this.myId, (msg) => {
                    this.handleIncomingMessage(JSON.parse(msg.body));
                });
                this.fetchChatList();
            });
        },

        fetchChatList: function() {
            console.log("서버에 기존 채팅 목록을 요청해야 합니다. (백엔드 API 구현 필요)");
        },

        handleIncomingMessage: function (msg) {
            let partnerId = msg.sendid === this.myId ? msg.receiveid : msg.sendid;
            if (!this.chatRooms[partnerId]) this.chatRooms[partnerId] = [];
            this.chatRooms[partnerId].push(msg);
            this.updateChatList(partnerId, msg.content1);
            if (this.currentChatTarget === partnerId) this.displayMessage(msg);
        },

        updateChatList: function (partnerId, lastMessage) {
            let chatRoomEntry = $('#chat-list').find(`li[data-id='${partnerId}']`);
            if (chatRoomEntry.length === 0) {
                $('#chat-list').prepend(`<li data-id="${partnerId}">${partnerId}<span class="last-message">${lastMessage}</span></li>`);
            } else {
                chatRoomEntry.find('.last-message').text(lastMessage);
                $('#chat-list').prepend(chatRoomEntry);
            }
        },

        openChatRoom: function (targetId) {
            this.currentChatTarget = targetId;
            $('#current-chat-target').text(targetId);
            $('#messages').empty();
            $('#message-text, #send-btn').prop('disabled', false);
            $('#chat-list li').removeClass('active');
            $('#chat-list').find(`li[data-id='${targetId}']`).addClass('active');
            let messages = this.chatRooms[targetId] || [];
            messages.forEach(msg => this.displayMessage(msg));
        },

        displayMessage: function(msg) {
            let side = msg.sendid === this.myId ? 'my-message' : 'other-message';
            $('#messages').prepend(`<div class="message ${side}">${msg.content1}</div>`);
        },

        sendMessage: function () {
            let content = $('#message-text').val();
            if (content.trim() === '' || !this.currentChatTarget) return;

            let msg = { 'sendid': this.myId, 'receiveid': this.currentChatTarget, 'content1': content };

            // ★★★ 변경점 3: 메시지 발행 주소를 '/receiveto'로 유지 ★★★
            // MsgController의 @MessageMapping("/receiveto")를 호출
            this.stompClient.send('/receiveto', {}, JSON.stringify(msg));

            this.handleIncomingMessage(msg);
            $('#message-text').val('');
        }
    };

    $(() => { chat.init(); });
</script>

</body>
</html>