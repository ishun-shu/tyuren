#!usr/bin/perl

use strict;
use warnings;
use utf8;
use Data::Dumper;
use Tyuren::SendEmail;

my $params = {
    nickname    => "富永裕大",
    total_point => 100,
    address     => 'sakuragakusha@gmail.com',
};
my $mail = Tyuren::SendEmail->new($params);
$mail->send;
