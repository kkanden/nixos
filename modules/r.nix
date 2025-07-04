{ pkgs, ... }:
let
  r-packages =
    with pkgs.rPackages;
    [
      languageserver
      data_table
      tidyverse
      ggtext
      ggh4x
      ggsci
      ggstats
      extrafont
      showtext
      labelled
      stringi
      DBI
      DT
      shiny
      shinyWidgets
      shinyalert
      bsicons
      plotly
      shinytitle
      RPostgres
      gt
      pacman
      ellipse
      bookdown
      kableExtra
      bigstep
      glmnet
      SLOPE
      knockoff
      doParallel
    ]
    ++ [ pkgs.rPackages.config ]; # have to separate to avoid conflict with variable;
in
{
  environment.systemPackages = [
    (pkgs.rWrapper.override { packages = r-packages; }) # R
  ];
}
