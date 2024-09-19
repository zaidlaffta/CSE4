interface Flood {
	command void ping(uint16_t destination, uint8_t *payload);
  	command void Flood(pack* myMsg);
}// Flood Comp