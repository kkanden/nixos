{ pkgs, lib, ... }:
{

  programs.neovim = {
    enable = true;
    plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
  };

  # link treesitter parser to somewhere in vim.opt.rtp
  home.activation =
    let
      grammarsPath = pkgs.symlinkJoin {
        name = "nvim-treesitter-grammars";
        paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      };
    in
    {
      linkTreesitterParsers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rm -rf $HOME/.local/share/nvim/parser
        mkdir -p $HOME/.local/share/nvim/parser
        ln -rs ${grammarsPath}/parser/* $HOME/.local/share/nvim/parser
      '';
    };
}
