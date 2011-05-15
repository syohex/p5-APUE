#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

# signal_intr関数

sub signal_intr {
    my ($signo, $func) = @_;

    my $act = POSIX::SigAction->new;
    my $oact = POSIX::SigAction->new;

    $act->handler($func);
    $act->mask->emptyset;
    $act->flags(0);
    unless (POSIX::sigaction($signo, $act, $oact)) {
        return POSIX::SIG_ERR;
    }

    return $oact->handler;
}
