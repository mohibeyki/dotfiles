{ ... }:
{
  programs.wofi = {
    enable = true;

    settings = {
      show = "drun";
      width = 800;
      height = 720;
      prompt = "Search...";
      normal_window = true;
      location = "center";
      gtk-dark = true;
      allow_images = true;
      image_size = 40;
      insensitive = true;
      allow_markup = true;
      no_actions = true;
      orientation = "vertical";
      halign = "fill";
      content_halign = "fill";
    };

    style = ''
      window {
          background-color: rgba(48, 56, 60, 0.8);
          font-family: "JetBrainsMono Nerd Font", sans-serif;
          font-size: 16px;
          box-shadow: none;
      }

      #outer-box {
          padding: 0px;
      }

      #input {
          margin: 16px 16px 0px;
          padding: 16px;
          background-color: #181827;
          border: none;
          color: #a6accd;
          box-shadow: none;
          border-radius: 4px;
      }

      #input:focus {
          box-shadow: none;
      }

      #scroll {
          margin: 16px;
      }

      #inner-box {
          margin: 0px;
      }

      #img {
          margin: 8px;
      }

      #entry {
          box-shadow: none;
          border-radius: 4px;
          border: none;
      }

      #entry:selected {
          background-color: #181827;
          box-shadow: none;
          border: none;
      }

      #text {
          color: #a6accd;
      }

      #text:selected {
          color: #a6accd;
      }
    '';
  };
}
