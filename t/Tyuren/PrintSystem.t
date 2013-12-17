#!/usr/bin/perl
use strict;
use warnings;

use lib "virtual/tyuren/public_html/tyuren/t/inc/";
use Test::More;
plan(tests => 5);

use_ok("Tyuren::PrintSystem");
can_ok("Tyuren::PrintSystem", qw/
    header
    ok
    ng
/);

my $result = Tyuren::PrintSystem->header();
is($result, "ContentType:text/plane; charset=utf-8\n\n");

$result = Tyuren::PrintSystem->ok();
is($result, "0\n");

$result = Tyuren::PrintSystem->ng('Internal Error');
is($result, "Error : Interna Error\n");

