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
    hash = "sha256-oShLe2Q3fBKM3bnHDXJTkNJR6q/WvZexPqxHQ6/sxqQ=";
  };

  npmDepsHash = "sha256-AJRv/2aGmY7tA0ixrSmzx8NiA67rmq/U9CaAZR8kwV8=";

  # Skip lint as it's not needed for packaging and may require git
  npmBuildScript = "build";
  preBuild = ''
    # Replace build script to skip lint (runs: npm run lint && tsc -b && vite build)
    substituteInPlace package.json \
      --replace-fail '"build": "npm run lint && tsc -b && vite build"' \
        '"build": "tsc -b && vite build"'
  '';

  # Don't install node_modules to output; we only need the built static files
  dontNpmInstall = true;
  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

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
