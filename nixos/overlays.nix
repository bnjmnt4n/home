{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlay
    inputs.nixpkgs-wayland.overlay
    (self: super: {
      fluminurs = with pkgs;
        rustPlatform.buildRustPackage rec {
          name = "fluminurs-${version}";
          version = "ebfbbbcb3a5ea2fc1ebb5563d2861558084eec36";

          nativeBuildInputs = [
            rustc cargo
            pkgconfig
          ];

          buildInputs = [
            openssl
          ];

          src = fetchFromGitHub {
            owner = "indocomsoft";
            repo = "fluminurs";
            rev = version;
            sha256 = "1xbpbwfvj0hxdhi195j9anyv1rji9g0aczsjg7h52rvl8ddvvkq2";
          };

          cargoSha256 = "152m3204kcjv85hh83923q3ymni2n194y6k1g30lmlzlvh5h73s4";

          meta = with stdenv.lib; {
            description = "Luminus CLI";
            homepage = https://github.com/indocomsoft/fluminurs;
            license = licenses.mit;
            platforms = platforms.all;
          };
        };
    })
  ];
}
