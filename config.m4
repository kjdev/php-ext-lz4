dnl config.m4 for extension lz4

dnl Check PHP version:
AC_MSG_CHECKING(PHP version)
if test ! -z "$phpincludedir"; then
    PHP_VERSION=`grep 'PHP_VERSION ' $phpincludedir/main/php_version.h | sed -e 's/.*"\([[0-9\.]]*\)".*/\1/g' 2>/dev/null`
elif test ! -z "$PHP_CONFIG"; then
    PHP_VERSION=`$PHP_CONFIG --version 2>/dev/null`
fi

if test x"$PHP_VERSION" = "x"; then
    AC_MSG_WARN([none])
else
    PHP_MAJOR_VERSION=`echo $PHP_VERSION | sed -e 's/\([[0-9]]*\)\.\([[0-9]]*\)\.\([[0-9]]*\).*/\1/g' 2>/dev/null`
    PHP_MINOR_VERSION=`echo $PHP_VERSION | sed -e 's/\([[0-9]]*\)\.\([[0-9]]*\)\.\([[0-9]]*\).*/\2/g' 2>/dev/null`
    PHP_RELEASE_VERSION=`echo $PHP_VERSION | sed -e 's/\([[0-9]]*\)\.\([[0-9]]*\)\.\([[0-9]]*\).*/\3/g' 2>/dev/null`
    AC_MSG_RESULT([$PHP_VERSION])
fi

if test $PHP_MAJOR_VERSION -lt 5; then
    AC_MSG_ERROR([need at least PHP 5 or newer])
fi

PHP_ARG_ENABLE(lz4, whether to enable lz4 support,
[  --enable-lz4           Enable lz4 support])

PHP_ARG_WITH(lz4-includedir, for lz4 header,
[  --with-lz4-includedir=DIR  lz4 header files], no, no)

if test "$PHP_LZ4" != "no"; then

  AC_MSG_CHECKING([searching for liblz4])

  if test "$PHP_LZ4_INCLUDEDIR" != "no"; then
    for i in $PHP_LZ4_INCLUDEDIR /usr/local /usr; do
      if test -r $i/include/lz4.h; then
        LIBLZ4_CFLAGS="-I$i/include"
        LIBLZ4_LIBDIR="$i/$PHP_LIBDIR"
        AC_MSG_RESULT(found in $i)
        break
      fi
    done
    if test -z "$LIBLZ4_LIBDIR"; then
      AC_MSG_RESULT(not found)
      AC_MSG_ERROR(Please reinstall the lz4 library distribution)
    fi
    PHP_CHECK_LIBRARY(lz4, LZ4_compress,
    [
      PHP_ADD_LIBRARY_WITH_PATH(lz4, $LIBLZ4_LIBDIR, LZ4_SHARED_LIBADD)
      AC_DEFINE(HAVE_LIBLZ4,1,[ ])
    ], [
      AC_MSG_ERROR(could not find usable liblz4)
    ], [
      -L$LIBLZ4_LIBDIR
    ])

    PHP_SUBST(LZ4_SHARED_LIBADD)
    PHP_NEW_EXTENSION(lz4, lz4.c, $ext_shared,, $LIBLZ4_CFLAGS)
  else
    AC_MSG_RESULT(use bundled version)

    PHP_NEW_EXTENSION(lz4, lz4.c lz4/lib/lz4.c lz4/lib/lz4hc.c lz4/lib/xxhash.c, $ext_shared)

    PHP_ADD_BUILD_DIR($ext_builddir/lz4/lib, 1)
    PHP_ADD_INCLUDE([$ext_srcdir/lz4/lib])
  fi

  AC_MSG_CHECKING([for APCu includes])
  if test -f "$phpincludedir/ext/apcu/apc_serializer.h"; then
    apc_inc_path="$phpincludedir"
    AC_MSG_RESULT([APCu in $apc_inc_path])
    AC_DEFINE(HAVE_APCU_SUPPORT,1,[Whether to enable APCu support])
  else
    AC_MSG_RESULT([not found])
  fi
fi

dnl coverage
PHP_ARG_ENABLE(coverage, whether to enable coverage support,
[  --enable-coverage     Enable coverage support], no, no)

if test "$PHP_COVERAGE" != "no"; then
    EXTRA_CFLAGS="--coverage"
    PHP_SUBST(EXTRA_CFLAGS)
fi
