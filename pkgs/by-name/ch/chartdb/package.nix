{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "chartdb";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "chartdb";
    repo = "chartdb";
    tag = "v${version}";
    hash = lib.fakeHash;
  };

  npmDepsHash = lib.fakeHash;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Database diagrams editor that allows you to visualize and design your DB with a single query";
    homepage = "https://chartdb.io";
    changelog = "https://github.com/chartdb/chartdb/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
}
