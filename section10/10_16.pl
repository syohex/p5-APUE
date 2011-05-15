#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

# 大域変数の設定を待ち合わせるためのsigsuspendの使い方

my $quitflag = 0;

sub sig_int {
    my $signame = shift;

    if ($signame eq 'INT') {
        print "interrupt\n";
    } elsif ($signame eq 'QUIT') {
        $quitflag = 1; # set flag for main loop
    }
}

local $SIG{QUIT} = \&sig_int;
local $SIG{INT}  = \&sig_int;

my $newmask  = POSIX::SigSet->new;
my $oldmask  = POSIX::SigSet->new;
my $zeromask = POSIX::SigSet->new;

$newmask->emptyset;
$oldmask->emptyset;
$zeromask->emptyset;

$newmask->addset(POSIX::SIGQUIT);
unless (POSIX::sigprocmask(POSIX::SIG_BLOCK, $newmask, $oldmask)) {
    print "SIG_BLOCK error\n";
}

while ($quitflag == 0) {
   POSIX::sigsuspend($zeromask);
}

# SIGQUIT has been caught and is now blocked; do whatever
