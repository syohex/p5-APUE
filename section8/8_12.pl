#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# (シグナルを処理しない)システム関数

my $cmd = shift or die "Usage: $0 command\n";

my $pid = fork;
die "Error: fork $!\n" unless defined $pid;

my $status;
if ($pid == 0) {
    exec { '/bin/sh' } "sh", "-c", $cmd;
    exit 127;
} else {
    while (1) {
        my $pid = waitpid $pid, 0;
        $status = $?;
        last if defined $pid;

        if ($! != POSIX::EINTR) { # error other than EINTR from waitpid()
            $status = -1;
        }
    }
}

print "status = $status\n";
exit $status;
