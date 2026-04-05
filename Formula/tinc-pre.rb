class TincPre < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://www.tinc-vpn.org/packages/tinc-1.1pre18.tar.gz"
  sha256 "2757ddc62cf64b411f569db2fa85c25ec846c0db110023f6befb33691f078986"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.tinc-vpn.org/download/"
    regex(/href=.*?tinc[._-]v?(\d+(?:\.\d+)+pre\d+)\.t/i)
  end

  depends_on "lzo"
  depends_on "openssl@3"
  depends_on "readline"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  patch do
    url "https://github.com/gsliepen/tinc/commit/bde968105c02f2d9a24160a22a7acbb758e7d93c.patch?full_index=1"
    sha256 "bc6a443e38f0b66a1fb1736df564b7acf6838e3050f6f92c9a39f887806e4ccc"
  end

  def install
    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  service do
    run [opt_sbin/"tincd", "-D", "-n", "main"]
    keep_alive true
    require_root true
    working_dir etc/"tinc"
    log_path var/"log/tinc/stdout.log"
    error_log_path var/"log/tinc/stderr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/tincd --version")
  end
end
