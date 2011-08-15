#!/usr/bin/env perl
use strict;
use warnings;

# POSIX.1のctermidの実装

sub ctermid {
    return "/dev/tty";
}
