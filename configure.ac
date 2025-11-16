AC_PREREQ([2.62])
AC_INIT([heirloom-libcommon], [0.0.20240915], [https://github.com/mpsuzuki/heirloom-libcommon/-/issues])
AM_INIT_AUTOMAKE([foreign])

# Set default prefix
AC_PREFIX_DEFAULT(["/usr/ccs"])

# Checks for programs.
AC_PROG_CC
AC_PROG_MAKE_SET
AC_PROG_RANLIB
AC_PROG_LN_S

AC_MSG_CHECKING([whether libc includes lseek64()])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[
  int lseek64(void);
  int main() {
    return lseek64();
  }
])],[
  AC_MSG_RESULT([yes])

  AC_MSG_CHECKING([whether -D_FILE_OFFSET_BITS=64 hides lseek64()])
  orig_CPPFLAGS="${CPPFLAGS}"
  CPPFLAGS="${CFLAGS} -D_FILE_OFFSET_BITS=64L"
  AC_COMPILE_IFELSE(
    [AC_LANG_PROGRAM([#include <unistd.h>],[
int main (void)
{
#ifndef lseek
  (void) lseek64;
#endif
  return 0;
}
    ])],[
      AC_MSG_RESULT([no])
    ],[
      AC_MSG_RESULT([yes])
      HIDE_LSEEK64_CPPFLAGS="-D_FILE_OFFSET_BITS=64"
    ]
  )
  CPPFLAGS="${orig_CPPFLAGS}"
],[
  AC_MSG_RESULT([no])
])
AC_SUBST([HIDE_LSEEK64_CPPFLAGS])


# Enable/disable libcommon sigset emulations
AC_CHECK_HEADER([signal.h],[],[AC_MSG_ERROR([signal.h is required])])
AC_ARG_WITH([native-sigset],[
AS_HELP_STRING([--with-native-sigset=@<:@yes|no|auto@:>@],
               [use native deprecated sigset() (default is no, auto is 'use if available')])
],[native_sigset="$withval"],[native_sigset=no]
)
libcommon__xopen_source=0
if test "x${native_sigset}" != xno
then
  HEIRLOOM_CPPFLAG_FOR_NATIVE_SIGSET([ENABLE_SIGSET_CPPFLAGS],[
    ac_cv_have_decl_sigset=yes
    ac_cv_have_sigset_family=yes
    libcommon__xopen_source="${ac__xopen_source_enable_sigset}"
  ],[
    ac_cv_have_decl_sigset=no
    ac_cv_have_sigset_family=no
  ])
fi
AC_SUBST([LIBCOMMON__XOPEN_SOURCE],["${libcommon__xopen_source}"])

need_libcommon_sigset=no
libcommon_sigset=0
if test "x${native_sigset}" = xyes
then
  if test "x${ac_cv_have_sigset_family}" != xyes
  then
    AC_MSG_ERROR([native sigset() etc are requested, but some are missing])
  fi
elif test "x${native_sigset}" = xno -o "x${ac_cv_have_sigset_family}" != xyes
then
  need_libcommon_sigset=yes
  libcommon_sigset=1
  AC_CHECK_FUNCS([sigemptyset sigaddset sigprocmask sigaction sigismember],[],[
    AC_MSG_ERROR([needed for libcommon sigset()])
  ])
  ENABLE_SIGSET_CPPFLAGS="-DLIBCOMMON_SIGSET"
fi
AC_SUBST([LIBCOMMON_SIGSET],["${libcommon_sigset}"])
AC_SUBST([ENABLE_SIGSET_CPPFLAGS])
AM_CONDITIONAL(NEED_LIBCOMMON_SIGSET, test "x${need_libcommon_sigset}" = xyes)


ac_need_alloca_h=0
ac_need_malloc_h=0
ac_need_utmpx_h=0
AC_CHECK_DECL([__FreeBSD__],[
  ac_need_alloca_h=1
  ac_need_malloc_h=1
  ac_need_utmpx_h=1
])
AC_CHECK_DECL([__NetBSD__],[
  ac_need_alloca_h=1
  ac_need_malloc_h=1
  ac_need_utmpx_h=1
])
AC_CHECK_DECL([__OpenBSD__],[
  ac_need_alloca_h=1
  ac_need_malloc_h=1
  ac_need_utmpx_h=1
])
AC_CHECK_DECL([__DragonFly__],[
  ac_need_alloca_h=1
  ac_need_malloc_h=1
  ac_need_utmpx_h=1
])
AC_CHECK_DECL([__dietlibc__],[
  ac_need_malloc_h=1
  ac_need_utmpx_h=1
])
AC_CHECK_DECL([__UCLIBC__],[
  ac_need_utmpx_h=1
])
AC_CHECK_DECL([__APPLE__],[
  ac_need_malloc_h=1
  ac_need_utmpx_h=1
  AC_CHECK_HEADER([alloca.h],[],[ac_need_alloca_h=1])
])
AM_CONDITIONAL(NEED_ALLOCA_H, test ${ac_need_alloca_h} -gt 0)
AM_CONDITIONAL(NEED_MALLOC_H, test ${ac_need_malloc_h} -gt 0)
AM_CONDITIONAL(NEED_UTMPX_H,  test ${ac_need_utmpx_h}  -gt 0)

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([GNUmakefile wrap-sigset.h include/GNUmakefile])
AC_OUTPUT
