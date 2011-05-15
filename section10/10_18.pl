#!/usr/bin/env perl
use strict;
use warnings;

# POSIX.1のabortの実装

__END__

import signal, os
from ctypes import *
from posixsignal import *

def abort():
    mask = sigset_t()
    action = sigaction_t()

    # caller can't ignore SIGABRT, if so reset to default
    sigaction(signal.SIGABRT, None, byref(action))
    if action.sa_handler == cast(signal.SIG_IGN, sighandler_t):
        action.sa_handler = cast(signal.SIG_DFL, sighandler_t)
        sigaction(signal.SIGABRT, byref(action), None)

    if action.sa_handler == cast(signal.SIG_DFL, sighandler_t):
        libc.fflush(None)    # flush all open stdio streams

    # caller can't block SIGABRT; make sure it's unblocked
    sigfillset(byref(mask))
    sigdelset(byref(mask), signal.SIGABRT)   # mask has only SIGABRT turned off
    sigprocmask(SIG_SETMASK, byref(mask), None)

    os.kill(os.getpid(), signal.SIGABRT) # send the signal

    # if we are here, process caught SIGABRT and returned

    libc.fflush(None)    # flush all open stdio streams

    action.sa_handler = cast(signal.SIG_DFL, sighandler_t)
    sigaction(signal.SIGABRT, byref(action), None)   # reset disposition to default
    sigprocmask(SIG_SETMASK, byref(mask), None)      # just in case

    os.kill(os.getpid(), signal.SIGABRT)  # and one more time

    sys.exit(1)   # this should never be execused ...
