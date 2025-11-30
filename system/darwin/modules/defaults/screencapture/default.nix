{ ... }: {
  system.defaults.screencapture = {
    location = "~/Pictures/Screenshots";
    type = "png";
    disable-shadow = false;
    include-date = true;
    show-thumbnail = false;
    target = "file";
  };
}
