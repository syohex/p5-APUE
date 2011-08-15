#!/usr/bin/env perl
use strict;
use warnings;

use Term::ReadKey ();

# 端末モードをローまたはcbreakに設定

sub tty_cbreak {
    my $fh = shift;
    Term::ReadKey::ReadMode('cbreak', $fh)
}

sub tty_raw {
    my $fh = shift;
    Term::ReadKey::ReadMode('raw', $fh)
}

sub tty_reset {
    my $fh = shift;
    Term::ReadKey::ReadMode('restore', $fh);
}
