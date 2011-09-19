#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl qw(:flock);
use IO::Handle;
use Errno ();

require '12_2.pl';

my $PIDFILE = 'daemon.pid';

open my $fh, '>', $PIDFILE or die "Can't open: $!";
my $fd = fileno $fh;

eval {
    write_lock($fd, 0, SEEK_SET, 0);
};
if ($@) {
    if ($! == Errno::EACCES || $! == Errno::EAGAIN) {
        exit 0;
    }
}

# truncate to zero length, now that we have the lock
$fh->truncate(0);

# and write our process ID
$fh->write($$);

# set close-on-exit flag for descriptor
my $val = fcntl($fh, Fcntl::F_GETFD, 0);
fcntl($fh, Fcntl::F_SETFL, $val | Fcntl::FD_CLOEXEC);

# leave file open until we terminate: lock will be held

# do whatever
