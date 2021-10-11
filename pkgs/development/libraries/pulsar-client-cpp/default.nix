{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  version = "2.8.1";
  pname = "pulsar-client-cpp";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "pulsar";
    rev = version;
    sha256 = "09lcsgxwv0jq50fhsgfhx0npbf1zcwn3hbnq6q78fshqksbxmz7m";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Apache Pulsar - distributed pub-sub messaging system - C++ Client";
    homepage = "https://pulsar.apache.org";
    license = lib.licenses.asl20;
    maintainers = [];
    platforms = lib.platforms.linux;
  };
}
