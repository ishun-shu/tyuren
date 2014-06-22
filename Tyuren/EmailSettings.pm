package Tyuren::EmailSettings;

use strict;
use warnings;

use lib '/virtual/tyuren/lib/perl5';
use FindBin;
use utf8;
use HTML::Template::Pro;

use Tyuren;
use Tyuren::PrintSystem;
use Tyuren::ParamsConverter;

sub display {
    my $self = shift;

    my $template = HTML::Template::Pro->new(
	filename => 'template/email_settings.tmpl'
    );
    Tyuren::PrintSystem->header_html();

    my $params = Tyuren::ParamsConverter->get_params();
    my $tyuren = Tyuren->new($params);
    my $is_success = 0;
    my $address;

    if(defined $params && $params->{mode} eq "change_can_send") {
	$is_success = $tyuren->change_can_send_email;
    } elsif (defined $params && $params->{mode} eq "change_email") {
	$address = $tyuren->get_student_address;
	if($address) {
	    $is_success = $tyuren->update_student_address;
	} else {
	    $is_success = $tyuren->add_student_address;
	}
    }

    $tyuren->{dbh}->disconnect;
    $template->param(
	is_success => $is_success,
    );

    return $template->output();
}

1;
