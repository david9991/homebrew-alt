require 'formula'

class Pdf2djvu < Formula
  homepage 'http://jwilk.net/software/pdf2djvu'
  url 'https://github.com/jwilk/pdf2djvu/releases/download/0.9.17.1/pdf2djvu-0.9.17.1.tar.xz'
  sha256 '5bbbb7bdc7858a1eeac6ff270e5a323390f2abb6bd3b0b2ae08c1965272226a3'

  depends_on 'poppler'
  depends_on 'djvulibre'
  depends_on 'libxslt'
  depends_on 'gettext'
  depends_on 'graphicsmagick'
  depends_on 'autoconf'
  depends_on 'automake'
  depends_on 'pkg-config' => :build
  depends_on 'gnu-sed' => :build

  def install

    # Clang doesn't thave support for OpenMP
    if ENV.compiler == :clang
      opoo <<-EOS
        Clang currently does not have OpenMP support.
        Parallel page rendering will be disabled.
        If you have gcc, you can build pdf2djvu with gcc:
          brew install pdf2djvu --use-gcc
      EOS
    end

    system "autoreconf --force"
    system "./configure", "--prefix=#{prefix}"
    system "make install"

  end

  patch :DATA

  test do
    system "make test"
  end
end
 
__END__

--- pdf2djvu-0.9.17.1.orig/configure.ac
+++ pdf2djvu-0.9.17.1/configure.ac
@@ -73,8 +73,8 @@ do
 done
 AC_MSG_RESULT([ok])
 
-PKG_CHECK_MODULES([POPPLER], [poppler-splash >= 0.35.0])
-poppler_version=$($PKG_CONFIG --modversion poppler-splash)
+PKG_CHECK_MODULES([POPPLER], [poppler >= 0.35.0])
+poppler_version=$($PKG_CONFIG --modversion poppler)
 AC_DEFINE_UNQUOTED([POPPLER_VERSION_STRING], ["$poppler_version"], [Define to the version of Poppler])
 parse_poppler_version()
 {
