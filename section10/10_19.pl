#!/usr/bin/env perl
use strict;
use warnings;

# edエディタを起動するためにsystemを利用する

local $SIG{INT} = sub {
    print "caught SIGINT\n";
};

local $SIG{CHLD} = sub {
    print "caught SIGCHLD\n";
};

system("/bin/ed");
