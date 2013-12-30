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

    my $params = Tyuren::ParamsConverter->get_params();
    my $tyuren = Tyuren->new($params);
    use Data::Dumper;
    $tyuren->{dbh}->disconnect;
    $template->param(
	is_success => 0,
	tyuren => Dumper $tyuren,
    );

    Tyuren::PrintSystem->header_html();
    return $template->output();
}

1;
