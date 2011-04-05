#!/usr/bin/env perl
use strict;
use warnings;

# 指定したファイルの種類を出力する(ファイルテストを利用)

die "Usage $0 file1 file2 ..." if scalar @ARGV == 0;

for my $file (@ARGV) {
    print "$file type is ";

    if (-l $file) {
        print "symbolic link\n"
    } elsif (-d $file) {
        print "directory\n";
    } elsif (-c $file) {
        print "character special\n"
    } elsif (-f $file) {
        print "regular\n"
    } else {
        print "** unknown mode **\n";
    }
}
