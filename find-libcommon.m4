# Search libcommon
AC_DEFUN([HEIRLOOM_FIND_LIBCOMMON],[

use_included_libcommon=no
AC_ARG_WITH([libcommon],
AS_HELP_STRING([--with-libcommon=prefix-to-builddir-libcommon],
  [path to the builddir of libcommon]),
  [libcommon_prefix=${withval}],
  [libcommon_prefix=../heirloom-libcommon])

AC_MSG_CHECKING([libcommon.a])
if test "${use_included_libcommon}" = yes
then
  AC_MSG_RESULT([build from included source])
  libcommon_lib="${libcommon_prefix}"
elif test -r "${libcommon_prefix}"/libcommon.a
then
  AC_MSG_RESULT([${libcommon_prefix}/libcommon.a])
  libcommon_lib="${libcommon_prefix}"
elif test -r "${libcommon_prefix}"/lib/libcommon.a
then
  AC_MSG_RESULT([${libcommon_prefix}/lib/libcommon.a])
  libcommon_lib="${libcommon_prefix}"/lib
fi

if test x"${libcommon_lib}" != x
then
  orig_LIBS="${LIBS}"
  LIBS="-L${libcommon_lib} -lcommon"
  AC_CHECK_FUNC([ib_alloc],[],[libcommon_lib=""])
  LIBS="${orig_LIBS}"
fi

if test x"${libcommon_lib}" = x
then
  AC_MSG_RESULT([not found, use included copy of heirloom-libcommon])
  use_included_libcommon=yes
  libcommon_prefix="${srcdir}"/heirloom-libcommon/
  libcommon_include='$(libcommon_prefix)'
  libcommon_lib='$(libcommon_prefix)'
fi




AC_MSG_CHECKING([regexp.h])
if test "${use_included_libcommon}" = yes
then
  AC_MSG_RESULT([build from included source])
elif test -r ${libcommon_prefix}/regexp.h
then
  AC_MSG_RESULT([${libcommon_prefix}/regexp.h])
  libcommon_include='$(libcommon_prefix)'
elif test -r ${libcommon_prefix}/include/regexp.h
then
  AC_MSG_RESULT([${libcommon_prefix}/include/regexp.h])
  libcommon_include='$(libcommon_prefix)/include'
else
  AC_MSG_ERROR([not found])
fi

AM_CONDITIONAL(BUILD_LIBCOMMON, test "${use_included_libcommon}" = yes)
AC_SUBST([libcommon_prefix])
AC_SUBST([libcommon_include])
AC_SUBST([libcommon_lib])

])
