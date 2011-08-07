#!/usr/bin/env perl
use strict;
use warnings;

use Term::ReadKey ();

# 端末モードをローまたはcbreakに設定

sub tty_cbreak {
    my $fd = shift;
    Term::ReadKey::ReadMode('cbreak', $fd)
}

sub tty_raw {
    my $fd = shift;
    Term::ReadKey::ReadMode('raw', $fd)
}

sub tty_reset {
    my $fd = shift;
    Term::ReadKey::ReadMode('restore', $fd);
}
