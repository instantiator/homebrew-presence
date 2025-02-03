class PresenceCli < Formula
    desc "Tools for formatting and posting threads to social networks."
    homepage "https://instantiator.dev/presence"
    url "https://github.com/instantiator/presence/releases/download/0.3.0/Presence.zip"
    version "0.3.0"
    license "MIT"
    
    # get sha: shasum -a 256 Presence.zip
    sha256 "f6368eabae88b6ca176c9b4f148468492427d0da5d62e8c33e35d6b3f55e7f93"

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