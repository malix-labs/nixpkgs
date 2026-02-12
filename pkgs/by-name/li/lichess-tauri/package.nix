{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri_1,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  libsoup_2_4,
  webkitgtk_4_0,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "lichess-tauri";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "fitztrev";
    repo = "lichess-tauri";
    tag = "v${version}";
    hash = "sha256-I7NHuXJmQiQGv0QWG/ZbEDxFmaWpfBtZOahZ2qLt/j8=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-/JbYYNfzxEC5A3IdQ4hrlH32B5fnANFGDQWDITQGqm0=";
  };

  npmRoot = ".";

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  cargoLock = {
    lockFile = "${src}/src-tauri/Cargo.lock";
    outputHashes = {
      "tauri-plugin-oauth-0.0.0-alpha.0" = "sha256-+1RAwWuPKH58aXL/m6jbbT5RNBXAI1hkOm/E8Omskos=";
    };
  };

  env = {
    PUPPETEER_SKIP_DOWNLOAD = "1";
    OPENSSL_NO_VENDOR = "1";
  };

  nativeBuildInputs = [
    cargo-tauri_1.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
    libsoup_2_4
    webkitgtk_4_0
  ];

  meta = {
    description = "Desktop app for Lichess external engine";
    homepage = "https://github.com/fitztrev/lichess-tauri";
    license = lib.licenses.agpl3Only;
    broken = true;
    maintainers = with lib.maintainers; [ malix ];
    mainProgram = "lichess-tauri";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
