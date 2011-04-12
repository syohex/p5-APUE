#!/usr/bin/env perl
use strict;
use warnings;

# 解釈実行ファイルをexecするプログラム

my $pid = fork;
die "Error: fork $!\n" unless defined $pid;

if ($pid == 0) {
    exec { "./testinterp" } "testinterp", "arg1", "MY ARG2";
}

waitpid($pid, 0);
