#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

# sigactionを用いたsignalの実装

sub signal {
    my ($signo, $func) = @_;

    my $act = POSIX::SigAction->new;
    my $oact = POSIX::SigAction->new;

    $act->handler($func);
    $act->mask->emptyset;
    $act->flags(0);
    if ($signo != POSIX::SIGALRM) {
        $act->flags(POSIX::SA_RESTART);
    }

    unless (POSIX::sigaction($signo, $act, $oact)) {
        return POSIX::SIG_ERR;
    }

    return $oact->handler;
}
