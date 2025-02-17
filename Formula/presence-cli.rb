class PresenceCli < Formula
    desc "Tools for formatting and posting threads to social networks."
    homepage "https://instantiator.dev/presence"
    url "https://github.com/instantiator/presence/releases/download/0.3.4/Presence.zip"
    version "0.3.4"
    license "MIT"
    
    # get sha: shasum -a 256 Presence.zip
    sha256 "8d8589c27005d1491cf74b82d339052a4b9e5b938aa01ef0660400960e4fcab8"

    def install
        # linux
        bin.install "linux-x64/self-contained/Presence.SocialFormat.Console" if OS.linux?
        bin.install "linux-x64/self-contained/Presence.Posting.Console" if OS.linux?
        # mac
        bin.install "osx-x64/self-contained/Presence.SocialFormat.Console" if OS.mac?
        bin.install "osx-x64/self-contained/Presence.Posting.Console" if OS.mac?
    end

    def caveats; <<-EOS
        You'll need to do a little configuration to connect to social networks.
        See: https://instantiator.dev/presence
    EOS
    end
end