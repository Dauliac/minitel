{ ... }:
{
  config = {
    perSystem =
      {
        config,
        pkgs,
        inputs',
        ...
      }:
      {
        devShells.default = pkgs.mkShell {
          packages =
            with pkgs;
            [
              lefthook
              convco
              git
              esptool
              adafruit-ampy
              minicom
              python3Packages.pyserial
              (pkgs.python3.withPackages (python-pkgs: [
                config.packages.upynitel-py
              ]))
            ]
            ++ [
              config.packages.flash-micropython-esp32
              config.packages.upynitel-py
            ];
          shellHook = ''
            export PIP_PREFIX=$(pwd)/_build/pip_packages
            export PYTHONPATH="$PIP_PREFIX/${pkgs.python3.sitePackages}:$PYTHONPATH"
            export PATH="$PIP_PREFIX/bin:$PATH"
            unset SOURCE_DATE_EPOCH
            ${pkgs.lefthook}/bin/lefthook install --force
          '';
        };
      };
  };
}
