{ ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      width = 650;
      height = 750;
      prompt = "Search...";
      normal_window = true;
      location = "center";
      gtk-dark = true;
      allow_images = true;
      image_size = 35;
      insensitive = true;
      allow_markup = true;
      no_actions = true;
      orientation = "vertical";
      halign = "fill";
      content_halign = "fill";
    };
    style = ''
            window {
      padding: 50px;
               background-color: rgba(45, 53, 59, 0.85);
               font-family: 'BerkeleyMono Nerd Font', sans-serif;
               font-size: 15px;
            }

      #input {
      margin: 20px 15px;
      padding: 10px 20px;
               background-color: #323D43;
      border: none;
      color: #D3C6AA;
      }

      #input:focus {
        box-shadow: none;
      }

      #inner-box {
      margin: 0 15px;
      }

      #img {
      margin: 10px;
      }

      #entry:selected {
        background-color: #A7C080;
        border-radius: 5px;
      }

      #text {
      color: #D3C6AA;
      }

      #text:selected {
      color: #2D353B;
      }
    '';
  };
}
