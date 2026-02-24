{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    quickshell
  ];

  # QML configuration for Quickshell
  home.file.".config/quickshell/main.qml".text = ''
    import QtQuick
    import Quickshell
    import Quickshell.Wayland

    ShellRoot {
      variants: [
        PanelWindow {
          anchors {
            top: true
            left: true
            right: true
          }
          height: 32
          color: "#1c1c1c" // base01

          Rectangle {
            anchors.fill: parent
            color: "#222222" // base00
            opacity: 0.8
          }

          Row {
            anchors.centerIn: parent
            Text {
              text: "Quickshell Active - #FF8C00" // base09
              color: "#c2c2b0" // base05
              font.pixelSize: 14
              font.family: "JetBrainsMono Nerd Font"
            }
          }
        }
      ]
    }
  '';
}
