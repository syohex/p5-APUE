#!/usr/bin/env perl
use strict;
use warnings;

use utf8;
binmode STDOUT, ":utf8";

# getpwnam関数
my @params = qw(
  ログイン名
  暗号化されたパスワード
  ユーザID
  グループID
  リアルネーム
  ホームディレクトリ
  シェル
);

my $name   = shift or die "Usage: $0 username\n";
my @passwd_info = getpwnam($name);

die "Can't get '$name' info\n" if scalar @passwd_info == 0;

# 4番目と 5番目の内容が不明. perldocに何も記載がない

my @info = @passwd_info[0..3,6..8];
while (@params && @info) {
    my $val   = shift @info;
    my $param = shift @params;

    print "$param:$val\n";
}
