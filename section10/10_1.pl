#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

# SIGUSR1とSIGUSR2を捕捉する簡単なプログラム

local $SIG{USR1} = sub {
    print "received SIGUSR1\n";
};
local $SIG{USR2} = sub {
    print "received SIGUSR2\n";
};

printf "pid = %d\n", $$;

while (1) {
    POSIX::pause();
}
