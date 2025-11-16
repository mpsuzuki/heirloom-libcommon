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
  [libcommon_prefix=../heirloom-libcommon]
)
AC_ARG_WITH([included-libcommon],
AS_HELP_STRING([--with-included-libcommon],
  [build included libcommon]),
  [build_included_libcommon=yes],
  [build_included_libcommon=no])

AC_MSG_CHECKING([for libcommon in ${libcommon_prefix}])
  HEIRLOOM_FIND_LIBCOMMON_INSTALLED([${libcommon_prefix}],[
    AC_MSG_RESULT([yes, installed in here])
    libcommon_include='$(libcommon_prefix)/include'
    libcommon_lib='$(libcommon_prefix)/lib'
    path_libcommon_a="${libcommon_prefix}/lib/libcommon.a"
  ],[
    HEIRLOOM_FIND_LIBCOMMON_BUILT([${libcommon_prefix}],[],[
      AC_MSG_RESULT([yes, built in here])
      libcommon_include='$(libcommon_prefix)'
      libcommon_lib='$(libcommon_prefix)'
      path_libcommon_a="${libcommon_prefix}/libcommon.a"
    ],[
      AC_MSG_RESULT([no, build from included source])
      build_included_libcommon=yes
      path_libcommon_a=
    ],[has_wrap_sigset_h])
  ],[has_wrap_sigset_h])

have_libcommon_sigset=0
if test "x${has_wrap_sigset_h}" != xyes -a -n "${path_libcommon_a}"
then
  HEIRLOOM_FIND_LIBCOMMON_SIGSET_EMULATION(["${path_libcommon_a}"],[
    have_libcommon_sigset=1
  ],[
    HEIRLOOM_CPPFLAG_FOR_NATIVE_SIGSET([ac_enable_sigset_cppflag],
      [],
      [ AC_MSG_WARN([cannot enable native sigset(), build includes source])
        build_included_libcommon=yes
      ]
    )
  ])
fi

if test "x${build_included_libcommon}" = xyes
then
  ac_srcdir_libcommon="${srcdir}/heirloom-libcommon"
  AC_MSG_CHECKING([for libcommon in ${ac_srcdir_libcommon}])
  HEIRLOOM_FIND_LIBCOMMON_SOURCE([${ac_srcdir_libcommon}],
    [
      AC_MSG_RESULT(yes)
      # Currently, no support for the case the included
      # source is old and without "wrap-sigset.h".
      libcommon_prefix='$(top_srcdir)/heirloom-libcommon'
      libcommon_include='$(top_srcdir)/heirloom-libcommon'
      libcommon_lib='$(top_builddir)/heirloom-libcommon'
      have_wrap_sigset_h=1
      have_libcommon_sigset=1 # emulation is enabled by default
    ],[
      AC_MSG_ERROR(included source is broken)
    ])
fi

AM_CONDITIONAL(BUILD_LIBCOMMON, test "${build_included_libcommon}" = yes)
AC_SUBST([libcommon_prefix])
AC_SUBST([libcommon_include])
AC_SUBST([libcommon_lib])
AC_DEFINE_UNQUOTED([HAVE_WRAP_SIGSET_H],[${have_wrap_sigset_h}],
                   [wrap-sigset.h for libcommon sigset.h])
AC_DEFINE_UNQUOTED([HAVE_LIBCOMMON_SIGSET],[${have_libcommon_sigset}],
                   [libcommon.a has its own sigset()])

])
