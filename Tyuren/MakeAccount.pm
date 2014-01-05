package Tyuren::MakeAccount;

use strict;
use warnings;

use utf8;
use FindBin;

use Tyuren;
use Tyuren::PrintSystem;
use Tyuren::ParamsConverter;

sub execute {
    my $self = shift;    
    Tyuren::PrintSystem->header();

    my $params = Tyuren::ParamsConverter->get_params();
    my $tyuren = Tyuren->new($params);
    $tyuren->{dbh}->{AutoCommit} = 0;

    my $error_message;
    eval {
	my $student_id = $tyuren->select_student_id;
	if ($student_id) {
	    $error_message = 'already exists student';
	    die $error_message;
	}
	
	my $result = $tyuren->add_new_student;
	unless ($result) {
	    $error_message = 'cant add new student';
	    die $error_message;
	}
	
	$student_id = $tyuren->select_student_id;
	$tyuren->{params}->{student_id} = $student_id;	

	$result = $tyuren->add_new_student_info;
	unless ($result) {
	    $error_message = 'cant add new student info';
	    die $error_message;
	}
    };
    
    if ($@) {
	$tyuren->{dbh}->rollback;
	Tyuren::PrintSystem->ng($error_message);
	return 0;
    } else {
	$tyuren->{dbh}->commit;
	Tyuren::PrintSystem->ok();
    }

    $tyuren->{dbh}->disconnect;
    return 1;
}

1;
