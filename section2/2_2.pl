#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;
use constant PATHMAX_GUESS => 1024;

# パス名用領域の動的割り当て

my $_path_max;

sub get_max_path {
    unless (defined $_path_max) {
        $_path_max = POSIX::pathconf("/", &POSIX::_PC_PATH_MAX);
        if (defined $_path_max) {
            $_path_max += 1;
        } else {
            $_path_max = PATHMAX_GUESS;
        }
    }

    return $_path_max;
}

printf "PATHMAX = %d\n", get_max_path();
