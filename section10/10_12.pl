#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

# sigactionを用いたsignalの実装

sub my_signal {
    my ($signo, $func) = @_;

    my $sigset = POSIX::SigSet->new;
    my $act = POSIX::SigAction->new($func, $sigset);
    my $oact = POSIX::SigAction->new;

    $act->flags(0);
    if ($signo != POSIX::SIGALRM) {
        $act->flags(POSIX::SA_RESTART);
    }

    unless (POSIX::sigaction($signo, $act, $oact)) {
        return POSIX::SIG_ERR;
    }

    return $oact->handler;
}

my_signal(POSIX::SIGUSR1, sub {
    print "Get Signal\n";
});

print "My pid is $$\n";
POSIX::pause;
