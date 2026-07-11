{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "omp-bin";
  version = "18.5.1";

  src =
    let
      sources = {
        x86_64-linux = {
          url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/omp-linux-x64";
          hash = "sha256-+3Y46C8MnQh+luFdPrg6Zi2SN0zZBxh9bU0mBeOfHjo=";
        };
        aarch64-linux = {
          url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/omp-linux-arm64";
          hash = "sha256-57gblrP585Hsivx+5kwFLOF4MpD4i7tZujbRWztOknw=";
        };
        x86_64-darwin = {
          url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/omp-darwin-x64";
          hash = "sha256-nnlsbZqh6+2fysINWTe1ezrxW5ZOuoSDrdWWZ9MVlJw=";
        };
        aarch64-darwin = {
          url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/omp-darwin-arm64";
          hash = "sha256-Kr2BYavxNUxZJUfmaeKnqfbmO+EVb6ZYZdKn2wsR/3k=";
        };
      };
      source =
        sources.${stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    in
    fetchurl source;

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/omp

    runHook postInstall
  '';

  # strip removes the embedded JS bundle from the bun-compiled binary
  dontStrip = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Coding agent for the terminal with LSP, debugging, and multi-provider LLM support";
    homepage = "https://omp.sh";
    changelog = "https://github.com/can1357/oh-my-pi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gdifolco ];
    mainProgram = "omp";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
