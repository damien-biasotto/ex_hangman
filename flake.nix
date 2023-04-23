{
  description = "A very basic flake for elixir dev env";

  inputs = {
    dictionary = {
      url = "https://coding-gnome.com/courses/e4p2/assets/words.txt";
      type = "file";
      flake = false;
    };
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, utils, dictionary }: 
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
        DICTIONARY_FILEPATH="${dictionary}";
        shellHook = ''
        '';
      };
    }
  );
}
