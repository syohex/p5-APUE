#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

sub sleep1 {
    my $sec = shift;

    local $SIG{ALRM} = sub {
        1; # nothing to do, just return to wake up the pause
    };

    alarm $sec;
    POSIX::pause();
    alarm 0;
}

my $sec = shift || 3;
sleep1($sec);
