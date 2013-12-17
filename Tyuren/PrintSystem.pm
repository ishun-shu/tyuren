package Tyuren::PrintSystem;

use strict;
use warnings;

use utf8;
use FindBin;

sub header {
    print "Content-Type: text/plane; charset=utf-8;\n\n";
}

sub ok {
    print "0\n";
}

sub ng {
    my ($self, $message) = @_;
    print "NG!\nError : $message\n";
}

1;
