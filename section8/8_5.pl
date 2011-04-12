#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# forkを２度呼んでゾンビプロセスを避ける

my $pid = fork;
die "Error: fork $!\n" unless defined $pid;

if ($pid == 0) {
    my $pid2 = fork; # 一つ目の子プロセス
    die "Error: fork $!\n" unless defined $pid2;

    if ($pid2 > 0) { # 2回目のfork()の親プロセス (=一つ目の子プロセス)
        print "exit 0";
        exit 0;
    }

    # 二つ目の子プロセス
    # このプロセスの本来の親プロセスは起動後すぐに sys.exit() を呼び出すので、
    # 親プロセスが init に変更される。
    # このプロセスが終了すると、終了状態は init で解放される

    sleep 2;
    printf "second child, parent pid = %d\n", POSIX::getppid;
    exit 0;
}

waitpid $pid, 0;
