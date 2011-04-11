#!/usr/bin/env perl
use strict;
use warnings;

use Benchmark qw(timeit);

# 全てのコマンド行引数を実行し時間を計る

for my $arg (@ARGV) {
    my $t = timeit(
        1,
        sub {
            my @commands = ($arg);
            system @commands;
        },
    );

    # Please see perldoc Benchmark, NOTES setction.
    my ($real, $user, $system, $children_user, $children_system, undef) = @{$t};

    printf STDERR "  real:%g\n", $real;
    printf STDERR "  user:%g\n", $user;
    printf STDERR "   sys:%g\n", $system;
    printf STDERR "  child user:%g\n", $children_user;
    printf STDERR "  child  sys:%g\n", $children_system;
}
