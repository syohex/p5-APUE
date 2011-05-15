#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

my $name;
local $SIG{ALRM} = sub {
    print "in signal hander\n";
    $name = (getpwnam("root"))[0];
    alarm 1;
};

alarm 1;

while (1) {
    $name = (getpwnam("syohei"))[0];
    if ($name ne "syohei") {
        print "return value corrupted\n";
    }
}
