{ inputs, ... }:
{
  config.perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      packages = {
        micropython-esp32 = pkgs.stdenv.mkDerivation {
          name = "micropython-esp32";
          src = pkgs.fetchurl {
            url = "https://micropython.org/resources/firmware/ESP32_GENERIC-20241129-v1.24.1.bin";
            sha256 = "sha256-IdYbUkGy4A+ad0p5cHn8KHtmvrBx369LazQL+E0V8Eg=";
          };
          dontUnpack = true;
          installPhase = ''
            set -x
            mkdir -p $out/bin
            cp $src $out/bin/micropython-esp32.bin
          '';
        };
        flash-micropython-esp32 = pkgs.writeScriptBin "flash-micropython-esp32" ''
          PORT=$1
          if [[ -z "$PORT" ]]; then
            PORT=/dev/ttyUSB0
          fi
          ${pkgs.esptool}/bin/esptool.py \
            --chip esp32 \
            --port $PORT \
            erase_flash
          ${pkgs.esptool}/bin/esptool.py \
            --chip esp32 \
            --port $PORT \
            --baud 460800 \
            write_flash -z 0x1000 \
            ${config.packages.micropython-esp32}/bin/micropython-esp32.bin
        '';
        upynitel-py = pkgs.python3Packages.buildPythonPackage rec {
          pname = "upynitel";
          version = "1.0";
          src = inputs.minitel-esp32;
          format = "other";
          doCheck = false;
          meta = {
            description = "Minitel library for MicroPython";
            homepage = "https://github.com/iodeo/Minitel-ESP32";
          };
          installPhase = ''
            mkdir -p $out/${pkgs.python3.sitePackages}/upynitel
            cp ${src}/upython/upynitel/upynitel/upynitel.py $out/${pkgs.python3.sitePackages}/upynitel/__init__.py
          '';
        };
        shell = pkgs.writeScriptBin "shell" ''
          PORT=$1
          if [[ -z "$PORT" ]]; then
            PORT=/dev/ttyUSB0
          fi
          set -o errexit
          set -o pipefail
          set -o nounset
          ${pkgs.picocom}/bin/picocom -b 115200 $PORT
        '';
        sync = pkgs.writeShellScriptBin "sync" ''
          PORT=$1
          if [[ -z "$PORT" ]]; then
            PORT=/dev/ttyUSB0
          fi
          set -x
          set -o errexit
          set -o pipefail
          set -o nounset
          (
            cd src
            ${pkgs.adafruit-ampy}/bin/ampy --port $PORT put ./boot.py
            ${pkgs.adafruit-ampy}/bin/ampy --port $PORT put ./main.py
            ${pkgs.adafruit-ampy}/bin/ampy --port $PORT put ./minitel
            ${pkgs.adafruit-ampy}/bin/ampy --port $PORT put ./xana.vdt
          )
        '';
      };
    };
}
