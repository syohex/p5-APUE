#!/usr/bin/env perl
use strict;
use warnings;

# ファイルにアクセス可能かチェックする
my $file = shift or die "Usage: $0 file\n";
my $mode = (stat($file))[2];

if ($mode & 0444) {
    print "read access OK\n";
} else {
    die "access error for $file\n";
}

open my $fh, "<", $file or die "Can't open file $!\n";
print "open for reading OK\n";
close $fh;
