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

#ifdef _BSD_SOURCE
#ifndef __UCLIBC__
#define HAVE_GETLOADAVG
#endif /* __UCLIBC__ */
#endif

#ifdef __cplusplus
}
#endif

MODULE = Sys::LoadAverage		PACKAGE = Sys::LoadAverage

void
loadavg()
	PROTOTYPE:
	PREINIT:
		double loadavg[3];
		int retval, i;
        int fd, count;
        char ldavgbuf[40];
	PPCODE:
#if defined(HAVE_GETLOADAVG)
        retval = getloadavg(loadavg, 3);
#else
        retval = -1;

        fd = open ("/proc/loadavg", O_RDONLY);
        //printf( "DEBUG: File: %d\n", fd );
        if (fd != -1) {
            count = read (fd, ldavgbuf, 40);
            //printf( "DEBUG: Readed: %d\n", count );
            (void) close (fd);
            if (count > 0) {
                count = sscanf (ldavgbuf, "%lf %lf %lf", &loadavg[0], &loadavg[1], &loadavg[2]);
                //printf( "DEBUG: Parsed: %d\n", count );
                //printf( "DEBUG: la: %.02f, %.02f, %.02f\n", loadavg[0], loadavg[1], loadavg[2] );
                if (count >= 1)
                    retval = count;
            }
        }

        //FILE *LOADAVG;
        //retval = -1;
        //
        //if ((LOADAVG = fopen("/proc/loadavg", "r"))) {
        //    fscanf(LOADAVG, "%lf %lf %lf", &loadavg[0], &loadavg[1], &loadavg[2]);
        //    retval = 0;
        //    fclose(LOADAVG);
        //}
#endif
        //EXTEND(SP, 3);
        //printf( "DEBUG: result: %d\n", retval );
        if (retval == -1) {
            XSRETURN_EMPTY;
        } else {
            for (i=0; i<3; i++) {
                if (i < retval) {
                    //printf( "DEBUG: value: %.02f\n", loadavg[i] );
                    XPUSHs(sv_2mortal(newSVnv(loadavg[i])));
                } else {
                    XPUSHs(sv_2mortal(newSV(0)));
                }
            }
        }
