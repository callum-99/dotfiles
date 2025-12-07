{ lib, config, inputs, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.firefox;
in {
  options.module.firefox = {
    enable = mkEnableOption "Enables firefox";
  };

  config = mkIf cfg.enable {
    stylix.targets.firefox.profileNames = [ "main" ];

    programs.firefox = {
      enable = true;

      languagePacks = [ "en-GB" "pl" ];

      betterfox = {
        enable = true;
        profiles.main = {
          enableAllSections = true;

          settings = {};
        };
      };

      policies = {
        BlockAboutConfig = false;
        DefaultDownloadDirectory = "~/Downloads";
      };

      profiles.main = {
        isDefault = true;
        name = "main";

        search = {
          force = true;
          default = "kagi";
          privateDefault = "kagi";

          engines = {
            kagi = {
              name = "Kagi";
              urls = [{ template = "https://kagi.com/search"; params = [{ name = "q"; value = "{searchTerms}"; }]; }];
              iconMapObj."16" = "https://kagi.com/favicon.ico";
              definedaliases = [ "@k" ];
              suggestURL = "https://kagi.com/api/autosuggest?q={searchTerms}";
            };

            nix-packages = {
              name = "Nix Packages";
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedaliases = [ "@np" ];
            };

            nixos-wiki = {
              name = "Nix Wiki";
              urls = [{ template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }];
              iconMapObj."16" = "";
              definedaliases = [ "@nw" ];
            };
          };
        };

        bookmarks = {
          force = true;

          settings = [
            { name = ""; url = "https://youtube.com/feed/subscriptions"; }
            { name = ""; url = "https://twitch.tv/directory/following"; }
          ];
        };

        containers = {
          Google =     { color = "green";     icon = "circle"; id = 1; };
          Facebook =   { color = "blue";      icon = "circle"; id = 2; };
          Selfhosted = { color = "pink";      icon = "circle"; id = 3; };
          Personal =   { color = "turquoise"; icon = "circle"; id = 4; };
          Git =        { color = "red";       icon = "circle"; id = 5; };
          Search =     { color = "yellow";    icon = "circle"; id = 6; };
          Amazon =     { color = "orange";    icon = "circle"; id = 7; };
          Reddit =     { color = "purple";    icon = "circle"; id = 8; };
          Default =    { color = "toolbar";   icon = "circle"; id = 9; };
        };

        settings = {
          "browser.startup.homepage" = "about:newtab";
          "browser.search.region" = "GB";
          "browser.search.isUS" = false;
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "general.useragent.locale" = "en-GB";
          "accessibility.browsewithcaret_shortcut.enabled" = false;
          "browser.aboutwelcome.enabled" = false;
          "browser.contentblocking.category" = "strict";
          "browser.discovery.enabled" = false;
          "browser.download.autohideButton" = false;
          "browser.display.use_system_colors" = true;
          "browser.display.document_color_use" = 0;
          "browser.download.open_pdf_attachments_inline" = true;
          "media.eme.enabled" = false;
          "browser.eme.ui.enabled" = false;
          "browser.formfill.enable" = false;
          "browser.gesture.swipe.left" = "";
          "browser.gesture.swipe.right" = "";
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showWeather" = true;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action\",\"dearrow_ajay_app-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"_76ef94a4-e3d0-4c6f-961a-d38a429a332b_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"vertical-spacer\",\"stop-reload-button\",\"urlbar-container\",\"downloads-button\",\"unified-extensions-button\",\"ublock0_raymondhill_net-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"addon_darkreader_org-browser-action\",\"keepassxc-browser_keepassxc_org-browser-action\",\"_testpilot-containers-browser-action\",\"containerise_kinte_sh-browser-action\",\"addon_hoarder_app-browser-action\",\"reset-pbm-toolbar-button\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"],\"toolbar-menubar\":[\"menubar-items\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\",\"ublock0_raymondhill_net-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action\",\"addon_darkreader_org-browser-action\",\"_testpilot-containers-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"dearrow_ajay_app-browser-action\",\"keepassxc-browser_keepassxc_org-browser-action\",\"containerise_kinte_sh-browser-action\",\"addon_hoarder_app-browser-action\",\"_76ef94a4-e3d0-4c6f-961a-d38a429a332b_-browser-action\",\"reset-pbm-toolbar-button\",\"screenshot-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"TabsToolbar\",\"widget-overflow-fixed-list\",\"unified-extensions-area\",\"vertical-tabs\"],\"currentVersion\":23,\"newElementCount\":9}";
          "browser.uitour.enabled" = false;
          "browser.urlbar.suggest.topsites" = false;
          "devtools.toolbox.host" = "right";
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "extensions.getAddons.showPane" = false;
          "extensions.pocket.enabled" = false;
          "network.trr.custom_uri" = "https://ns2.yarnold.co.uk/dns-query";
          "network.trr.mode" = 2;
          "network.trr.uri" = "https://ns2.yarnold.co.uk/dns-query";
          "privacy.bounceTrackingProtection.mode" = 1;
          "privacy.clearHistory.cookiesAndStorage" = false;
          "privacy.clearHistory.formdata" = true;
          "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;
          "privacy.clearOnShutdown_v2.cache" = true;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
          "privacy.clearOnShutdown_v2.formdata" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.history.custom" = true;
          "privacy.query_stripping.enabled" = true;
          "privacy.query_stripping.enabled.pbmode" = true;
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.consentmanager.skip.pbmode.enabled" = false;
          "privacy.userContext.enabled" = true;
          "privacy.userContext.extension" = "containerise@kinte.sh";
          "privacy.userContext.ui.enabled" = true;
          "security.cert_pinning.enforcement_level" = 2;
          "sidebar.visibility" = "hide-sidebar";
          "general.autoScroll" = true;
        };

        extensions = {
          force = true;

          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            dearrow
            sponsorblock
            betterttv
            darkreader
            containerise
            violentmonkey
          ];

          #settings = {
          #  "uBlock0@raymondhill.net".settings = {
          #    userSettings.advancedUserEnabled = true;

          #    selectedFilterLists = [
          #      "ublock-filters"
          #      "ublock-badware"
          #      "ublock-privacy"
          #      "ublock-unbreak"
          #      "ublock-quick-fixes"
          #      "ublock-annoyances"
          #      "ublock-cookies-easylist"
          #    ];

          #    userFilters = "! Remove stupid shorts from sub feed\nwww.youtube.com##.ytd-rich-section-renderer.style-cope > .ytd-rich-section-renderer.style-scope";
          #  };

          #  #"addon@darkreader.org" = {
          #  #  theme = {
          #  #    mode = 1;
          #  #    brightness = 100;
          #  #    contrast = 100;
          #  #    grayscale = 0;
          #  #    sepia = 0;
          #  #    useFont = false;
          #  #    engine = "dynamicTheme";
          #  #  };

          #  #  "enabledByDefault" = true;

          #  #  "disabledFor" = [
          #  #    "maps.google.com"
          #  #    "google.com/maps"
          #  #    "google.co.uk/maps"
          #  #    "www.lightningmaps.org"
          #  #  ];

          #  #  "changeBrowserTheme" = true;
          #  #  "syncSettings" = true;
          #  #  "syncSiteFixes" = true;
          #  #  "enableForPDF" = true;
          #  #  "detectDarkTheme" = true;
          #  #};
          #};
        };
      };
    };
  };
}
