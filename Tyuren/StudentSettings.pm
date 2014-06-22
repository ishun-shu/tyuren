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
	filename => 'template/student_settings.tmpl'
    );
    Tyuren::PrintSystem->header_html();

    my $tyuren = Tyuren->new({});
    my $all_student = $tyuren->get_all_student_info;
    my @student_list;
    for my $student (keys %$all_student) {
	my $address = $tyuren->get_student_address($student);
	$all_student->{$student}->{email} = defined $address ? $$address[2] : "";
    }
    $tyuren->{dbh}->disconnect;
    push @student_list, $all_student->{$_} for(keys %$all_student);

    $template->param(
	all_student => \@student_list,
    );

    return $template->output();
}

1;
