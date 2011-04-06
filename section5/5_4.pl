#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;
use File::Temp;

# tmpnamとtmpfileの使い方
print POSIX::tmpnam(), "\n"; # first temp name
print POSIX::tmpnam(), "\n"; # second temp name

#my $fp = POSIX::tmpfile(); Can't use POSIX::tmpfile()
my $fp = File::Temp::tempfile(); # or IO::File::new_tempfile()
print $fp "one line of output\n";
seek $fp, 0, SEEK_SET or die "Can't seek file $!\n";

print <$fp>;
