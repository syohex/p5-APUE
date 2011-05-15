#!/usr/bin/env perl
use strict;
use warnings;

use Config;
use POSIX;

# sigaddset, sigdelset, sigismemberの実装

sub SIGBAD {
    my $signo = shift;

    if ($signo <=0 || $signo >= $Config{sig_count}) {
        die "Invalid signal number($signo)\n";
    }
}

sub sigaddset {
    my ($sigset, $signo) = @_;

    SIGBAD($signo);
    $sigset = $sigset | (1 << ($signo - 1)); # turn bit on

    return $sigset;
}

sub sigdelset {
    my ($sigset, $signo) = @_;

    SIGBAD($signo);
    $sigset = $sigset & ~(1 << ($signo - 1)); # turn bit off

    return $sigset;
}

sub sigismember {
    my ($sigset, $signo) = @_;

    SIGBAD($signo);

    if (ref $sigset eq 'POSIX::SigSet') {
        if ($sigset->ismember($signo)) {
            return 1;
        } else {
            return 0;
        }
    } else {
        if ($sigset & (1 << ($signo - 1))) {
            return 1;
        } else {
            return 0;
        }
    }
}

unless (caller) {
    use Test::More;
    use Test::Exception;

    subtest 'SIGBAD test' => sub {
        lives_ok { SIGBAD(1) } 'valid signo';
        dies_ok { SIGBAD(0) } 'invalid signo';
    };

    subtest 'sigaddset test' => sub {
        is(sigaddset(0, 1), 1);
        is(sigaddset(1, 16), 32769);
        dies_ok { sigaddset(0, 0); } 'invalid argument';
    };

    subtest 'sigdelset test' => sub {
        is(sigdelset(1, 1), 0);
        is(sigdelset(3, 2), 1);
        dies_ok { sigdelset(0, 0); } 'invalid argument';
    };

    subtest 'sigismember test' => sub {
        is(sigismember(1, 1), 1);
        is(sigismember(3, 3), 0);
        dies_ok { sigismember(0, 0); } 'invalid argument';
    };

    done_testing;
}

1;
