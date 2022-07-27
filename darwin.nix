{ pkgs, ... }:
{
  programs.git.extraConfig.credential.helper = "osxkeychain";
}
