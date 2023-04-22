{
  description = "A very basic flake for elixir dev env";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, utils }: 
  utils.lib.eachDefaultSystem (system: 
    let pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          elixir
          elixir_ls
          nixfmt  
          gitui
        ];

        shellHook = ''
        
        '';
      };
    }
  );
}
