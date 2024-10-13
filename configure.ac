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
  orig_CFLAGS="${CFLAGS}"
  CFLAGS="${CFLAGS} -D_FILE_OFFSET_BITS=64L"
  AC_MSG_CHECKING([whether -D_FILE_OFFSET_BITS=64 hides lseek64()])
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
      AM_CFLAGS="-D_FILE_OFFSET_BITS=64"
      AC_MSG_RESULT([yes])
    ]
  )
  CFLAGS="${orig_CFLAGS}"
],[
  AC_MSG_RESULT([no])
])
AC_SUBST([AM_CFLAGS])

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
  AC_PREPROC_IFELSE([
    AC_LANG_PROGRAM([],[
#if defined(__MAC_OS_X_VERSION_10_5) && (__MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_OS_X_VERSION_10_5)
#error __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_OS_X_VERSION_10_5
#endif
    ])],
  ],[
    ac_need_alloca_h=1
  ])
])
AM_CONDITIONAL(NEED_ALLOCA_H, test ${ac_need_alloca_h} -gt 0)
AM_CONDITIONAL(NEED_MALLOC_H, test ${ac_need_malloc_h} -gt 0)
AM_CONDITIONAL(NEED_UTMPX_H,  test ${ac_need_utmpx_h}  -gt 0)

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([GNUmakefile])
AC_OUTPUT
