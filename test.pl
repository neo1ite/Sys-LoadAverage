# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Sys-LoadAverage.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test;
BEGIN { plan tests => 1 };
use Sys::LoadAverage;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

#print join(" ", Sys::LoadAverage::getload()), $/;
#print "System uptime: ", int Sys::LoadAverage::uptime(), "s \n";
#print "System load: ", (Sys::LoadAverage::getload())[0], "\n";
#print '1 min, 5 min, 15 min load average: ',
#     join(',', Sys::LoadAverage::getload()), "\n";