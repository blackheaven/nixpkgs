{ mkDerivation, lib, fetchFromGitLab
, plasma-framework
, qt5 }:

mkDerivation rec {
  version = "1.5.4";
  pname = "fokus";

  src = fetchFromGitLab {
    owner = "divinae";
    repo = "focus-plasmoid";
    rev = "v${version}";
    sha256 = "19nndmqfzdcg7lzcifxa17m2mx85dlf4m2wxzr72gf78h4yj0ahv";
  };

  buildInputs  = [
    plasma-framework
    # qt5.qtbase
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/usr/share/plasma/plasmoids
    plasmapkg2 -i ./package -p $out/usr/share/plasma/plasmoids/fokus
  '';

  meta = with lib; {
    description = "Simple pomodoro timer plasmoid";
    homepage = "https://store.kde.org/p/1308861/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ gdifolco ];
    platforms = platforms.unix;
  };
}

