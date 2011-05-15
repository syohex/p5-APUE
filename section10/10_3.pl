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
