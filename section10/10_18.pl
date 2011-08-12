#!/usr/bin/env perl
use strict;
use warnings;

# POSIX.1のabortの実装

use POSIX ();
use IO::Handle;

sub abort {
    my $oldaction = POSIX::SigAction->new;

    POSIX::sigaction(POSIX::SIGABRT, undef, $oldaction);

    if (ref $oldaction->handler ne 'CODE') {
        # caller can't ignore SIGABRT, if so reset to default
        if ($oldaction->handler eq 'IGNORE') {
            $oldaction->handler('DEFALUT');
            POSIX::sigaction(POSIX::SIGABRT, $oldaction);
        }

        if ($oldaction->handler eq 'DEFAULT') {
            autoflush STDOUT 1; # flush all open stdio streams
        }
    }

    my $mask = POSIX::SigSet->new;
    $mask->fillset;
    $mask->delset(POSIX::SIGABRT);

    POSIX::sigprocmask(POSIX::SIG_SETMASK, $mask);

    kill POSIX::SIGABRT, POSIX::getpid();
    # if we are here, process caught SIGABRT and returned

    autoflush STDOUT, 1;

    my $action = POSIX::SigAction->new;
    $action->handler('DEFAULT');
    POSIX::sigaction(POSIX::SIGABRT, $action);
    POSIX::sigprocmask(POSIX::SIG_SETMASK, $mask);

    kill POSIX::SIGABRT, POSIX::getpid(); # and one more time

    exit 1;
}

abort();
