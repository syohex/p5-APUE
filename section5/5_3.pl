#!/usr/bin/env perl
use strict;
use warnings;

use FileHandle;

# さまざまな標準入出力ストリームのバッファリング方式を表示する

{
    local $| = 1;
    print STDOUT "Not buffering with \$|\n"
}

STDOUT->autoflush(1);
print STDOUT "Not buffering with autoflush\n";

__END__
# デフォルトのビルドオプションでは setvbufは無効

my $fh = FileHandle->new("test", "w");
die "Can't open file\n" unless defined $fh;

$fh->setvbuf(my $buf, _IOLBF, 1024);
$fh->print("AAA\nBBB\nCCC\n");
