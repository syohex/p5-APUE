#!/usr/bin/env perl
use strict;
use warnings;

do '8_3.pl';

# system関数を呼ぶ

my $status;
$status = system ('date');
pr_exit($status);

$status = system ('nosuchcommand');
pr_exit($status);

$status = system('who; exit 44');
pr_exit($status);
