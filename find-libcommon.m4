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
  then
    :
    $2
  else
    :
    $3
  fi
])

dnl Check the directory is installed libcommon
dnl
dnl $1 directory to be tested
dnl $2 action if it is an installed directory
dnl $3 action if it is not an installed directory
dnl $4 variable name to store whether wrap-sigset.h is found or not
dnl
AC_DEFUN([HEIRLOOM_FIND_LIBCOMMON_INSTALLED],[
  ac_found_regexp_h=no;      test -r "$1"/include/regexp.h      && ac_found_regexp_h=yes
  ac_found_wrap_sigset_h=no; test -r "$1"/include/wrap-sigset.h && ac_found_wrap_sigset_h=yes
  ac_found_libcommon_a=no;   test -r "$1"/lib/libcommon.a       && ac_found_libcommon_a=yes

  if test -n "[$4]"
  then
    [$4]="${ac_found_wrap_sigset_h}"
  fi

  if test "x${ac_found_regexp_h}" = xyes -a "x${ac_found_libcommon_a}" = xyes
  then
    :
    $2
  else
    :
    $3
  fi
])

dnl Check the directory is built(-but-not-installed) libcommon
dnl
dnl $1 built directory to be tested
dnl $2 source directory (optional)
dnl $3 action if it is an installed directory
dnl $4 action if it is not an installed directory
dnl $5 variable name to store whether wrap-sigset.h is found or not
dnl
AC_DEFUN([HEIRLOOM_FIND_LIBCOMMON_BUILT],[
  ac_dir_built_libcommon=$1
  ac_dir_src_libcommon=$2
  if test -z "${ac_dir_source_libcommon}" 
  then
    ac_dir_src_libcommon="${ac_dir_built_libcommon}"
  fi
  ac_found_regexp_h=no;      test -r "${ac_dir_src_libcommon}"/regexp.h        && ac_found_regexp_h=yes
  ac_found_wrap_sigset_h=no; test -r "${ac_dir_built_libcommon}"/wrap-sigset.h && ac_found_wrap_sigset_h=yes
  ac_found_libcommon_a=no;   test -r "${ac_dir_built_libcommon}"/libcommon.a   && ac_found_libcommon_a=yes

  if test -n "[$5]"
  then
    [$5]="${ac_found_wrap_sigset_h}"
  fi

  if test "x${ac_found_regexp_h}" = xyes -a "x${ac_found_libcommon_a}" = xyes
  then
    :
    $3
  else
    :
    $4
  fi
])

dnl Check the directory is libcommon source
dnl
dnl $1 directory to be tested
dnl $2 action if it is an installed directory
dnl $3 action if it is not an installed directory
dnl $4 variable name to store whether wrap-sigset.h.in is found or not
dnl
AC_DEFUN([HEIRLOOM_FIND_LIBCOMMON_SOURCE],[
  ac_found_regexp_h=no;         test -r "$1"/regexp.h         && ac_found_regexp_h=yes
  ac_found_wrap_sigset_h_in=no; test -r "$1"/wrap-sigset.h.in && ac_found_wrap_sigset_h_in=yes
  ac_found_configure=no;        test -x "$1"/configure        && ac_found_configure=yes

  if test -n "[$4]"
  then
    [$4]="${ac_found_wrap_sigset_h_in}"
  fi

  if test "x${ac_found_regexp_h}" = xyes -a "x${ac_found_configure}" = xyes
  then
    :
    $2
  else
    :
    $3
  fi
])


dnl Check whether libcommon.a has sigset() emulation
dnl
dnl $1 libcommon.a pathname
dnl $2 action if it has sigset() emulation
dnl $3 action if it does not have sigset() emulation
dnl
AC_DEFUN([HEIRLOOM_FIND_LIBCOMMON_SIGSET_EMULATION],[
  AC_PATH_PROG([NM], [nm], [no])
  AC_MSG_CHECKING([whether $1 has ib_alloc()])
  ac_nm_g_ib_alloc=`"${NM}" -g "$1"|sed -n "/\.o/d;/[0-9A-Za-z]ib_alloc/d;/ib_alloc[0-9A-Za-z]/d;/ib_alloc/pq"`
  if test -z "${ac_nm_g_ib_alloc}"
  then
    AC_MSG_RESULT([no])
    ac_libcommon_has_ib_alloc=no
  else
    AC_MSG_RESULT([yes])
    ac_libcommon_has_ib_alloc=yes
  fi
  AC_MSG_CHECKING([whether $1 has sigset()])
  ac_nm_g_sigset=`"${NM}" -g "$1"|sed -n "/\.o/d;/[0-9A-Za-z]sigset/d;/sigset[0-9A-Za-z]/d;/sigset/pq"`
  if test -z "${ac_nm_g_sigset}"
  then
    AC_MSG_RESULT([no])
    ac_libcommon_has_sigset=no
  else
    AC_MSG_RESULT([yes])
    ac_libcommon_has_sigset=yes
  fi
  if test -n "${ac_libcommon_has_ib_alloc}" -a -n "${ac_libcommon_has_sigset}"
  then
    :
    $2
  else
    :
    $3
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

AC_MSG_CHECKING([for libcommon.a])
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


AC_MSG_CHECKING([for regexp.h])
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


if test x"${libcommon_lib}" != x
then
  AC_PATH_PROG([NM], [nm], [no])
  AC_MSG_CHECKING([whether ${libcommon_lib}/libcommon.a has ib_alloc()])
  nm_g_ib_alloc=`"${NM}" -g "${libcommon_lib}/libcommon.a" | sed -n "/\.o/d;/ib_alloc/p"`
  if test -z "${nm_g_ib_alloc}"
  then
    AC_MSG_RESULT([no])
    libcommon_lib=""
  else
    AC_MSG_RESULT([yes])
    AC_MSG_CHECKING([for wrap-sigset.h])
    if test -r ${libcommon_prefix}/include/wrap-sigset.h
    then
      AC_MSG_RESULT([${libcommon_prefix}/include/wrap-sigset.h])
      have_wrap_sigset_h=1
    elif test -r ${libcommon_prefix}/wrap-sigset.h
    then
      AC_MSG_RESULT([${libcommon_prefix}/wrap-sigset.h])
      have_wrap_sigset_h=1
    else
      AC_MSG_RESULT([not found])
      have_wrap_sigset_h=

      AC_MSG_CHECKING([whether ${libcommon_lib}/libcommon.a has sigset()])
      nm_g_sigset=`"${NM}" -g "${libcommon_lib}/libcommon.a" | sed -n "/\.o/d;/sigset/p"`
      if test -z "${nm_g_sigset}"
      then
        AC_MSG_RESULT([no])
        have_libcommon_sigset=
      else
        AC_MSG_RESULT([yes])
        have_libcommon_sigset=1
        AC_MSG_CHECKING([for sigset.h])
        if test -r ${libcommon_prefix}/include/sigset.h
        then
          AC_MSG_RESULT([${libcommon_prefix}/include/sigset.h])
          have_libcommon_sigset=1
        elif test -r ${libcommon_prefix}/sigset.h
        then
          AC_MSG_RESULT([${libcommon_prefix}/sigset.h])
          have_libcommon_sigset=1
        else
          AC_MSG_RESULT([no, libcommon.a has sigset() but sigset.h is missing])
          libcommon_lib=""
        fi # end of testing "sigset.h"
      fi # end of "nm -g libcommon.a | grep sigset"
    fi # end of testing "wrap-sigset.h"
  fi # end of "nm -g libcommon.a | grep ib_alloc
fi # end of libcommon_lib


if test x"${libcommon_lib}" = x
then
  AC_MSG_RESULT([not found or broken, use included copy of heirloom-libcommon])
  use_included_libcommon=yes
  libcommon_prefix="${srcdir}"/heirloom-libcommon/
  libcommon_include='$(libcommon_prefix)'
  libcommon_lib='$(libcommon_prefix)'
fi




AM_CONDITIONAL(BUILD_LIBCOMMON, test "${use_included_libcommon}" = yes)
AC_SUBST([libcommon_prefix])
AC_SUBST([libcommon_include])
AC_SUBST([libcommon_lib])
AC_DEFINE_UNQUOTED([HAVE_WRAP_SIGSET_H],[${have_wrap_sigset_h}],
                   [wrap-sigset.h for libcommon sigset.h])
AC_DEFINE_UNQUOTED([HAVE_LIBCOMMON_SIGSET],[${have_libcommon_sigset}],
                   [libcommon.a has its own sigset()])

])
