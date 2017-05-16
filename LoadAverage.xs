#ifdef __cplusplus
extern "C" {
#endif

#define _BSD_SOURCE
#define _DEFAULT_SOURCE
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#if defined (__SVR4) && defined (__sun)
#include <sys/loadavg.h>
#else
#include <stdlib.h>
#endif

#ifdef __cplusplus
}
#endif

MODULE = Sys::LoadAverage		PACKAGE = Sys::LoadAverage

void
getloadavg()
	PROTOTYPE:
	PREINIT:
		double loadavg[2];
		int retval, i;
	PPCODE:
#if defined(__linux__) || defined(__FreeBSD__) || defined(__OpenBSD__)
        retval = getloadavg(loadavg, 3);
#else
        retval = -1;
#endif
        EXTEND(SP, 3);
        if (retval == -1) {
            XSRETURN_EMPTY;
        } else {
            for (i=0; i<3; i++) {
                if (i < retval) {
                    XPUSHs(sv_2mortal(newSVnv(loadavg[i])));
                } else {
                    XPUSHs(sv_2mortal(newSV(0)));
                }
            }
        }
