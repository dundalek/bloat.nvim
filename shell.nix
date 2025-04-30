with import <nixpkgs> { };
mkShell {
buildInputs = [
babashka
luajitPackages.busted
luajitPackages.luacov
luajitPackages.vusted
neovim
watchexec # for running tests in watch mode
];
shellHook = ''
'';
}
