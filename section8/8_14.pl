#!/usr/bin/env perl
use strict;
use warnings;

do '8_3.pl';

# systemを用いてコマンド行引数を実行する

my $status = system ($ARGV[0]);
pr_exit($status);
