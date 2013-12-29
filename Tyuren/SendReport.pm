package Tyuren::SendReport;

use strict;
use warnings;

use FindBin;
use utf8;

use Tyuren;
use Tyuren::SendEmail

sub send {
    my ($self, %args) = @_;

    my $tyuren = Tyuren->new({});
    my $all_management;
    if ($args{type} eq 'daily') {
	$all_management = $tyuren->get_daily_management;
    } elsif ($args{type} eq 'monthly') {
	$all_management = $tyuren->get_montly_management;
    }
}

1;
