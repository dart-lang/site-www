# To learn more about how to use Nix to configure your environment
# see: https://firebase.google.com/docs/studio/customize-workspace
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-25.05"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.nodejs_24
  ];

  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];

    # Enable previews
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["./dash_site" "serve"];
          manager = "web";
          env = {
            # Environment variables to set for your server
            PORT = "$PORT";
          };
        };
      };
    };

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        get-submodule = "git submodule update --init --recursive";
        dart-pub-get = "dart pub get";
      };
      # Runs when the workspace is (re)started
      onStart = {
        dart-pub-get = "dart pub get";
      };
    };
  };
}
