TERMUX_PKG_HOMEPAGE=http://www.squid-cache.org
TERMUX_PKG_DESCRIPTION="Full-featured Web proxy cache server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.0.1"
TERMUX_PKG_SRCURL=https://github.com/squid-cache/squid/archive/refs/tags/SQUID_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=8fce98d4e73c657fc70703d7f75f06669c253bdcc74d8441aa8c4b3b3433a894
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+(_\d+)+'
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libc++, libcrypt, libexpat, libgnutls, libltdl, libnettle, libxml2, openldap, resolv-conf"

#disk-io uses XSI message queue which are not available on Android.
# Option 'cache_dir' will be unusable.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_memrchr=yes
ac_cv_func_strtoll=yes
ac_cv_search_shm_open=
ac_cv_lib_sasl2_sasl_errstring=no
ac_cv_dbopen_libdb=no
squid_cv_gnu_atomics=yes
--datarootdir=/data/system/squid/share/squid
--libexecdir=/data/system/squid/libexec/squid
--mandir=/data/system/squid/share/man
--sysconfdir=/data/system/squid/etc/squid
--with-logdir=/data/system/squid/var/log/squid
--with-pidfile=/data/system/squid/var/run/squid.pid
--disable-external-acl-helpers
--disable-strict-error-checking
--enable-auth
--enable-auth-basic
--enable-auth-digest
--enable-auth-negotiate
--enable-auth-ntlm
--enable-delay-pools
--enable-linux-netfilter
--enable-removal-policies="lru,heap"
--enable-snmp
--disable-disk-io
--disable-storeio
--enable-translation
--with-dl
--without-openssl
--disable-ssl-crtd
--with-size-optimizations
--with-gnutls
--with-libnettle
--without-mit-krb5
--with-maxfd=256
"

termux_step_pre_configure() {
	# needed for building cf_gen
	export BUILDCXX=g++
	# else it picks up our cross CXXFLAGS
	export BUILDCXXFLAGS=' '
	autoreconf -fi
}

termux_step_post_massage() {
	# Ensure that necessary directories exist, otherwise squid fill fail.
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/data/system/squid/var/cache/squid"
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/data/system/squid/var/log/squid"
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/data/system/squid/var/run"
}
