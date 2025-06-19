{ ... }:
{
  programs.git = {
    enable = true;
    userName = "oliwia";
    userEmail = "24637207+kkanden@users.noreply.github.com";
    aliases = {
      lg = "log --oneline --graph --all --decorate --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(yellow)%h%Creset - %C(blue)%an <%ae>%Creset - %C(green)%ad%Creset -%C(red)%d%Creset %s'";
      lgu = "log --oneline --graph origin..HEAD";
    };
    extraConfig = {
      init.defaultbranch = "main";
      core = {
        editor = "nvim";
        autocrlf = false;
      };
      status = {
        branch = true;
        short = true;
        showStash = true;
      };
      diff = {
        context = 3;
        renames = "copies";
        interHunkContext = 10;
      };
      push = {
        autoSetupRemote = true;
        default = "current";
      };
      pull = {
        rebase = true;
        default = "current";
      };
      rebase = {
        autoStash = true;
      };
      url = {
        "https://github.com/" = {
          insteadOf = "gh:";
        };
      };
      colors = {
        diff = {
          meta = "black bold";
          frag = "magenta";
          context = "white";
          whitespace = "yellow reverse";
        };
      };
    };
  };
}
