dnl
dnl HEIRLOOM_CPPFLAG_FOR_NATIVE_SIGSET([varname],[action-if-found],[action-if-not-found])
dnl
dnl  $1 = CPPFLAG variable name to store a flag to enable native sigset()
dnl  $2 = action if we can enable native sigset()
dnl  $3 = action if we cannot enable native sigset()
dnl
AC_DEFUN([HEIRLOOM_CPPFLAG_FOR_NATIVE_SIGSET],[
  AC_CHECK_DECL([sigset],[],[],[#include <signal.h>])
  if test "x${ac_cv_have_decl_sigset}" = xyes
  then # sigset() is already exposed
    ac_cv_have_decl_sigset=yes
  else
    orig_CPPFLAGS="${CPPFLAGS}"
    AC_MSG_CHECKING([for _XOPEN_SOURCE to enable sigset declaraion])
    for v in 100 200 300 400 500 600 700
    do
      ac__xopen_source_enable_sigset=
      CPPFLAGS="${orig_CPPFLAGS} -D_XOPEN_SOURCE=${v}"
      AC_COMPILE_IFELSE([AC_LANG_PROGRAM([
        #include <signal.h>
      ],[
        (void)signal;
        (void)sigset;
        (void)sighold;
        (void)sigrelse;
        (void)sigignore;
        (void)sigpause;
      ])],[
        $1="-D_XOPEN_SOURCE=${v}"
        ac__xopen_source_enable_sigset=${v}
      ],[])
      if test -n "${ac__xopen_source_enable_sigset}"
      then
        break
      fi
    done
    if test -n "${ac__xopen_source_enable_sigset}"
    then
      AC_MSG_RESULT([${ac__xopen_source_enable_sigset}])
      ac_cv_have_decl_sigset=yes
    else
      AC_MSG_RESULT([none])
      ac_cv_have_decl_sigset=no
    fi
  fi
  if test "x${ac_cv_have_decl_sigset}" = xyes
  then
    ac_cv_have_sigset_family=yes
    if test "x${ac_cv_have_decl_sigset}" = xyes
    then
      AC_CHECK_FUNCS([signal sigset sigrelse sighold sigignore sigpause],[],[
        ac_cv_have_sigset_family=no
      ])
    fi
  fi
  if test "x${ac_cv_have_sigset_family}" = xyes
    [$2]
  else
    [$3]
  fi
])

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
