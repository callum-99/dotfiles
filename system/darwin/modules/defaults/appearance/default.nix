{ ... }: {
  system.defaults = {
    NSGlobalDomain = {
      # Dark mode
      AppleInterfaceStyle = "Dark";
      AppleInterfaceStyleSwitchesAutomatically = false;

      # Scroll bars
      AppleShowScrollBars = "WhenScrolling";
      AppleScrollerPagingBehavior = true;
    };
  };
}
