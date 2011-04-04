#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;
use constant OPENMAX_GUESS => 256;

# ファイル記述子の個数の決定

my $_open_max;

sub get_max_open {
    unless (defined $_open_max) {
        $_open_max = POSIX::sysconf(&POSIX::_SC_OPEN_MAX);
        if (defined $_open_max) {
            $_open_max += 1;
        } else {
            $_open_max = OPENMAX_GUESS;
        }
    }

    return $_open_max;
}

printf "OPENMAX = %d\n", get_max_open();
