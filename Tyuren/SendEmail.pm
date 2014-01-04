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

use constant {
    LOGIN  => 1,
    LOGOUT => 2,
};

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
	subject    => defined $args->{subject} ? $args->{subject} : '櫻學舎からのお知らせ',
	body       => defined $args->{body} ? $args->{body} : '',
    });
}

sub send {
    my $self = shift;

    if ($self->{body} eq '') {
	if($self->{params}->{kind} == LOGIN || $self->{params}->{kind} == LOGOUT) {
	    $self->{body} = sprintf(
		_mail_body(),
		$self->{params}->{nickname},
		$KIND_TO_NAME->{$self->{params}->{kind}},
		$self->{params}->{total_point},
		Today_and_Now
	    );
	} else {
	    return 0;
	}
    }

    $self->{body} = Jcode::convert($self->{body},'jis');
    $self->{subject} = encode('MIME-Header', $self->{subject});
    my $cc = 'sakuragakusha+tyuren@gmail.com';
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
