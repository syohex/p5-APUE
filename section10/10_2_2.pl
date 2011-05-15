#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

my $name;

my $sigset = POSIX::SigSet->new();
my $alarm = POSIX::SigAction->new(sub {
    print "in signal hander\n";
    $name = (getpwnam("root"))[0];
    alarm 1;
}, $sigset, POSIX::SA_NOCLDSTOP | POSIX::SA_RESTART);

POSIX::sigaction(POSIX::SIGALRM, $alarm);
alarm 1;

while (1) {
    $name = (getpwnam("syohei"))[0];
    if ($name ne "syohei") {
        warn "return value corrupted\n";
    }
}
