#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# プロセスの終了状態を出力する

sub pr_exit {
    my $status = shift;

    if (POSIX::WIFEXITED($status)) {
        printf "normal termination, exit status = %d\n"
        , POSIX::WEXITSTATUS($status);
    } elsif (POSIX::WIFSIGNALED($status)) {
        printf "abnormal termination, signal number = %d\n"
        , POSIX::WTERMSIG($status);
    } elsif (POSIX::WIFSTOPPED($status)) {
        printf "child stopped, signal number = %d\n"
        , POSIX::WSTOPSIG($status)
    }
}
