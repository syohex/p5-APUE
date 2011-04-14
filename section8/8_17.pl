#!/usr/bin/env perl
use strict;
use warnings;

use Inline 'C';

# システムの実効記録ファイルの特定フィールドを出力する
#sudo aptitude install acctで /var/log/account/pacctに書きだされる
my $file = shift or die "Usage: $0 filename\n";
get_acct($file);

__END__
__C__
#include <stdio.h>
#include <sys/acct.h>

#ifdef HAS_SA_STAT
#define FMT "%-*.*s  e = %6ld, chars = %7ld, stat = %3u: %c %c %c %c\n"
#else
#define FMT "%-*.*s  e = %6ld, chars = %7ld, %c %c %c %c\n"
#endif
#ifndef HAS_ACORE
#define ACORE 0
#endif
#ifndef HAS_AXSIG
#define AXSIG 0
#endif

static unsigned long
compt2ulong(comp_t comptime)
{
    unsigned long    val;
    int    exp;

    val = comptime & 0x1fff;
    exp = (comptime >> 13) & 7;
    while (exp-- > 0)
        val *= 8;
    return(val);
}

void get_acct(char *file_name)
{
    struct acct_v3 acdata;
    FILE   *fp;

    fp = fopen(file_name, "r");
    if (fp == NULL) {
        return;
    }

    while (fread(&acdata, sizeof(struct acct_v3), 1, fp) == 1) {
        printf(FMT, (int)sizeof(acdata.ac_comm),
               (int)sizeof(acdata.ac_comm), acdata.ac_comm,
               compt2ulong(acdata.ac_etime), compt2ulong(acdata.ac_io),
#ifdef HAS_SA_STAT
               (unsigned char) acdata.ac_stat,
#endif
               acdata.ac_flag & ACORE ? 'D' : ' ',
               acdata.ac_flag & AXSIG ? 'X' : ' ',
               acdata.ac_flag & AFORK ? 'F' : ' ',
               acdata.ac_flag & ASU
               ? 'S' : ' ');
    }
}
