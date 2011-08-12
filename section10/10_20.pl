#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();
use Errno ();
use Proc::Wait3 ();

# POSIX.2の正しいsystem関数の実装

sub my_system {
    my $cmdstring = shift;

    unless (defined $cmdstring) {
        return 1;
    }

    my $ignore = POSIX::SigAction->new;
    $ignore->handler('IGNORE');
    $ignore->flags(0);

    my $saveintr = POSIX::SigAction->new;
    unless (POSIX::sigaction(POSIX::SIGINT, $ignore, $saveintr)) {
        return -1;
    }

    my $savequit = POSIX::SigAction->new;
    unless (POSIX::sigaction(POSIX::SIGQUIT, $ignore, $savequit)) {
        return -1;
    }

    # now block SIGCHLD
    my $chldmask = POSIX::SigSet->new(POSIX::SIGCHLD);
    my $savemask;
    POSIX::sigprocmask(POSIX::SIG_BLOCK, $chldmask, $savemask);

    my $pid = fork;
    die "Can't fork: $!" unless defined $pid;

    my $status;
    if ($pid == 0) { # child
        # restore previous signal actions & reset signal mask
        POSIX::sigaction(POSIX::SIGINT, $saveintr);
        POSIX::sigaction(POSIX::SIGQUIT, $savequit);
        POSIX::sigprocmask(POSIX::SIG_SETMASK, $savemask);

        exec { '/bin/sh' } 'sh', '-c', $cmdstring or die "Can't exec: $!";
        exit 127; # never reach here
    } else { # parent
        (undef, $status) = Proc::Wait3::wait3(1);
        if ($! && $! != Errno::EINTR) {
            warn "Error while waiting child process: $!\n";
        }
    }

    unless (POSIX::sigaction(POSIX::SIGINT, $saveintr)) {
        return -1;
    }
    unless (POSIX::sigaction(POSIX::SIGQUIT, $savequit)) {
        return -1;
    }
    unless (POSIX::sigprocmask(POSIX::SIG_SETMASK, $savemask)) {
        return -1;
    }

    return $status;
}

my_system('ls -l');
