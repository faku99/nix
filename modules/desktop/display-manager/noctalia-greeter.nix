{ inputs, ... }:
{
  den.aspects.displayManager.noctalia-greeter.nixos =
    { config, ... }:
    {
      imports = [ inputs.noctalia-greeter.nixosModules.default ];

      services.displayManager.noctalia-greeter = {
        enable = true;
        cursorTheme.package = config.stylix.cursor.package;
        settings = {
          keyboard = {
            layout = "us";
            variant = "intl";
          };
          cursor = {
            theme = config.stylix.cursor.name;
            size = config.stylix.cursor.size;
          };
        };
      };
    };
}
