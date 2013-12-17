package Tyuren::TimeRecoder;

use strict;
use warnings;

use utf8;
use FindBin;
use Encode;

use Tyuren;
use Tyuren::PrintSystem;
use Tyuren::ParamsConverter;
use Tyuren::SendEmail;

my $ADD_POINT = 1;
my $PASSCODE = 'sakuragakusha2013';

sub execute {
    my $self = shift;    
    Tyuren::PrintSystem->header();

    my $params = Tyuren::ParamsConverter->get_params();
    my $tyuren = Tyuren->new($params);
    $tyuren->{dbh}->{AutoCommit} = 0;

    my ($error_message, $student_id);
    eval {
	if ($tyuren->{params}->{passcode} ne $PASSCODE) {
	    $error_message = 'invalid passcord';
	    die $error_message;
	}

	$student_id = $tyuren->select_student_id;
	unless ($student_id) {
	    $error_message = 'unknown student';
	    die $error_message;
	}

	$tyuren->{params}->{student_id} = $student_id;
	my $result = $tyuren->set_time_management;
	unless ($result) {
	    $error_message = 'cant set time management';
	    die $error_message;
	}

	$tyuren->{params}->{point} = $ADD_POINT;
	$result = $tyuren->add_new_point_history();
	unless ($result) {
	    $error_message = 'cant add new point history';
	    die $error_message;
	}

	my $point_history = $tyuren->get_point_history;
	my $total_point = 0;
	for my $history (@$point_history) {
	    $total_point += $history->[2] if $history->[3];
	}
	$tyuren->{params}->{total_point} = $total_point;
	$result = $tyuren->set_total_point;
	unless ($result) {
	    $error_message = 'cant set total point';
	    die $error_message;
	}
    };
    
    if ($@) {
	$tyuren->{dbh}->rollback;
	Tyuren::PrintSystem->ng($error_message);
    } else {
	$tyuren->{dbh}->commit;
	Tyuren::PrintSystem->ok();
    }

    # メール送信
    my $student_info = $tyuren->get_student_info;
    my $address = $tyuren->get_student_address;
    my $mailer = Tyuren::SendEmail->new({
	nickname    => decode('utf8', $student_info->[1]),
	total_point => $tyuren->{params}->{total_point},
	address     => $address->[2],
    });
    my $can_send_email = $student_info->[4];
    if($can_send_email) {
	$mailer->send();
    }

    $tyuren->{dbh}->disconnect;
}

1;
