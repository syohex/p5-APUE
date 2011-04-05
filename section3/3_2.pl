#!/usr/bin/env perl
use strict;
use warnings;

use POSIX qw(:fcntl_h);

# lseek()でファイル内部に間隙を作成する
my $mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
my $fd = POSIX::creat("file.hole", $mode);
die "Can't create file\n" unless defined $fd;

my $buf1 = 'abcdefg';
my $buf2 = 'ABCDEFG';

my $retval;
$retval = POSIX::write($fd, $buf1, length $buf1);
die "Can't write buf1 to file\n" unless defined $retval;

POSIX::lseek($fd, 40, &POSIX::SEEK_SET);

$retval = POSIX::write($fd, $buf2, length $buf2);
die "Can't write buf2 to file\n" unless defined $retval;

POSIX::close($fd) or die "Can't close file\n";
