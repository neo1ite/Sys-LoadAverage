#ifdef __cplusplus
extern "C" {
#endif

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
		int retval; 
		int i;
	PPCODE:
#if defined(__FreeBSD__) || defined(__OpenBSD__) || defined(__linux__)
        retval = getloadavg(loadavg, 3);
#else
        retval = -1;
#endif
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
