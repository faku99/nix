{ self, ... }:
{
  den.aspects.noctalia.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      secretsFile = "${self}/secrets/bitwarden.yaml";
      bw = lib.getExe pkgs.bitwarden-cli;
    in
    {
      home.packages = [ pkgs.bitwarden-cli ];

      sops.secrets = {
        "bitwarden/server_url".sopsFile = secretsFile;
        "bitwarden/client_id".sopsFile = secretsFile;
        "bitwarden/client_secret".sopsFile = secretsFile;
      };

      programs.noctalia.settings.plugins.enabled = [ "noctalia/bitwarden" ];

      # API-key login so the noctalia plugin's unlock panel only has to handle
      # unlocking, not the initial account login.
      # Must run after reloadSystemd, not sops-nix: that's the step where
      # sd-switch actually restarts sops-nix.service with the new secret
      # manifest (the sops-nix activation entry just nudges whatever unit
      # is currently loaded, which is stale on a run that adds secrets).
      home.activation.bitwardenLogin = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
        # bw refuses to change server config while logged in, so only touch it
        # right before an actual login attempt, not on every activation.
        if ! ${bw} login --check --quiet; then
          $DRY_RUN_CMD ${bw} config server "$(cat ${
            config.sops.secrets."bitwarden/server_url".path
          })" >/dev/null
          BW_CLIENTID="$(cat ${config.sops.secrets."bitwarden/client_id".path})" \
          BW_CLIENTSECRET="$(cat ${config.sops.secrets."bitwarden/client_secret".path})" \
          $DRY_RUN_CMD ${bw} login --apikey --nointeraction --quiet
        fi
      '';
    };
}
