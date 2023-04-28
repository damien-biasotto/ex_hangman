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
          tree
        ] 
        ++ pkgs.lib.optional pkgs.stdenv.isLinux pkgs.inotify-tools
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [CoreFoundation CoreServices])
        ;
        DICTIONARY_FILEPATH="${dictionary}";
        shellHook = let
          root-dir-locals = pkgs.writeTextFile {
            name = ".dir-locals.el";
            text = ''
               ((nil . ((eval . (add-to-list 'eglot-server-programs '((elixir-ts-mode heex-ts-mode) . ("${pkgs.elixir_ls}/bin/elixir-ls"))))
(eval . (add-to-list 'auto-mode-alist '("\\.exs?\\'" . elixir-ts-mode)))
(eval . (add-to-list 'auto-mode-alist '("\\.heex\\'" . heex-ts-mode)))
(eval . (add-hook 'elixir-ts-mode-hook 'eglot-ensure))
(eval . (add-hook 'heex-ts-mode-hook 'eglot-ensure)))))
            '';
          };

          helix-lang = pkgs.writeTextFile {
            name = "languages.toml";
            text = ''
            [[language]]
            name = "elixir"
            language-server = { command = "${pkgs.elixir_ls}/bin/elixir-ls", args = ["--sdtin"]}
            auto-format = true
            '';
          };
        in
          ''
          mkdir -p .helix
          cat ${helix-lang} > .helix/${helix-lang.name}
          
          cat ${root-dir-locals} > .dir-locals.el
        '';
      };
    }
  );
}
