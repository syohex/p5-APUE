#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

local $SIG{CHLD} = sub {
    print "SIGCHLD received\n";
    my $pid = wait;
    print "pid = $pid\n";
};

my $pid = fork;
die "Error: fork $!\n" unless defined $pid;

if ($pid == 0) { # child
    sleep 2;
} else {
    POSIX::pause;
}

__END__
signal.signal(signal.SIGCLD, sig_cld)
pid = os.fork()
if pid == 0:   # child
    time.sleep(2)
else:          # parent
    signal.pause()
