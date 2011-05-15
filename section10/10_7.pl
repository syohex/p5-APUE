#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# 時間切れ付きのreadの呼び出し

local $SIG{ALRM} = sub {
    print "raised SIGALRM\n";
    1; # noting to do, just return to interrupt the read
};

alarm 2;

my $line = sysread STDIN, my $buf, 2 ** 16;
if ($! == POSIX::EINTR) {
    $line = "\n";
}

alarm 0;

print "result: $line";
