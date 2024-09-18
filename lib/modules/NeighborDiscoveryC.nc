
// Add this to a new module NeighborDiscoveryC.nc
module NeighborDiscoveryC {
  uses {
    interface Boot;
    interface Timer<TMilli> as NeighborTimer;
    interface AMPacket;
    interface AMSend;
    interface Receive;
    interface Leds;
  }
}

implementation {
  uint16_t neighbors[10];  // Store up to 10 neighbors
  uint8_t neighborCount = 0;

  event void Boot.booted() {
    call NeighborTimer.startPeriodic(1000);  // Send beacon every second
  }

  event void NeighborTimer.fired() {
    // Broadcast a beacon packet
    message_t *msg = &packet;
    call AMSend.send(AM_BROADCAST_ADDR, msg, sizeof("BEACON"));
    dbg("NeighborDiscovery", "Sent BEACON message\n");
  }
  event message_t* Receive.receive(message_t *msg, void *payload, uint8_t len) {
  dbg("NeighborDiscovery", "Received a message\n");

  event message_t* Receive.receive(message_t *msg, void *payload, uint8_t len) {
    // On receiving a message, check if it's a beacon and store the sender
    uint16_t sender = call AMPacket.source(msg);
    bool knownNeighbor = FALSE;

    for (uint8_t i = 0; i < neighborCount; i++) {
      if (neighbors[i] == sender) {
        knownNeighbor = TRUE;
        break;
      }
    }

    if (!knownNeighbor && neighborCount < 10) {
      neighbors[neighborCount++] = sender;
      dbg("NeighborDiscovery", "Discovered new neighbor: %d\n", sender);
    }

    return msg;
  }
}
