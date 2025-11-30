{ ... }: {
  system.defaults.".GlobalPreferences" = {
    "com.apple.sound.beep.sound" = null;
  };

  system.defaults.NSGlobalDomain = {
    "com.apple.sound.beep.feedback" = 0;
    "com.apple.sound.beep.volume" = 0.0;
  };
}
