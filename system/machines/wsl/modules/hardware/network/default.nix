_: {
  networking = {
    firewall = {
      enable = true;
    };

    interfaces.eth0 = {
      ipv4.addresses = [{
        address = "172.18.48.10";
        prefixLength = 20;
      }];
    };

    defaultGateway = {
      address = "172.18.48.1";
      interface = "eth0";
    };
  };
}
