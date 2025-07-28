{ pkgs }:

let
  # Default configuration
  defaultBlocks = [
    { icon = ""; command = "cat /tmp/recordingicon 2>/dev/null"; interval = 0; signal = 9; }
    { icon = ""; command = "sb-tasks"; interval = 10; signal = 26; }
    { icon = ""; command = "sb-memory"; interval = 10; signal = 14; }
    { icon = ""; command = "sb-cpu"; interval = 10; signal = 18; }
    { icon = ""; command = "sb-forecast"; interval = 18000; signal = 5; }
    { icon = ""; command = "sb-volume"; interval = 0; signal = 10; }
    { icon = ""; command = "sb-battery"; interval = 5; signal = 3; }
    { icon = ""; command = "sb-clock"; interval = 60; signal = 1; }
    { icon = ""; command = "sb-forecast"; interval = 18000; signal = 5; }
    { icon = ""; command = "sb-internet"; interval = 5; signal = 4; }
  ];

  # Convert a block configuration to C code
  blockToC = block: ''{"${block.icon}", "${block.command}", ${toString block.interval}, ${toString block.signal}}'';

  # Generate the complete config.h content
  generateConfigH = { blocks ? defaultBlocks, delimiter ? " " }:
    let
      blocksC = builtins.concatStringsSep ",\n\t" (map blockToC blocks);
    in
    ''
      //Modify this file to change what commands output to your statusbar, and recompile using the make command.
      static const Block blocks[] = {
      	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
      	${blocksC}
      };

      //Sets delimiter between status commands. NULL character ('\0') means no delimiter.
      static char *delim = "${delimiter}";

      // Have dwmblocks automatically recompile and run when you edit this file in
      // vim with the following line in your vimrc/init.vim:

      // autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }
    '';

in
{
  inherit defaultBlocks generateConfigH;
}
