/*
 * Copyright (c) 2004 Gunnar Ritter
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute
 * it freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution.
 */
/*	Sccsid @(#)sigset.h	1.9 (gritter) 1/22/06	*/

#if defined (__FreeBSD__) || defined (__dietlibc__) || defined (__NetBSD__) || \
	defined (__OpenBSD__) || defined (__DragonFly__) || defined (__APPLE__) || \
	defined (LIBCOMMON_SIGSET)

#ifndef	SIG_HOLD
#define	SIG_HOLD	((void (*)(int))2)
#endif	/* !SIG_HOLD */

extern int	libcommon_sighold(int);
#define	sighold(i)	libcommon_sighold((i))

extern int	libcommon_sigignore(int);
#define	sigignore(i)	libcommon_sigignore((i))

extern int	libcommon_sigpause(int);
#define	sigpause(i)	libcommon_sigpause((i))

extern int	libcommon_sigrelse(int);
#define	sigrelease(i)	libcommon_sigrelse((i))

extern void	(*libcommon_sigset(int, void (*)(int)))(int);
#define	sigset(i, i_p)	libcommon_sigset((i), (i_p))

extern void	(*libcommon_signal(int, void (*)(int)))(int);
#define signal(i, i_p)	libcommon_signal((i), (i_p)))

#endif	/* __FreeBSD__ || __dietlibc__ || __NetBSD__ || __OpenBSD__ ||
	__DragonFly__ || __APPLE__ || LIBCOMMON_SIGSET */
