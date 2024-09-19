
#include "../../includes/CommandMsg.h"
#include "../../includes/packet.h"

configuration FloodC{
	provides interface Flood;
}
implementation {
	components FloodP;
	Flood = FloodP;

	components new SimpleSendC(AM_PACK);
    FloodP.simpleSend -> SimpleSendC;

    components new HashmapC(uint32_t, 20);
    FloodP.PreviousPackets -> HashmapC;
}