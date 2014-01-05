package Tyuren::SendReport;

use strict;
use warnings;

use FindBin;
use utf8;
use Date::Calc qw/Today_and_Now/;

use Tyuren;
use Tyuren::SendEmail;

sub send {
    my ($self, %args) = @_;

    my $tyuren = Tyuren->new({});
    my $all_management;
    if ($args{type} eq 'daily') {
	$all_management = $tyuren->get_daily_time_management;
    } elsif ($args{type} eq 'monthly') {
	$all_management = $tyuren->get_monthly_time_management;
    }

    my $body = "id,student_id,kind,timestamp\n";
    for my $management (@$all_management) {
	for my $value (@$management) {
	    $body .= "$value,";
	}
	$body .= "\n";
    }
    $body .= "==============================\n";
    $body .= sprintf("%04d-%02d-%02d %02d:%02d:%02d", Today_and_Now);

    my $mailer = Tyuren::SendEmail->new({
	address => 'sakuragakusha@gmail.com',
	subject => "$args{type} report mail",
	body    => $body,
    });

    return $mailer->send;
}

1;
