class PresenceCli < Formula
    desc "Tools for formatting and posting threads to social networks."
    homepage "https://instantiator.dev/presence"
    url "https://github.com/instantiator/presence/releases/download/0.3.1/Presence.zip"
    version "0.3.1"
    license "MIT"
    
    # get sha: shasum -a 256 Presence.zip
    sha256 "75a49fff78bc9226c07041f76e4676f1d3bcdd33c0f1a07cdff94dbd5d95f992"

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