{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.steam;
in

{
  options = {
    services.xserver.desktopManager.steam = {
      enable = mkOption {
        default = false;
        description = "Enable the steam video game platform.";
      };

      package = mkOption {
        type        = types.package;
        default     = pkgs.steamos-compositor;
        defaultText = "pkgs.steamos-compositor";
        example     = "pkgs.steamos-compositor-plus";
        description = "The compositor to use to run steam.";
      };

    };
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.session = [{
      name = "SteamOS";
      start = ''
        export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0

        export HOMETEST_DESKTOP=1
        export HOMETEST_USER=steam
        export HOMETEST_DESKTOP_USER=desktop
        export HOMETEST_DESKTOP_SESSION=gnome

        ${cfg.package}/bin/steamos/set_hd_mode.sh >> $HOME/set_hd_mode.log

        export LD_PRELOAD=${pkgs.steamos-modeswitch-inhibitor}/lib/libmodeswitch_inhibitor.so

        # Disable DPMS and screen blanking for now; it doesn't know about controller
        # or Steam remote control events right now
        ${pkgs.xorg.xset}/bin/xset -dpms
        ${pkgs.xorg.xset}/bin/xset s off

        ${cfg.package}/bin/steamcompmgr &

        ${cfg.package}/bin/loadargb_cursor ${cfg.package}/share/icons/steam/arrow.png

        # Workaround for Steam login issue while Steam client change propagates out of Beta
        ${pkgs.coreutils}/bin/touch ~/.steam/root/config/SteamAppData.vdf || true

        ${pkgs.steam}/bin/steam -tenfoot -steamos -enableremotecontrol >> $HOME/steam.log
      '';ll
    }];

    environment.systemPackages = with pkgs; [ cfg.package steam xorg.xset steamos-modeswitch-inhibitor ];
  };
}
