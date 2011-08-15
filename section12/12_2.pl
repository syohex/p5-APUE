#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl qw(:flock);

# ファイル領域のロックを設定・解除する関数
sub read_lock {
    my ($fh, $offset, $whence, $length) = @_;
    flock $fh, LOCK_SH | LOCK_NB;
}

sub readw_lock {
    my ($fh, $offset, $whence, $length) = @_;
    flock $fh, LOCK_SH;
}

sub write_lock {
    my ($fh, $offset, $whence, $length) = @_;
    flock $fh, LOCK_EX | LOCK_NB;
}

sub writew_lock {
    my ($fh, $offset, $whence, $length) = @_;
    flock $fh, LOCK_EX;
}

sub un_lock {
    my ($fh, $offset, $whence, $length) = @_;
    flock $fh, LOCK_UN;
}

1;
