{ username, ...}: {
  wsl = {
    enable = true;
    defaultUser = username;
    startMenuLaunchers = false;
    useWindowsDriver = true;
    wslConf.interop.appendWindowsPath = false;
  };
}
