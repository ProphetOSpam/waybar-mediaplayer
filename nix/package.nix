{
  lib,
  stdenvNoCC,
  python312,
  feh,
  playerctl,
  gobject-introspection,
  wrapGAppsNoGuiHook,
  makeWrapper,
}: let
  python = python312.withPackages (ps:
    with ps; [
      pillow
      pycairo
      pygobject3
      syncedlyrics
    ]);
in
  stdenvNoCC.mkDerivation {
    pname = "waybar-mediaplayer";
    version = "1.0";

    src = ../.;

    nativeBuildInputs = [
      # https://discourse.nixos.org/t/running-python-scripts-works-different-in-config-than-in-shell/61206/7
      # https://nixos.org/manual/nixpkgs/unstable/#ssec-gnome-hooks
      # Why does the gobject-introspection hook not work? Beats me. It works in mkShell with
      # `packages`, but I don't know how that works differently than nativeBuildInupts here
      # The one originally passed to wrapGAppsNoGuiHook is (I believe) actually makeBinaryWrapper,
      # which ignores shell shenaniganery
      (wrapGAppsNoGuiHook.override {inherit makeWrapper;})
    ];

    buildInputs = [
      feh
      gobject-introspection
      playerctl
      python
    ];

    installPhase = ''
      mkdir $out
      cp -r $src/src $out
      cp -r $src/assets $out

      mkdir $out/bin

      install -m755 -D $out/src/mediaplayer $out/bin/mediaplayer
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        --chdir $out/src
      )
    '';

    meta = {
      mainProgram = "mediaplayer";
      description = "This is a mediaplayer for waybar.";
      homepage = "https://github.com/GabriWar/waybar-mediaplayer";
      license = lib.licenses.mit;
    };
  }
