#!/usr/bin/env perl
use strict;
use warnings;

local $SIG{INT} = sub {
    print "caught SIGINT\n";
};

local $SIG{CHLD} = sub {
    print "caught SIGCHLD\n";
};

system("/bin/ed");
