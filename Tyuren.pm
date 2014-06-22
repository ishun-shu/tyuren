package Tyuren;

use base qw/Class::Accessor::Fast/;

use strict;
use warnings;

use FindBin;
use Date::Calc qw/Today Today_and_Now Add_Delta_Days Add_Delta_YMD Days_in_Month/;

use Tyuren::DB;
use Tyuren::DB::LoginInfo;
use Tyuren::DB::MemberInfo;
use Tyuren::DB::MemberAddress;
use Tyuren::DB::TimeManagement;
use Tyuren::DB::PointHistory;

sub new {
    my ($class, $args) = @_;
    return $class->SUPER::new({
	params => $args,
	dbh    => Tyuren::DB->get_db,
    });
}

sub select_student_id {
    my $self = shift;
    my $login_info =  Tyuren::DB::LoginInfo->select($self->{dbh}, {
	idm => $self->{params}->{idm},
    });
    return @$login_info[0];
}

sub add_new_student {
    my $self = shift;
    eval {
	Tyuren::DB::LoginInfo->insert($self->{dbh}, {
	    idm      => $self->{params}->{idm},
	    password => $self->{params}->{password},
	});
    };
    return $@ ? 0 : 1;
}

sub get_student_info {
    my $self = shift;
    return Tyuren::DB::MemberInfo->select($self->{dbh}, {
	student_id => $self->{params}->{student_id},
    });
}

sub get_all_student_info {
    my $self = shift;
    return Tyuren::DB::MemberInfo->select_all($self->{dbh});
}

sub add_new_student_info {
    my $self = shift;
    my $create_datetime = sprintf("%04d-%02d-%02d %02d:%02d:%02d", Today_and_Now());
    eval {
      Tyuren::DB::MemberInfo->insert($self->{dbh}, {
	  student_id      => $self->{params}->{student_id},
	  account         => $self->{params}->{account},
	  create_datetime => $create_datetime,
      });
    };
    return $@ ? 0 : 1;
}

sub set_total_point {
    my $self = shift;

    eval {
	Tyuren::DB::MemberInfo->update_total_point($self->{dbh}, {
	    student_id  => $self->{params}->{student_id},
	    total_point => $self->{params}->{total_point},
        });
    };
    return $@ ? 0 : 1;
}

sub change_student_status {
    my $self = shift;
    my $status = shift;
    eval {
	Tyuren::DB::MemberInfo->update_status($self->{dbh}, {
	    student_id => $self->{params}->{student_id},
	    status     => $status,
	});
    };
    return $@ ? 0 : 1;
}

sub change_can_send_email {
    my $self = shift;
    my $can_send_email = shift;
    eval {
	Tyuren::DB::MemberInfo->update_can_send_email($self->{dbh}, {
	    student_id     => $self->{params}->{student_id},
	    can_send_email => $can_send_email,
	});
    };
    return $@ ? 0 : 1;
}

sub get_student_address {
    my $self = shift;
    return Tyuren::DB::MemberAddress->select($self->{dbh}, {
	student_id => $self->{params}->{student_id},
    });
}

sub add_student_address {
    my $self = shift;
    my $email = shift;
    my $email2 = shift;
    eval {
	Tyuren::DB::MemberAddress->insert($self->{dbh}, {
	    student_id => $self->{params}->{student_id},
	    email      => $email,
	    defined $email2 ? (email2 => $email2) : (),
	});
    };
    return $@ ? 0 : 1;
}

sub get_time_management {
    my $self = shift;
    return Tyuren::DB::TimeManagement->select_by_student_id($self->{dbh}, {
	student_id => $self->{params}->{student_id},
    });
}

sub get_daily_time_management {
    my $self = shift;

    # target date is yesterday
    my ($year, $month, $day) = Add_Delta_Days(Today(), -1);
    return Tyuren::DB::TimeManagement->select_by_duration($self->{dbh}, {
	start_datetime => sprintf("%04d-%02d-%02d 00:00:00", $year, $month, $day),
	end_datetime   => sprintf("%04d-%02d-%02d 23:59:59", $year, $month, $day),
    });
}

sub get_monthly_time_management {
    my $self = shift;

    # target date is last month
    my ($year, $month) = Add_Delta_YMD(Today(), 0, -1, 0);
    my $days = Days_in_Month($year, $month);

    return Tyuren::DB::TimeManagement->select_by_duration($self->{dbh}, {
	start_datetime => sprintf("%04d-%02d-01 00:00:00", $year, $month),
	end_datetime   => sprintf("%04d-%02d-%02d 23:59:59", $year, $month, $days),
    });
}

sub set_time_management {
    my $self = shift;
    eval {
	Tyuren::DB::TimeManagement->insert($self->{dbh}, {
	    student_id => $self->{params}->{student_id},
	    kind       => $self->{params}->{kind},
        });
    };
    return $@ ? 0 : 1;
}

sub get_point_history {
    my $self = shift;

    return Tyuren::DB::PointHistory->select_all($self->{dbh}, {
	student_id => $self->{params}->{student_id},
    });
}

sub add_new_point_history {
    my $self = shift;
    my $memo = shift;

    eval {
	Tyuren::DB::PointHistory->insert($self->{dbh}, {
	    student_id => $self->{params}->{student_id},
	    point      => $self->{params}->{point},
	    memo       => $memo ? $memo : "",
	});
    };
    return $@ ? 0 : 1;
}

sub change_point_history_status {
    my $self = shift;
    my $history_id = shift;
    my $status = shift;
    eval {
	Tyuren::DB::PointHistory->update_status($self->{dbh}, {
	    history_id => $history_id,
	    status     => $status,
	});
    };
    return $@ ? 0 : 1;
}

1;
