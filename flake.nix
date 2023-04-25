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
          inotify-tools
        ];
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
          sub-dir-locals =  pkgs.writeTextFile {
            name = ".dir-locals.el";
            text = ''
               ((elixir-ts-mode
  . ((eglot-workspace-configuration
      . ((:elixirLS . (:projectDir (locate-dominating-file default-directory
                                               ".dir-locals.el")))))))
(heex-ts-mode
  . ((eglot-workspace-configuration
      . ((:elixirLS . (:projectDir (locate-dominating-file default-directory
                                               ".dir-locals.el"))))))))
            '';
          };
        in
          ''
          cat ${root-dir-locals} > .dir-locals.el
          cat ${sub-dir-locals} > hangman/.dir-locals.el
          cat ${sub-dir-locals} > text_client/.dir-locals.el
          cat ${sub-dir-locals} > dictionary/.dir-locals.el
        '';
      };
    }
  );
}
