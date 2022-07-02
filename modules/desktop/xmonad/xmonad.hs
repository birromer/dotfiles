{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE TypeFamilies #-}

import qualified Data.Map as M
import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import XMonad
import XMonad.Actions.UpdatePointer (updatePointer)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.Spacing
import qualified XMonad.StackSet as W
import XMonad.Util.Cursor
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth = 0

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod1Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces = map (wrap " " "") ["α", "β", "γ", "δ", "ε", "Ϛ", "ζ", "η", "θ"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor = "#ebbcba"

myFocusedBorderColor = "#908caa"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- launch a terminal
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf),
      -- launch Firefox
      ((modm .|. shiftMask, xK_f), spawn "firefox"),
      -- lock screen
      ((modm .|. shiftMask, xK_x), spawn "i3lock -c \"#f6c177\" && sleep 1 && loginctl suspend"),
      -- swap between US and DE layouts
      ((modm .|. shiftMask, xK_i), spawn "setxkbmap us && notify-send Layout US"),
      ((modm .|. shiftMask, xK_o), spawn "setxkbmap de && notify-send Layout DE"),
      ((modm .|. shiftMask, xK_n), spawn "setxkbmap jp && notify-send Layout JP"),
      -- take screenshot
      ((0, xK_Print), spawn "scrot '%d_%m_%Y_$wx$h_scrot.png' -e 'mv $f ~/Pictures/screenshots/' -z -m"),
      -- launch dmenu
      ((modm, xK_d), spawn "dmenu_run -nf '#e0def4' -nb '#191724' -sf '#191724' -sb '#f6c177' -fn 'JetBrains-15'"),
      -- launch gmrun
      --  , ((modm .|. shiftMask, xK_p     ), spawn "lxsession-logout")

      -- close focused window
      ((modm, xK_q), kill),
      -- Rotate through the available layout algorithms
      ((modm, xK_space), sendMessage NextLayout),
      --  Reset the layouts on the current workspace to default
      ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
      -- Resize viewed windows to the correct size
      ((modm, xK_n), refresh),
      -- Move focus to the next window
      ((modm, xK_Tab), windows W.focusDown),
      -- Move focus to the next window
      ((modm, xK_j), windows W.focusDown),
      -- Move focus to the previous window
      ((modm, xK_k), windows W.focusUp),
      -- Move focus to the master window
      ((modm, xK_m), windows W.focusMaster),
      -- Swap the focused window and the master window
      ((modm, xK_h), windows W.swapMaster),
      -- Swap the focused window with the next window
      ((modm .|. shiftMask, xK_j), windows W.swapDown),
      -- Swap the focused window with the previous window
      ((modm .|. shiftMask, xK_k), windows W.swapUp),
      -- Shrink the master area
      ((modm .|. shiftMask, xK_h), sendMessage Shrink),
      -- Expand the master area
      ((modm .|. shiftMask, xK_l), sendMessage Expand),
      ((modm, xK_c), spawn "flameshot gui"),
      -- Push window back into tiling
      ((modm, xK_t), withFocused $ windows . W.sink),
      -- XF86AudioMute
      ((0, 0x1008ff12), spawn "pamixer -t "), -- XF86AudioLowerVolume
      ((0, 0x1008ff11), spawn "pamixer -d 5"),
      -- XF86AudioRaiseVolume
      ((0, 0x1008ff13), spawn "pamixer -i 5"),
      ((0, xF86XK_AudioMicMute), spawn "pactl set-source-mute 0 toggle"),
      ((0, xF86XK_MonBrightnessUp), spawn "brightnessctl set +10%"),
      ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 10%-"),
      -- Increment the number of windows in the master area
      ((modm, xK_comma), sendMessage (IncMasterN 1)),
      -- Deincrement the number of windows in the master area
      ((modm, xK_period), sendMessage (IncMasterN (-1))),
      -- Toggle the status bar gap
      -- Use this binding with avoidStruts from Hooks.ManageDocks.
      -- See also the statusBar function from Hooks.DynamicLog.
      --
      -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

      -- Quit xmonad
      ((modm .|. shiftMask, xK_q), io exitSuccess),
      -- Restart xmonad
      ((modm .|. shiftMask, xK_c), spawn "xrandr --auto && xmonad --restart")
      -- Run xmessage with a summary of the default keybindings (useful for beginners)
      --, ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
      ++
      --
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      --
      [ ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]
      ++
      --
      -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
      -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
      --
      [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_r, xK_e] [0 ..],
          (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
      ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings XConfig {XMonad.modMask = modm} =
  -- mod-button1, Set the window to floating mode and move by dragging
  [ ( (modm, button1),
      \w ->
        focus w >> mouseMoveWindow w
          >> windows W.shiftMaster
    ),
    -- mod-button2, Raise the window to the top of the stack
    ((modm, button2), \w -> focus w >> windows W.shiftMaster),
    -- mod-button3, Set the window to floating mode and resize by dragging
    ( (modm, button3),
      \w ->
        focus w >> mouseResizeWindow w
          >> windows W.shiftMaster
    )
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full) ||| fullscreenFull Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = spacingRaw True (undefined :: Border) False (Border 3 3 3 3) True $ Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 3 / 5

    -- Percent of screen to increment by when resizing panes
    delta = 3 / 200

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook =
  composeAll
    [ className =? "MPlayer" --> doCenterFloat,
      className =? "Gimp" --> doCenterFloat,
      className =? "lxsession-logout" --> doCenterFloat,
      isDialog --> doCenterFloat,
      resource =? "desktop_window" --> doIgnore,
      resource =? "kdesktop" --> doIgnore
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook

--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--

myPP =
  def
    { ppCurrent = xmobarColor "#f6c177" "",
      ppTitle = xmobarColor "#f6c177" "" . shorten 50,
      ppVisible = xmobarColor "#6e6a86" "",
      ppUrgent = xmobarColor "#eb6f92" ""
    }

myLogHook xmproc = do
  dynamicLogWithPP $ myPP {ppOutput = hPutStrLn xmproc}
  updatePointer (0.5, 0.5) (0, 0)

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
  setWMName myWMName
  setDefaultCursor xC_left_ptr
  spawnOnce "nitrogen --restore &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
  xmonad $ docks (defaults xmproc)

myWMName = "LG3D"

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults xmproc =
  def
    { -- simple stuff
      terminal = myTerminal,
      focusFollowsMouse = myFocusFollowsMouse,
      clickJustFocuses = myClickJustFocuses,
      borderWidth = myBorderWidth,
      modMask = myModMask,
      workspaces = myWorkspaces,
      normalBorderColor = myNormalBorderColor,
      focusedBorderColor = myFocusedBorderColor,
      -- key bindings
      keys = myKeys,
      mouseBindings = myMouseBindings,
      -- hooks, layouts
      layoutHook = myLayout,
      manageHook = myManageHook,
      handleEventHook = myEventHook,
      logHook = myLogHook xmproc,
      startupHook = myStartupHook
    }
