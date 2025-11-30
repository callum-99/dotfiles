{ ... }: {
  system = {
    defaults = {
      trackpad = {
        Clicking = false;
        Dragging = false;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        FirstClickThreshold = 1;
        TrackpadThreeFingerTapGesture = 0;
        ActuationStrength = 1;
      };

      magicmouse.MouseButtonMode = "TwoButton";

      NSGlobalDomain = {
        InitialKeyRepeat = 25;
        KeyRepeat = 6;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        "com.apple.keyboard.fnState" = true;
      };

      hitoolbox.AppleFnUsageType = "Do Nothing";
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
