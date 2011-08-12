#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

# signal_intr関数

sub signal_intr {
    my ($signo, $func) = @_;

    my $sigset = POSIX::SigSet->new;
    my $act = POSIX::SigAction->new($func, $sigset);
    my $oact = POSIX::SigAction->new;

    $act->flags(0);
    unless (POSIX::sigaction($signo, $act, $oact)) {
        return POSIX::SIG_ERR;
    }

    return $oact->handler;
}

alarm 3;
signal_intr(POSIX::SIGALRM, sub { print "alarm now\n"; } );
POSIX::pause;
alarm 0;
