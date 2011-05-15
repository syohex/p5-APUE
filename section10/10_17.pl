#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

my $newmask  = POSIX::SigSet->new;
my $oldmask  = POSIX::SigSet->new;
my $zeromask = POSIX::SigSet->new;

$newmask->emptyset;
$oldmask->emptyset;
$zeromask->emptyset;

my $sigflag = 0;
sub sig_usr {
    my $signame = shift;
    $sigflag = 1;
}

sub TELL_WAIT {
    $SIG{USR1} = \&sig_usr;
    $SIG{USR2} = \&sig_usr;

    $newmask->emptyset;
    $zeromask->emptyset;

    # block SIGUSR1 and SIGUSR2 and save current signal mask
    $newmask->addset(POSIX::SIGUSR1);
    $newmask->addset(POSIX::SIGUSR2);

    unless (POSIX::sigprocmask(POSIX::SIG_BLOCK, $newmask, $oldmask)) {
        die "SIG_BLOCK error\n";
    }
}

sub TELL_PARENT {
    my $pid = shift;
    kill POSIX::SIGUSR2, $pid; # tell parent we're done
}

sub WAIT_PARENT {
    while ($sigflag == 0) {
        POSIX::sigsuspend($zeromask); # and wait for parent
    }

    $sigflag = 0;
    unless (POSIX::sigprocmask(POSIX::SIG_SETMASK, $oldmask)) {
        die "SIG_SETMASK error\n";
    }
}

sub TELL_CHILD {
    my $pid = shift;
    kill POSIX::SIGUSR1, $pid; # tell child we're done
}

sub WAIT_CHILD {
    while ($sigflag == 0) {
        POSIX::sigsuspend($zeromask);  # and wait for child
    }

    $sigflag = 0;
    unless (POSIX::sigprocmask(POSIX::SIG_SETMASK, $oldmask)) {
        die "SIG_SETMASK error\n";
    }
}

