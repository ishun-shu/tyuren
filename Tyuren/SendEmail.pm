package Tyuren::SendEmail;

use strict;
use warnings;

use base qw/Class::Accessor::Fast/;

use utf8;
use FindBin;
use Encode;
use Jcode;
use Date::Calc qw/Today_and_Now/;
use Mail::Sendmail;

my $KIND_TO_NAME = {
    1 => 'に入室',
    2 => 'を退室',
};

sub new {
    my ($class, $args) = @_;
    return unless $args;
    return $class->SUPER::new({
	params     => $args,
	from_email => 'admin@sakuragakusha.com',
	to_email   => $args->{address},
	subject    => '櫻學舎からのお知らせ',
	body       => '',
    });
}

sub send {
    my $self = shift;
    $self->{body} = sprintf(
	_mail_body(),
	$self->{params}->{nickname},
	$KIND_TO_NAME->{$self->{params}->{kind}},
	$self->{params}->{total_point},
	Today_and_Now
    );

    $self->{body} = Jcode::convert($self->{body},'jis');
    $self->{subject} = encode('MIME-Header', $self->{subject});
    my $cc = 'sakuragakusha+tyuren@gmail';
    my %mail = (
	'Content-Type' => 'text/plain; charset="iso-2022-jp"',
	'From'         => $self->{from_email},
	'To'           => $self->{to_email},
	'Cc'           => $cc,
	'Subject'      => $self->{subject},
	'message'      => $self->{body},
    );

    sendmail %mail;
}

sub _mail_body {
    return "%sさんが櫻學舎%sしました\n現在のポイント数は%dです\n\n%04d-%02d-%02d %02d:%02d:%02d\n";
}

1;
