#!/usr/bin/env perl
use strict;
use warnings;

use Try::Tiny;

# エラー処理(モダン版)

try {
    open my $fh, "<", "not_exist_file" or die $!;
} catch {
    print "Error $_ \n";
};
