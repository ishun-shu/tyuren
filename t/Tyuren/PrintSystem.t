#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Capture::Tiny qw/capture/;

BEGIN {
    use_ok("Tyuren::PrintSystem");
    can_ok("Tyuren::PrintSystem", qw/
        header
        ok
        ng
    /);
};

subtest 'header' => sub {
    my ($stdout, $strerr) = capture {
	Tyuren::PrintSystem->header();
    };
    is($stdout, "Content-Type: text/plane; charset=utf-8;\n\n");
};


subtest 'ok' => sub {
    my ($stdout, $strerr) = capture {
	Tyuren::PrintSystem->ok();
    };
    is($stdout, "0\n");
};

subtest 'ng' => sub {
    my ($stdout, $strerr) = capture {
	Tyuren::PrintSystem->ng("Internal Error");
    };
    is($stdout, "NG!\nError : Internal Error\n");
};

done_testing();

