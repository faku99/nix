{
  # host keys aren't persisted - revisit once the impermanence aspect exists
  den.aspects.openssh.nixos.services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
