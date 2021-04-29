{ config, lib, pkgs, ... }:

with lib;

{

  options.security.lkrg = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the Linux Kernel Runtime Guard kernel
        module, which performs runtime integrity checking of the
        Linux kernel and detection of security vulnerability exploits 
        against the kernel.
      '';
    };

    config = mkOption {
      type = types.lines;
      default = "";
      example = ''
        # Block loading of kernel modules
        lkrg.block_modules = 1;
      '';
      decription = ''
        The sysctl settings to load when systemd service load module.
      '';
    };

  };

  config = mkIf config.security.lkrg.enable {

    boot.kernelPackages = pkgs.linuxPackages_lkrg; 

    boot.extraModulePackages = [ config.boot.kernelPackages.lkrg ];

    # Configure lkrg via sysctl
    environment.etc."sysctl.d/lkrg.conf".text = config.security.lkrg.config;

    # Load kernel module via systemd service
    systemd.services.lkrg = {
      description = "Linux Kernel Runtime Guard";

      after = [
        "systemd-udev-settle.service"
        "firewall.service"
        "systemd-modules-load.service" 
      ];

      before = [
        "systemd-sysctl.service"
        "sysinit.target"
        "shutdown.target"
      ];

      conflicts = [ "shutdown.target" ];

      wantedBy = [ "sysinit.target" ];

      unitConfig = {
        DefaultDependencies = "no";
        ConditionKernelCommandLine = "!nolkrg";
      };

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.kmod}/bin/modprobe -v p_lkrg
        ExecStartPost = "${pkgs.procps}/bin/sysctl -p /etc/sysctl.d/lkrg.conf
        ExecStop = "${pkgs.kmod}/bin/modprobe -v -r p_lkrg
        RemainAfterExit = true;
      };
    };

    # Make sure current kernel is supported
    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "KALLSYMS_ALL")
    ];

  };

}
