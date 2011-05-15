#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

do '10_10.pl'; # import pr_mask

# シグナルから臨界領域を保護する

sub sig_int {
    pr_mask("in sig_int");
    $SIG{QUIT} = 'DEFAULT';
}

$SIG{INT} = \&sig_int;

my ($newmask, $oldmask, $zeromask);

$newmask = POSIX::SigSet->new;
$oldmask = POSIX::SigSet->new;
$zeromask = POSIX::SigSet->new;

$newmask->emptyset;
$oldmask->emptyset;
$zeromask->emptyset;

$newmask->addset(POSIX::SIGINT);
unless (sigprocmask(POSIX::SIG_BLOCK, $newmask, $oldmask)) {
    print "SIG_BLOCK error\n";
}

pr_mask("in critical region");

unless (POSIX::sigsuspend($zeromask)) {
    die "sigsuspend error\n";
}

pr_mask("after return from sigsuspend");

# reset signal mask which unblocks SIGINT
unless (POSIX::sigprocmask(POSIX::SIG_SETMASK, $oldmask)) {
    die "SIG_SETMASK error\n";
}

# and continue processing
