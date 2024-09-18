// Add this to a new module FloodC.nc
module FloodC {
  uses {
    interface Boot;
    interface AMSend;
    interface Receive;
    interface AMPacket;
    interface Timer<TMilli> as FloodTimer;
  }
}

implementation {
  uint8_t msgID = 0;  // Message ID to avoid duplicate processing

  event void Boot.booted() {
    call FloodTimer.startPeriodic(5000);  // Trigger flood every 5 seconds
  }

  event void FloodTimer.fired() {
    // Send a flood message
    dbg("FloodC", "Flood timer fired\n");
    message_t *msg = &packet;
    uint8_t *payload = call Packet.getPayload(msg, sizeof(uint8_t));
    *payload = msgID++;
    call AMSend.send(AM_BROADCAST_ADDR, msg, sizeof(uint8_t));
    dbg("FloodC", "Flood message %d sent\n", *payload);
  }

  event message_t* Receive.receive(message_t *msg, void *payload, uint8_t len) {
    uint8_t *receivedMsgID = (uint8_t *)payload;

    // Forward the message if it's new
    if (*receivedMsgID > msgID) {
      msgID = *receivedMsgID;
      call AMSend.send(AM_BROADCAST_ADDR, msg, sizeof(uint8_t));
      dbg("FloodC", "Forwarding flood message %d\n", *receivedMsgID);
    }

    return msg;
  }
}
