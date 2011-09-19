#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();
use Fcntl qw(:mode);

# 必須ロックを使えるかどうかを調べる

require '12_2.pl';
require '../section10/10_17.pl';

open my $out, '+>', 'temp.lock' or die "Can't open temp.lock: $!";
my $fd = fileno $out;
print {$out} 'abcdef';

# turn on set-group-id and turn off group-execute
my $perm = (POSIX::fstat($fd))[2] & 07777;
chmod( (($perm & ~S_IXGRP) | S_ISGID), $out );

TELL_WAIT();

my $pid = fork;
die "Can't fork: $!" unless defined $pid;

if ($pid != 0) { # parent
    # write lock entire file
    write_lock($out, 0, POSIX::SEEK_SET, 0);
    TELL_CHILD();
    waitpid $pid, 0;
} else { # child
    WAIT_PARENT(); # wait for parent to set lock
    my $val = fcntl $out, Fcntl::F_GETFL, 0;
    fcntl $out, Fcntl::F_SETFL, $val | Fcntl::O_NONBLOCK;

    eval {
        read_lock($out, 0, POSIX::SEEK_SET, 0);
    };
    if ($@) {
        print "read_lock of already-locked region returns $!\n";
    } else {
        exit 1;
    }

    POSIX::lseek($fd, 0, POSIX::SEEK_SET);
    my $ret = sysread $out, my $buf, 2;
    die "Can't read: $!" unless defined $ret;

    print "read OK (no mandatory locking), buf = $buf\n";
}
