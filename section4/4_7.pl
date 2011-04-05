#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl ":mode";
use File::Find;

# ファイルの種類を数えながら、再帰的にディレクトリ構造を辿る

my $search_dir = shift or die "Usage: $0 search_dir\n";

my %file_type;
sub calc {
    my $file = $File::Find::name;

    my $mode = (lstat $file)[2];

    if (S_ISREG($mode)) {
        $file_type{regular_file}++;
    } elsif (S_ISBLK($mode)) {
        $file_type{block_special}++;
    } elsif (S_ISCHR($mode)) {
        $file_type{char_special}++;
    } elsif (S_ISFIFO($mode)) {
        $file_type{FIFOs}++;
    } elsif (S_ISLNK($mode)) {
        $file_type{symbolic_link}++;
    } elsif (S_ISSOCK($mode)) {
        $file_type{sockets}++;
    } elsif (S_ISDIR($mode)) {
        $file_type{directories}++;
    }
}

find(\&calc, $search_dir);

my $total = 0;
map { $total += $_; } values %file_type;

while (my ($key, $val) = each %file_type) {
    $key =~ s{_}{ };

    printf "%15s: %10d, %10g\n", $key, $val, $val*100/$total;
}
