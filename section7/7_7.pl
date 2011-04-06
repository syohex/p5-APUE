#!/usr/bin/env perl
use strict;
use warnings;

use BSD::Resource;

# 現在のリソースリミットを出力する

my @limit_constants = qw(
    RLIMIT_AS RLIMIT_CORE RLIMIT_CPU RLIMIT_DATA
    RLIMIT_FSIZE RLIMIT_MEMLOCK RLIMIT_NOFILE
    RLIMIT_NPROC RLIMIT_OFILE RLIMIT_RSS RLIMIT_STACK
);

printf "%-15s %10s %10s\n", "NAME", "SOFT", "HARD";
for my $name (@limit_constants) {
    my ($soft, $hard) = getrlimit($name);

    unless (defined $soft && defined $hard) {
        $soft = $hard = "n/a";
    }

    $soft = "infinity" if $soft == -1;
    $hard = "infinity" if $hard == -1;

    printf "%-15s %10s %10s\n", $name, $soft, $hard;
}
