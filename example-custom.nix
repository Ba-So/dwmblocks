# Example of how to use the configurable dwmblocks flake
let
  # Import the flake
  dwmblocks-flake = builtins.getFlake (toString ./.);
  pkgs = import <nixpkgs> {};
  
  # Define custom blocks configuration
  customBlocks = [
    { icon = "🔊"; command = "sb-volume"; interval = 0; signal = 10; }
    { icon = "🔋"; command = "sb-battery"; interval = 5; signal = 3; }
    { icon = "🕐"; command = "sb-clock"; interval = 60; signal = 1; }
    { icon = "🌐"; command = "sb-internet"; interval = 5; signal = 4; }
  ];

in
# Build dwmblocks with custom configuration
dwmblocks-flake.outputs.${builtins.currentSystem}.lib.mkDwmblocks {
  blocks = customBlocks;
  delimiter = " | ";
}