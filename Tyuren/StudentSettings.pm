package Tyuren::StudentSettings;

use strict;
use warnings;

use lib '/virtual/tyuren/lib/perl5';
use FindBin;
use utf8;
use HTML::Template::Pro;

use Tyuren;
use Tyuren::PrintSystem;

sub display {
    my $self = shift;

    my $template = HTML::Template::Pro->new(
	filename => 'template/tyuren_settings.tmpl'
    );

    my $tyuren = Tyuren->new({});
    my $all_student = $tyuren->get_all_student_info;
    my @student_list;
    push @student_list, $all_student->{$_} for(keys %$all_student);

    $template->param(
	all_student => \@student_list,
    );

    Tyuren::PrintSystem->header_html();
    return $template->output();
}

1;
