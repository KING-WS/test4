<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  .col-sm-10 {
    max-width: 1000px !important;
    margin: 0 auto !important;
    padding: 30px 20px !important;
    background: #ffffff !important;
  }

  .col-sm-10 h2 {
    font-size: 28px !important;
    font-weight: 600 !important;
    color: #1a1a1a !important;
    margin-bottom: 8px !important;
    margin-top: 0 !important;
  }

  #user {
    font-size: 14px !important;
    color: #666 !important;
    margin-bottom: 24px !important;
    padding: 12px !important;
    background: #f5f5f5 !important;
    border-radius: 6px !important;
    border-left: 3px solid #2563eb !important;
  }

  .admin-webrtc-container {
    width: 100% !important;
  }

  .video-grid {
    display: grid !important;
    grid-template-columns: repeat(2, 1fr) !important;
    gap: 16px !important;
    margin-bottom: 24px !important;
  }

  .video-wrapper {
    position: relative !important;
    width: 100% !important;
    background: #000 !important;
    border-radius: 8px !important;
    overflow: hidden !important;
    border: 1px solid #e0e0e0 !important;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1) !important;
  }

  .video-stream {
    width: 100% !important;
    height: auto !important;
    aspect-ratio: 16/9 !important;
    display: block !important;
    background: #1a1a1a !important;
  }

  .video-label {
    position: absolute !important;
    bottom: 12px !important;
    left: 12px !important;
    color: white !important;
    background: rgba(0, 0, 0, 0.7) !important;
    padding: 6px 12px !important;
    border-radius: 4px !important;
    font-size: 12px !important;
    font-weight: 500 !important;
  }

  .controls {
    display: flex !important;
    justify-content: center !important;
    gap: 12px !important;
    margin-bottom: 20px !important;
    margin-top: 20px !important;
  }

  .control-button {
    padding: 11px 28px !important;
    border-radius: 6px !important;
    border: none !important;
    cursor: pointer !important;
    font-size: 15px !important;
    font-weight: 500 !important;
    transition: all 0.3s ease !important;
    min-width: 140px !important;
  }

  .start-call {
    background: #2563eb !important;
    color: white !important;
  }

  .start-call:hover:not(:disabled) {
    background: #1d4ed8 !important;
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3) !important;
  }

  .start-call:disabled {
    background: #cbd5e1 !important;
    cursor: not-allowed !important;
  }

  .end-call {
    background: #dc2626 !important;
    color: white !important;
  }

  .end-call:hover:not(:disabled) {
    background: #b91c1c !important;
    box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3) !important;
  }

  .connection-status {
    text-align: center !important;
    font-size: 13px !important;
    color: #555 !important;
    background: #f9fafb !important;
    border: 1px solid #e5e7eb !important;
    border-radius: 6px !important;
    padding: 12px !important;
  }

  .connection-status.active {
    background: #f0fdf4 !important;
    color: #166534 !important;
    border-color: #bbf7d0 !important;
  }

  .info-section {
    background: #f9fafb !important;
    border-radius: 6px !important;
    padding: 16px !important;
    margin-bottom: 20px !important;
    border: 1px solid #e5e7eb !important;
  }

  .info-section h3 {
    margin: 0 0 12px 0 !important;
    font-size: 16px !important;
    color: #333 !important;
  }

  .info-item {
    display: flex !important;
    justify-content: space-between !important;
    padding: 8px 0 !important;
    font-size: 14px !important;
    color: #666 !important;
  }

  @media (max-width: 768px) {
    .video-grid {
      grid-template-columns: 1fr !important;
    }

    .controls {
      flex-direction: column !important;
    }

    .control-button {
      width: 100% !important;
    }
  }
</style>

<script>
  let chat3 = {
    currentUserId: '',
    otherUserId: '',
    roomId: '',
    peerConnection: null,
    localStream: null,
    websocket: null,
    configuration: {
      iceServers: [{
        urls: 'stun:stun.l.google.com:19302'
      }]
    },

    init: async function() {
      const urlParams = new URLSearchParams(window.location.search);
      const callerId = urlParams.get('caller');
      const calleeId = urlParams.get('callee');
      const sessionUserId = document.getElementById('user_id').textContent.trim();

      // Determine who is the current user and who is the other user
      if (sessionUserId === callerId) {
        this.currentUserId = callerId;
        this.otherUserId = calleeId;
      } else if (sessionUserId === calleeId) {
        this.currentUserId = calleeId;
        this.otherUserId = callerId;
      } else {
        console.error("Error: Current user is not part of this call.");
        this.updateConnectionStatus('사용자 인증 실패', false);
        return;
      }

      // Update the UI
      $('#user_id').text(this.currentUserId);
      $('#other_user_id_display').text(this.otherUserId);

      $('#endButton').click(() => this.endCall());

      await this.startCam();
      this.connect(); // Connect to WebSocket

      // The caller initiates the call
      if (sessionUserId === callerId) {
        // Wait a bit for the websocket to be ready before starting the call
        setTimeout(() => this.startCall(), 1000);
      }
    },

    connect: function() {
      try {
        this.websocket = new WebSocket('${websocketurl}signal');
        this.websocket.onopen = () => {
          console.log('WebSocket connected');
          this.updateConnectionStatus('연결됨', true);
          // Join the room once connected
          const ids = [this.currentUserId, this.otherUserId].sort();
          this.roomId = ids.join('_');
          this.sendSignalingMessage({
            type: 'join',
            roomId: this.roomId,
            userId: this.currentUserId
          });
        };
        this.setupWebSocketHandlers();
      } catch (error) {
        console.error('Error initializing WebRTC:', error);
        this.updateConnectionStatus('오류: ' + error.message, false);
      }
    },

    startCam: async function() {
      try {
        const stream = await navigator.mediaDevices.getUserMedia({
          video: {
            width: { ideal: 1280 },
            height: { ideal: 720 }
          },
          audio: true
        });
        this.localStream = stream;
        document.getElementById('localVideo').srcObject = stream;
        // Don't disable the start button anymore, it's gone
      } catch (error) {
        console.error('카메라 접근 오류:', error);
        this.updateConnectionStatus('카메라에 접근할 수 없습니다', false);
      }
    },

    startCall: async function() {
      console.log("Attempting to start a call...");
      if (!this.otherUserId) {
        alert('상대방 ID가 없습니다!');
        return;
      }
      if (this.currentUserId === this.otherUserId) {
        alert('자기 자신과는 통화할 수 없습니다.');
        return;
      }

      try {
        if (!this.peerConnection) {
          await this.createPeerConnection();
        }

        const offer = await this.peerConnection.createOffer();
        await this.peerConnection.setLocalDescription(offer);

        this.sendSignalingMessage({
          type: 'offer',
          data: offer,
          roomId: this.roomId,
          userId: this.currentUserId,
          targetUserId: this.otherUserId
        });

        document.getElementById('startButton').style.display = 'none';
        document.getElementById('endButton').style.display = 'block';
      } catch (error) {
        console.error('Error starting call:', error);
        this.updateConnectionStatus('통화 시작 실패', false);
      }
    },

    endCall: function() {
      if (this.localStream) {
        this.localStream.getTracks().forEach(track => track.stop());
      }
      if (this.peerConnection) {
        this.peerConnection.close();
        this.peerConnection = null;
      }
      document.getElementById('remoteVideo').srcObject = null;
      document.getElementById('startButton').style.display = 'block';
      document.getElementById('endButton').style.display = 'none';
      this.updateConnectionStatus('통화 종료', false);
      $('#user').html("상대방과의 연결이 끊어졌습니다.");

      this.sendSignalingMessage({
        type: 'bye',
        roomId: this.roomId,
        userId: this.currentUserId,
        targetUserId: this.otherUserId
      });
    },

    sendSignalingMessage: function(message) {
      if (this.websocket?.readyState === WebSocket.OPEN) {
        this.websocket.send(JSON.stringify(message));
      }
    },

    setupWebSocketHandlers: function() {
      this.websocket.onmessage = async (event) => {
        try {
          const message = JSON.parse(event.data);
          console.log('Received message:', message.type);

          switch (message.type) {
            case 'offer':
              try {
                if (!this.peerConnection) {
                  await this.createPeerConnection();
                }

                await this.peerConnection.setRemoteDescription(new RTCSessionDescription(message.data));
                const answer = await this.peerConnection.createAnswer();
                await this.peerConnection.setLocalDescription(answer);

                this.sendSignalingMessage({
                  type: 'answer',
                  data: answer,
                  roomId: this.roomId,
                  userId: this.currentUserId,
                  targetUserId: message.userId
                });
              } catch (error) {
                console.error('Error handling offer:', error);
              }
              break;
            case 'join':
              // 내가 보낸 join 메시지가 아닐 경우에만 알림을 띄웁니다.
              if (message.userId !== this.currentUserId) {
                $('#user').html(message.userId + "님이 입장했습니다. 통화를 시작해주세요.");
              }
              break;
            case 'bye':
              $('#user').html("상대방과의 연결이 끊어졌습니다.");
              document.getElementById('remoteVideo').srcObject = null;
              break;
            case 'answer':
              await this.peerConnection.setRemoteDescription(new RTCSessionDescription(message.data));
              break;
            case 'ice-candidate':
              document.getElementById('startButton').style.display = 'none';
              document.getElementById('endButton').style.display = 'block';
              await this.peerConnection.addIceCandidate(new RTCIceCandidate(message.data));
              $('#user').html("통화 중입니다.");
              this.updateConnectionStatus('통화 중', true);
              break;
          }
        } catch (error) {
          console.error('Error handling WebSocket message:', error);
        }
      };

      this.websocket.onclose = () => {
        console.log('WebSocket Disconnected');
        this.updateConnectionStatus('연결 끊김', false);
      };

      this.websocket.onerror = (error) => {
        console.error('WebSocket error:', error);
        this.updateConnectionStatus('연결 오류', false);
      };
    },

    createPeerConnection: function() {
      this.peerConnection = new RTCPeerConnection(this.configuration);

      this.localStream.getTracks().forEach(track => {
        this.peerConnection.addTrack(track, this.localStream);
      });

      this.peerConnection.ontrack = (event) => {
        if (document.getElementById('remoteVideo') && event.streams[0]) {
          document.getElementById('remoteVideo').srcObject = event.streams[0];
        }
      };

      this.peerConnection.onicecandidate = (event) => {
        if (event.candidate) {
          this.sendSignalingMessage({
            type: 'ice-candidate',
            data: event.candidate,
            roomId: this.roomId,
            userId: this.currentUserId,
            targetUserId: this.otherUserId
          });
        }
      };

      this.peerConnection.onconnectionstatechange = () => {
        if (this.peerConnection) {
          this.updateConnectionStatus('연결 상태: ' + this.peerConnection.connectionState, true);
        }
      };

      return this.peerConnection;
    },

    updateConnectionStatus: function(status, isActive) {
      const el = document.getElementById('connectionStatus');
      el.textContent = 'Status: ' + status;
      el.classList.toggle('active', isActive);
    }
  };

  $(function() {
    chat3.init();
  });

  window.onbeforeunload = function(e) {
    e.preventDefault();
    chat3.endCall();
  };
</script>

<div class="col-sm-10">
  <h2>실시간 영상 거래</h2>

  <div class="info-section">
    <h3>사용자 정보</h3>
    <div class="info-item">
      <span>나의 ID:</span>
      <strong id="user_id" style="color: #2563eb;">${sessionScope.cust.custId}</strong>
    </div>
    <div class="info-item">
      <span>상대방 ID:</span>
      <strong id="other_user_id_display" style="color: #333;"></strong>
    </div>
  </div>

  <h4 id="user">통화 시작을 위해 아래 버튼을 눌러주세요</h4>

  <div class="admin-webrtc-container">
    <div class="video-grid">
      <div class="video-wrapper">
        <video id="remoteVideo" autoplay playsinline muted class="video-stream"></video>
        <div class="video-label">상대방 영상</div>
      </div>
      <div class="video-wrapper">
        <video id="localVideo" autoplay playsinline class="video-stream"></video>
        <div class="video-label">나의 영상</div>
      </div>
    </div>
    <div class="controls">
      <button id="startButton" class="control-button start-call" disabled>통화 시작</button>
      <button id="endButton" class="control-button end-call" style="display: none;">통화 종료</button>
    </div>
    <div class="connection-status" id="connectionStatus">
      Status: 대기 중
    </div>
  </div>
</div>