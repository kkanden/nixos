{
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 40;
      START_CHARGE_THRESH_BAT1 = 40;
      STOP_CHARGE_THRESH_BAT0 = 60;
      STOP_CHARGE_THRESH_BAT1 = 60;

      DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
    };
  };
}
