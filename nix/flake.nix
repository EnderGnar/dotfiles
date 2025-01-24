{
  description = "Yannik's darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    username = "yannik";
    configuration = { pkgs, ... }: {
      
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.vim
          pkgs.tmux
          pkgs.git
          pkgs.obsidian
          pkgs.google-chrome
          pkgs.vscode
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      system.defaults = {
	dock = {
	  persistent-apps = [
	    "${pkgs.obsidian}/Applications/Obsidian.app"
	    "${pkgs.google-chrome}/Applications/Google Chrome.app"
	    "${pkgs.vscode}/Applications/Visual Studio Code.app"
	    "/System/Applications/Calendar.app"
	    "/System/Applications/System Settings.app"
	  ];
	};
        finder.FXPreferredViewStyle = "clmv";
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#macbook
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set.
    darwinPackages = self.darwinConfigurations."macbook".pkgs;
  };
}
