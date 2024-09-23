{
    description = "Bitcoin core security protocol 256k1.";

    inputs =
    {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs =
    {
        self,
        nixpkgs,
        flake-utils
    }: 
    with flake-utils.lib; eachDefaultSystem (system: 

        let pkgs = nixpkgs.legacyPackages.${system};

            in rec {

                packages = { 
                    secp256k1 = pkgs.stdenv.mkDerivation {
                        name = "secp256k1";
                        src = builtins.fetchGit {
                            url = "https://github.com/nkarl/secp256k1-rev-ac83be33d0956faf6b7f61a60ab524ef7d6a473a";
                            ref = "master";
                            rev = "ac83be33d0956faf6b7f61a60ab524ef7d6a473a";
                        };

                    nativeBuildInputs = [
                        pkgs.autoreconfHook
                    ];

                    runCommand = ''
                        ./autogen.sh && \
                        ./configure --prefix=$out && \
                        make && \
                        make install
                    '';
            };
        };

        defaultPackage = packages.secp256k1;
    });
}
