package Tyuren::StudentSettings;

use strict;
use warnings;

use utf8;
use FindBin;
use HTML::Template::Pro;

use Tyuren;
use Tyuren::ParamsConverter;

sub display {
    my $self = shift;

    my $template = HTML::Template::Pro->new(
	filename => 'template/tyuren_settings.tmpl'
    );

    my $tyuren = Tyuren->new({});
    my $all_student = $tyuren->get_all_student;
    $template->param(
	all_student => $all_student,
    )->output();
}

1;
