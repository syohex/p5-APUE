#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

# sleepの信頼性のある実装

sub sig_alrm {
    # nothing to do, just returning wakes up sigsuspend()
}

sub sleep {
    my $nsecs = shift;

    my $newact = POSIX::SigAction->new;
    my $oldact = POSIX::SigAction->new;

    my $newmask  = POSIX::SigSet->new;
    my $oldmask  = POSIX::SigSet->new;
    my $suspmask = POSIX::SigSet->new;

    my $unslept = 0;

    # set out handler, save previous information
    $SIG{ALRM} = \&sig_alrm;
    POSIX::sigaction(POSIX::SIGALRM, undef, $oldact);

    $newmask->addset(POSIX::SIGALRM);

    POSIX::sigprocmask(POSIX::SIG_BLOCK, $newmask, $oldmask);

    alarm $nsecs;

    $suspmask = $oldmask;
    $suspmask->delset(POSIX::SIGALRM);
    POSIX::sigsuspend($suspmask);

    # some signalshas been caught, SIGALRM is now blocked

    $unslept = alarm 0;

    POSIX::sigaction(POSIX::SIGALRM, $oldact);
}

my $time = shift || 5;
print "sleep $time second\n";
main::sleep($time);
