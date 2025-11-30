{ username, ... }: {
  system.defaults.dock = {
    appswitcher-all-displays = true;
    autohide = true;
    autohide-delay = 0.2;
    autohide-time-modifier = 0.0;
    dashboard-in-overlay = true;
    expose-animation-duration = 0.0;
    expose-group-apps = false;
    largesize = 16;
    launchanim = true;
    magnification = true;
    mineffect = "genie";
    minimize-to-application = false;
    mouse-over-hilite-stack = false;
    mru-spaces = false;
    orientation = "right";
    persistent-others = [
      { folder = { path = "/Applications"; showas = "grid"; displayas = "folder"; }; }
      { folder = { path = "/Users/${username}"; showas = "grid"; displayas = "folder"; }; }
      { folder = { path = "/Users/${username}/Documents"; showas = "grid"; displayas = "folder"; }; }
      { folder = { path = "/Users/${username}/Downloads"; showas = "grid"; displayas = "folder"; }; }
    ];
    scroll-to-open = false;
    show-process-indicators = true;
    show-recents = false;
    showhidden = false;
    slow-motion-allowed = false;
    static-only = false;
    tilesize = 40;
  };
}
