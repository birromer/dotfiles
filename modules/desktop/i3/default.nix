{ config, lib, pkgs, user, home-manager, ... }:

let
  mod = "$Mod4";

  mode_system = "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown";

  ws1 = "1: ";
  ws2 = "2: ";
  ws3 = "3: ";
  ws4 = "4: ";
  ws5 = "5: ";
  ws6 = "6: ";
  ws7 = "7: ";
  ws8 = "8: ";
  ws9 = "9: ";
  ws0 = "10: ";

  bn     = "#308634";
  bm     = "#E57C46";
  bd     = "#E24C49";
  white  = "#FFFFFF";
  white2 = "#888888";
  black  = "#000000";
  bg     = "#2f343f";
  fg     = "#1C1E20";
  fg-alt = "#16537e";
  mf     = "#C4C7C5";
  ac     = "#B4BC67";
  sp     = "$666666";

  locker = "${pkgs.i3lock-fancy} -t 'go away' -f 'Comic-Sans-MS-Bold'";

in
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;

      fonts = [];


      assigns = {
#        "2: web" = [{ class = "^Firefox$"; class = "^Navigator$"; class = "^firefoxdeveloperedition$";}];
#        "2: web" = [{ class = "^Google-chrome$"; }];
#
#        "0: extra" = [{ class = "^Firefox$"; window_role = "About"; }];
      };

      startup = [
        { command = "fc-cache"; always = true; notification = false; }
        { command = "dunst"; always = true; notification = false; }
        { command = "flameshot"; always = true; notification = false; }
        { command = "redshift"; always = true; notification = false; }
        { command = "i3mpdupdate"; always = true; notification = false; }
        { command = "megasync"; always = true; notification = false; }
        { command = "xautolock -time 30 -locker ${locker}"; always = false; notification = false; }
        # { command = "compton"; always = true; notification = false; }
        # exec_always xmodmap -e "keycode 45 = k K NoSymbol NoSymbol backslash"
        # exec_always xmodmap -e "keycode 46 = l L NoSymbol NoSymbol bar"
        # exec_always xmodmap -e "keycode 91 = period period period period periodcentered"
        # exec --no-startup-id urxvt -name dropdown -e tmux
        # exec --no-startup-id urxvt -name math -e julia
        # exec --no-startup-id telegram-desktop
      ];

      menu = "rofi -theme ~/.config/rofi/onemon.rasi -show run";

      gaps = {
        inner = 10;
        outer = 0;
        smartBorder = "on";
      };

      modes = {
        "${mode_system}" = {
          l  = "exec --no-startup-id $locker, mode default";
          e  = "exec --no-startup-id i3-msg exit, mode default";
          s  = "exec --no-startup-id $locker && systemctl suspend, mode default";
          r  = "exec --no-startup-id systemctl reboot, mode default";
          "Shift + s" = "exec --no-startup-id systemctl poweroff -i, mode default";
          Return = "mode default";
          Escape = "mode default";
        };
      };

      keybindings = lib.mkOptionsDefault {
        # switch to workspace
        "${mod}+1" = "workspace ${ws1}";
        "${mod}+2" = "workspace ${ws2}";
        "${mod}+3" = "workspace ${ws3}";
        "${mod}+4" = "workspace ${ws4}";
        "${mod}+5" = "workspace ${ws5}";
        "${mod}+6" = "workspace ${ws6}";
        "${mod}+7" = "workspace ${ws7}";
        "${mod}+8" = "workspace ${ws8}";
        "${mod}+9" = "workspace ${ws9}";
        "${mod}+0" = "workspace ${ws0}";
        # move focused container to workspace
        "${mod}+Shift+1" = "move container to workspace ${ws1} ";
        "${mod}+Shift+2" = "move container to workspace ${ws2} ";
        "${mod}+Shift+3" = "move container to workspace ${ws3} ";
        "${mod}+Shift+4" = "move container to workspace ${ws4} ";
        "${mod}+Shift+5" = "move container to workspace ${ws5} ";
        "${mod}+Shift+6" = "move container to workspace ${ws6} ";
        "${mod}+Shift+7" = "move container to workspace ${ws7} ";
        "${mod}+Shift+8" = "move container to workspace ${ws8} ";
        "${mod}+Shift+9" = "move container to workspace ${ws9} ";
        "${mod}+Shift+0" = "move container to workspace ${ws0} ";
        # general movements
        "${mod}+Escape" = "workspace back_and_forth";
        "${mod}+Shift+q" = "kill";
        "${mod}+p" = "mode ${mode_system}";
        # reduce and increase directly outer and inner gaps
        "${mod}+Mod1+Left" = "gaps inner current minus 5";
        "${mod}+Mod1+Right" = "gaps inner current plus 5";
        "${mod}+Mod1+Up" = "gaps inner current set 0";
        "${mod}+Mod1+Down" = "gaps inner current set 10";
        # Pulse Audio controls
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 0 +5%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 0 -5%";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle";
        # Sreen brightness controls
        "XF86MonBrightnessDown" = "exec xbacklight -dec 5";
        "XF86MonBrightnessUp" = "exec xbacklight -inc 5";
        # Touchpad controls
        "XF86TouchpadToggle" = "exec ~/.scripts/toggletouchpad.sh";
        # Media player controls
        "XF86AudioPlay" = "exec playerctl play";
        "XF86AudioPause" = "exec playerctl pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        # RETURN
        "${mod}+Return" = "exec urxvt";
        "${mod}+Shift+Return" = "exec urxvt -e tmux";
        # TAB
        #"${mod}+Tab" = "workspace next";
        #"${mod}+Shift+Tab" = "workspace prev";
        # Q
        #"${mod}+q" = "kill";
        "${mod}+q" = "exec i3wins";
        "${mod}+Shift+q" = "kill";
        # w
        "${mod}+w" = "layout tabbed";
        "${mod}+Shift+w" = "exec urxvt -e nmtui";
        # E
        "${mod}+e" = "layout toggle split";
        #"${mod}+Shift+e exec evince";
        # R
        "${mod}+r" = "exec urxvt -e ranger";
        "${mod}+Shift+r" = "restart";
        # T
        #"${mod}+t" = "[class="TelegramDesktop"] scratchpad show ; [class="TelegramDesktop"] move position center";
        #"${mod}+Shift+t" = "exec tusk";
        # Y
        #"${mod}+Shift+y exec";
        "${mod}+Shift+y" = "exec --no-startup-id ~/.scripts/i3cmds/i3resize left";
        # U
        #"${mod}+u" = "[instance="dropdown"] scratchpad show; [instance="dropdown"] move position center";
        "${mod}+Shift+u " = "exec --no-startup-id ~/.scripts/i3cmds/i3resize down";
        # I
        "${mod}+i" = "exec urxvt -e htop";
        "${mod}+Shift+i" = "exec --no-startup-id ~/.scripts/i3cmds/i3resize up";
        # O
        "${mod}+o" = "sticky toggle";
        "${mod}+Shift+o" = "exec --no-startup-id ~/.scripts/i3cmds/i3resize right";
        #"${mod}+Mod1+o" = "exec xrandr --output eDP-1 --auto --output HDMI-1 --auto --left-of eDP-1; exec killall conky && xinput --set-prop 15 308 1; restart;";
        # P
        #"${mod}+p mode "$mode_system"";
        #"${mod}+Mod1+p" = "exec optirun intel-virtual-output; exec "sh ~/.scripts/load-wide.sh"; exec "~/.config/polybar/launch.sh"";
        "${mod}+shift+p" = "exec system-config-priter";
        # A
        #"${mod}+a focus parent";
        #"${mod}+a" = "[instance="math"] scratchpad show; [instance="math"] move position center";
        # S
        #"${mod}+s layout stacking";
        #"${mod}+s [instance="spt"] scratchpad show; [instance="spt"] move position center";
        #"${mod}+s" = "[class="Todoist"] scratchpad show; [class="Todoist"] move position center";
        "${mod}+Shift+s" = "split toggle";
        # D
        "${mod}+d" = "focus mode_toggle";
        "${mod}+Shift+d" = "gaps inner current set 0; gaps outer current set 0";
        # F
        "${mod}+f" = "exec nautilus";
        "${mod}+Shift+f" = "fullscreen toggle";
        # G
        #"${mod}+g exec code";
        #"${mod}+Shift+g exec ~/.scripts/load_layout.sh";; #exec --no-startup-id compton
        # H
        "${mod}+h" = "focus left";
        "${mod}+Shift+h" = "move left 30";
        # J
        "${mod}+j" = "focus down";
        "${mod}+Shift+j" = "move down 30";
        # K
        "${mod}+k" = "focus up";
        "${mod}+Shift+k" = "move up 30";
        # L
        "${mod}+l" = "focus right";
        "${mod}+Shift+l" = "move right 30";
        # Z
        "${mod}+z" = "toggle split";
        # X
        "${mod}+Shift+x" = "exec $locker";
        #"${mod}+Shift+x exec i3lock -i /home/birromer/Pictures/wallpapers/dark-souls-firelink.png";
        # C
        "${mod}+c" = "exec zotero";
        #"${mod}+Shift+c" = "exec calibre";
        #"${mod}+Shift+c        gaps inner current set 10; gaps outer current set 10";
        # V
        "${mod}+v" = "exec urxvt -e neomutt";
        "${mod}+Shift+v" = "floating toggle; sticky toggle; exec --no-startup-id ~/.scripts/i3cmds/bottomleft";
        # B
        "${mod}+b bar" = "mode toggle";
        "${mod}+Shift+b" = "floating toggle; sticky toggle; exec --no-startup-id ~/.scripts/i3cmds/bottomright";
        # N
        "${mod}+n" = "exec firefox-developer-edition";
        #"${mod}+Shift+n" = "exec jupyter-notebook";
        # M
        "${mod}+m" = "exec nautilus";
        "${mod}+Shift+m" = "exec mcomix";
        # LEFT
        "${mod}+Left" = "focus left";
        "${mod}+Shift+Left" = "move left";
        # DOWN
        "${mod}+Down" = "focus down";
        "${mod}+Shift+Down" = "move down";
        # UP
        "${mod}+Up" = "focus up";
        "${mod}+Shift+Up" = "move u";
        # RIGHT
        "${mod}+Right" = "focus right";
        "${mod}+Shift+Right" = "move right";
        # SPACE
        "${mod}+space" = "exec rofi -theme ~/.config/rofi/onemon.rasi -show run";
        "${mod}+Shift+space" = "floating toggle";
        # DELETE
        "${mod}+Shift+Delete" = "exec lmc truemute ; exec $truepause ; workspace lmao ; exec urxvt -e htop ; exec urxvt -e ranger";
      };

      bars = [
        {

          fonts = {
            names = [ "Source Code Pro" ] ++
                    [ "FontAwesome" ] ++
                    [ "PowerlineSymbols" ] ++
                    [ "Material Icons" ];
            size = 10.5;
          };
          workspaceButtons = true;
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
          colors = {
            background = "${bg}";
            statusline = "${fg}";
            separator  = "${sp}";
            focusedWorkspace = {
              border =  "${bg}";
              background = "${ac}";
              text = "${white}";
            };
            activeWorkspace = {
              border =  "${bg}";
              background = "${fg-alt}";
              text = "${white}";
            };
            inactiveWorkspace = {
              border =  "${bg}";
              background = "${bg}";
              text = "${white2}";
            };
            urgentWorkspace = {
              border =  "${bg}";
              background = "${bd}";
              text = "${white}";
            };
          };
        }
      ];
    };
  };
}
