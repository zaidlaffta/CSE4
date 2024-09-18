// In CSE5AppC.nc
configuration CSE5AppC {
  ...
}

implementation {
  components MainC, FloodC, NeighborDiscoveryC, LedsC, ActiveMessageC;

  MainC.Boot -> FloodC;
  MainC.Boot -> NeighborDiscoveryC;
  FloodC.AMSend -> ActiveMessageC;
  NeighborDiscoveryC.AMSend -> ActiveMessageC;
  NeighborDiscoveryC.Receive -> ActiveMessageC.Receive;
  FloodC.Receive -> ActiveMessageC.Receive;
}
