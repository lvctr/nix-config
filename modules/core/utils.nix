{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bc
    curl
    jq
    lm_sensors
  ];
}