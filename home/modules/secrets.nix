{lib, ...}:
with lib; {
  options = {
    secrets = {
      rbw = {
        email = mkOption {
          type = types.str;
          default = "lucas@elisei.ch";
        };
        base_url = mkOption {
          type = types.str;
          default = "https://vaultwarden.elisei.ch";
        };
      };
    };
  };
}
