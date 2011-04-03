#!/usr/bin/env perl
use strict;
use warnings;

# ディレクトリ内の全てのファイルをリストする

my $dirname = shift or die "$0 directory_name\n";

opendir my $dh, $dirname or die "Can't open directory:$dirname\n";
map { print "$_\n" unless $_ =~ m{^\.} } readdir $dh;
closedir $dh or die "Can't close directory:$dirname\n";
