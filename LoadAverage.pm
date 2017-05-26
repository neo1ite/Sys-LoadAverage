package Sys::LoadAverage;

use 5.006000;
use strict;
use warnings;

require Exporter;
require DynaLoader;
require AutoLoader;
#use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter AutoLoader DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Sys::LoadAverage ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	getload uptime
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(

);

our $VERSION = '0.01';


# Preloaded methods go here.

bootstrap Sys::LoadAverage $VERSION;

# Autoload methods go after =cut, and are processed by the autosplit program.

use constant UPTIME => "/proc/uptime";

use IO::File;

my $cache = 'unknown';

sub getload {

  # handle bsd getloadavg().  Read the README about why it is freebsd/openbsd.
  if ($cache eq 'getloadavg()' || lc($^O) eq 'freebsd' || lc($^O) eq 'openbsd' || lc($^O) eq 'linux') {
    $cache = 'getloadavg()';
    return loadavg();
  }

  # handle unknown (linux) proc filesystem
  if ($cache eq 'unknown' or $cache eq 'linux') {
    my $fh = IO::File->new('/proc/loadavg', 'r');

    if (defined $fh) {
      my $line = <$fh>;
      $fh->close();

      if ($line =~ /^(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/) {
        #$cache = 'linux';
        return ($1, $2, $3);
      }              # if we can parse /proc/loadavg contents
    }                # if we could load /proc/loadavg
  }                  # if linux or not cached

  # last resort...

  $cache = 'uptimepipe';
  local %ENV = %ENV;
  $ENV{'LC_NUMERIC'}='POSIX';    # ensure that decimal separator is a dot

  my $fh = IO::File->new('/usr/bin/uptime|');

  if (defined $fh) {
    my $line = <$fh>;
    $fh->close();

    if ($line =~ /(\d+\.\d+)\s*,\s+(\d+\.\d+)\s*,\s+(\d+\.\d+)\s*$/) {
      return ($1, $2, $3);
    }                # if we can parse the output of /usr/bin/uptime
  }                  # if we could run /usr/bin/uptime

  return (undef, undef, undef);
}

sub uptime {
  open(FILE, UPTIME) || return 0;
  my $line = <FILE>;
  my($uptime, $idle) = split /\s+/, $line;
  close FILE;
  return $uptime;
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Sys::LoadAverage - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Sys::LoadAverageqw/getload uptime/;
  print "System uptime: ", int uptime(), "\n";
  print "System load: ", (getload())[0], "\n";
  print '1 min, 5 min, 15 min load average: ',
       join(',', Sys::LoadAverage::getload()), "\n";

=head1 DESCRIPTION

Stub documentation for Sys::LoadAverage, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

neolite, E<lt>neolite@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017 by neolite

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.22.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
