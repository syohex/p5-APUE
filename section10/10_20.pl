#!/usr/bin/env perl
use strict;
use warnings;

#POSIX.2の正しいsystem関数の実装

__END__

import signal, os
from ctypes import *
from posixsignal import *

def system(cmdstring):
    if not cmdstring:
        return 1    # always a command processor with Unix

    ignore = sigaction_t()
    saveintr = sigaction_t()
    savequit = sigaction_t()

    chldmask = sigset_t()
    savemask = sigset_t()

    # ignore SIGINT and SIGQUIT
    ignore.sa_handler = cast(signal.SIG_IGN, sighandler_t)
    sigemptyset(byref(ignore.sa_mask))
    ignore.sa_flags = 0

    if sigaction(signal.SIGINT, byref(ignore), byref(saveintr)) < 0:
        return -1
    if sigaction(signal.SIGQUIT, byref(ignore), byref(savequit)) < 0:
        return -1

    # now block SIGCHLD
    sigemptyset(byref(chldmask))
    sigaddset(byref(chldmask), signal.SIGCHLD)
    if sigprocmask(SIG_BLOCK, byref(chldmask), byref(savemask)) < 0:
        return -1

    pid = os.fork()
    if pid == 0:    # child
        # restore previous signal actions & reset signal mask
        sigaction(signal.SIGINT, byref(saveintr), None)
        sigaction(signal.SIGQUIT, byref(savequit), None)
        sigprocmask(SIG_SETMASK, byref(savemask), None)
        os.execl("/bin/sh", "sh", "-c", cmdstring)
        sys.exit(127)  # exec error
    else:    # parent
        while True:
            try:
                pid, status = os.waitpid(pid, 0)
                break
            except OSError, e:
                if e.errno != errno.EINTR:
                    status = -1  # error other than EINTR from waitpid()
                    break

    # restore previous signal actions & reset signal mask
    if sigaction(signal.SIGINT, byref(saveintr), None) < 0:
        return -1
    if sigaction(signal.SIGQUIT, byref(savequit), None) < 0:
        return -1
    if sigprocmask(SIG_SETMASK, byref(savemask), None) < 0:
        return -1

    return status