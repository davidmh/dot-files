{ lib
, callPackage
, linuxPackagesFor
, _kernelPatches ? [ ]
,
}:

let
  linux-asahi-pkg =
    { stdenv
    , lib
    , fetchFromGitHub
    , buildLinux
    , ...
    }:
    buildLinux rec {
      inherit stdenv lib;

      version = "6.16.5-asahi";
      modDirVersion = version;
      extraMeta.branch = "6.16";

      src = fetchFromGitHub {
        owner = "AsahiLinux";
        repo = "linux";
        tag = "asahi-6.16.5-2";
        hash = "sha256-W30x9aoU5ltkda/flfhdGbMHVYCpNaneYvhbh7HiG+c=";
      };

      kernelPatches = [
        {
          name = "Asahi config";
          patch = null;
          structuredExtraConfig = with lib.kernel; {
            # Needed for GPU
            ARM64_16K_PAGES = yes;

            # Might lead to the machine rebooting if not loaded soon enough
            APPLE_WATCHDOG = yes;

            # Can not be built as a module, defaults to no
            APPLE_M1_CPU_PMU = yes;

            # Defaults to 'y', but we want to allow the user to set options in modprobe.d
            HID_APPLE = module;

            # These are necessary, otherwise sound is very quiet.
            # According to James Calligeros (chadmed) this is most likely a race condition.
            SND_SOC_APPLE_MCA = module;
            SND_SOC_APPLE_MACAUDIO = module;
            SND_SOC_CS42L42_CORE = module;
            SND_SOC_CS42L42 = module;
            SND_SOC_CS42L83 = module;
            SND_SOC_CS42L84 = module;
            SND_SOC_TAS2764 = module;
            SND_SOC_TAS2770 = module;
            SND_SIMPLE_CARD_UTILS = module;

            # Not present in Asahi kernel fork; force-override common-config's hard setting
            # so generate-config.pl treats it as a warning instead of an error
            NOVA_CORE = lib.mkForce (option no);
            # BCACHEFS_FS = lib.mkForce (option no);
            # DRM_HYPERV = lib.mkForce (option no);
            # DRM_NOUVEAU_GSP_DEFAULT = lib.mkForce (option no);
            # FB_HYPERV = lib.mkForce (option no);
            # IP_NF_TARGET_REDIRECT = lib.mkForce (option no);
            # ZPOOL = lib.mkForce (option no);
          };
          features.rust = true;
        }
      ]
      ++ _kernelPatches;
    };

  linux-asahi = (callPackage linux-asahi-pkg { }).overrideAttrs (_: {
    # FIXME: Remove when https://github.com/NixOS/nixpkgs/pull/436245 lands
    preConfigure = ''
      export RUST_LIB_SRC KRUSTFLAGS
    '';
  });
in
lib.recurseIntoAttrs (linuxPackagesFor linux-asahi)
