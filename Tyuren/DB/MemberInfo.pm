package Tyuren::DB::MemberInfo;

use strict;
use warnings;

use FindBin;
use Params::Validate;

sub select {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	student_id => { regex => qr/\A[0-9]+\z/ },
    });

    my $sth = $dbh->prepare(qq/
        SELECT
            *
        FROM
            member_info
        WHERE
            student_id = ?
        ;
    /);

    $sth->execute(
	$args{student_id},
    );
    return $sth->fetch();
}

sub select_all {
    my $self = shift;
    my $dbh = shift;

    my $sth = $dbh->prepare(qq/
        SELECT
            *
        FROM
            member_info
        ;
    /);

    $sth->execute();
    return $sth->fetchall_hashref('student_id');
}

sub insert {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	student_id      => { regex => qr/\A[0-9]+\z/ },
	account         => { type  => Params::Validate::SCALAR },
	create_datetime => { regex => qr/\A[0-9]{4}-[0-9]{2}-[0-9]{2}\s[0-9]{2}:[0-9]{2}:[0-9]{2}\z/ },
    });

    my $sth = $dbh->prepare(qq/
        INSERT INTO
            member_info
            (student_id, nickname, create_datetime)
        VALUES
            (?, ?, ?)
        ;
    /);

    return $sth->execute(
	$args{student_id},
	$args{account},
	$args{create_datetime},
    );
}

sub update_total_point {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	student_id  => { regex => qr/\A[0-9]+\z/ },
	total_point => { regex => qr/\A[0-9]+\z/ },
   });

    my $sth = $dbh->prepare(qq/
        UPDATE
            member_info
        SET
            total_point = ?
        WHERE
            student_id = ?
        ;
    /);

    return $sth->execute(
	$args{total_point},
	$args{student_id},
    );
}

sub update_status {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	student_id => { regex => qr/\A[0-9]+\z/ },
	status     => { regex => qr/\A[0-1]\z/ },
   });

    my $sth = $dbh->prepare(qq/
        UPDATE
            login_info
        SET
            status = ?
        WHERE
            student_id = ?
        ;
    /);

    return $sth->execute(
	$args{status},
	$args{student_id},
    );
}

sub update_can_send_email {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	student_id     => { regex => qr/\A[0-9]+\z/ },
	can_send_email => { regex => qr/\A[0-1]\z/ },
   });

    my $sth = $dbh->prepare(qq/
        UPDATE
            login_info
        SET
            can_send_email = ?
        WHERE
            student_id = ?
        ;
    /);

    return $sth->execute(
	$args{can_send_email},
	$args{student_id},
    );
}

1;
