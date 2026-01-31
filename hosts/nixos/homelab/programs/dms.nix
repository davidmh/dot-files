{ pkgs, inputs, ... }:
{
  programs.dank-material-shell = {
    enable = true;
    dgop.package = inputs.dgop.packages.${pkgs.system}.default;
  };

  programs.dsearch.enable = true;
}
