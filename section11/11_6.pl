#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();
use File::Spec ();

# POSIX.1のttyname関数の実装

my $DEV = "/dev";

sub ttyname {
    my $fd = shift;

    unless (POSIX::isatty($fd)) {
        return;
    }

    my @fdstats = POSIX::fstat($fd);

    unless (POSIX::S_ISCHR($fdstats[2])) {
        return;
    }

    opendir my $dh, $DEV or die "Can't open directory $DEV: $!\n";
    for my $dir (readdir $dh) {
        next if $dir eq '.' || $dir eq '..';
        my $pathname = File::Spec->catfile($DEV, $dir);
        my @devstats = stat $pathname;

        if ($fdstats[1] == $devstats[1] && $fdstats[0] == $devstats[0]) {
            closedir $dh;
            return $pathname;
        }
    }
    closedir $dh;

    return;
}
