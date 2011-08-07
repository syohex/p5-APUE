#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

# POSIX.1のisattyの実装

sub isatty {
    my $fd = shift;

    my $termios = POSIX::Termios->new;
    my $retval  = $termios->getattr($fd);

    return 0 unless defined $retval;

    return 1;
}
