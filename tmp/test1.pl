#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use LWP::UserAgent;
use Data::Dumper;

my $ua = LWP::UserAgent->new;
$ua->timeout(10);

my $uri = "http://sakuragakusha.com/tyuren/make_account.pl";
my $params = {
    account  => "しゅう",
    idm      => "1234567890abcdef",
    password => "hogehoge",
};

my $responce = $ua->post($uri, $params);
print Dumper $responce;
