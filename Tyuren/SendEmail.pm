package Tyuren::SendEmail;

use strict;
use warnings;

use base qw/Class::Accessor::Fast/;

use utf8;
use FindBin;
use Date::Calc qw/Today_and_Now/;
use Encode;
use Jcode;

my $KIND_TO_NAME = {
    1 => '入室',
    2 => '退室',
};

sub new {
    my ($class, $args) = @_;
    return unless $args;
    return $class->SUPER::new({
	params     => $args,
	from_email => 'admin@sakuragakusha.com',
	to_email   => $args->{address},
	subject    => '桜学舎からのお知らせ',
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

    open(SDML,"| /usr/lib/sendmail -i") || die 'sendmail error';
    $self->{subject} = encode('MIME-Header', $self->{subject});
    print SDML "MIME-Version: 1.0\n";
    print SDML "From: $self->{from_email}\n";
    print SDML "To: $self->{to_email}\n";
    print SDML "Subject: $self->{subject}\n";
    print SDML "Content-Transfer-Encoding: 7bit\n";
    print SDML "Content-Type: text/plain; charset=\"ISO-2022-JP\"\n\n";
    print SDML Jcode::convert($self->{body},'jis');
    close SDML;
}

sub _mail_body {
    return "%sさんが桜学舎に%sしました\n現在のポイント数は%dです\n\n%04d-%02d-%02d %02d:%02d:%02d\n";
}

1;
