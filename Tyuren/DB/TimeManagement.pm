package Tyuren::DB::TimeManagement;

use strict;
use warnings;

use FindBin;
use Params::Validate;

sub select_by_student_id {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	student_id => { regex => qr/\A[0-9]+\z/ },
    });

    my $sth = $dbh->prepare(qq/
        SELECT
            *
        FROM
            time_management
        WHERE
            student_id = ?
        ;
    /);

    $sth->execute(
	$args{student_id}
    );

    return $sth->fetchrow_hashref(qr/id/);
}

sub select_by_duration {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	start_datetime => { regex => qr/\A[0-9]{4}-[0-9]{2}-[0-9]{2}\s[0-9]{2}:[0-9]{2}:[0-9]{2}\z/ },
	end_datetime   => { regex => qr/\A[0-9]{4}-[0-9]{2}-[0-9]{2}\s[0-9]{2}:[0-9]{2}:[0-9]{2}\z/ },
    });

    my $sth = $dbh->prepare(qq/
        SELECT
            *
        FROM
            time_management
        WHERE
            timestamp BETWEEN ? AND ?
        ;
    /);

    $sth->execute(
	$args{start_datetime},
	$args{end_datetime}
    );

    return $sth->fetchall_arrayref();
}

sub insert {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	student_id => { regex => qr/\A[0-9]+\z/ },
	kind       => { regex => qr/\A[1-2]\z/ },
   });

    my $sth = $dbh->prepare(qq/
        INSERT INTO
            time_management
            (student_id, kind)
        VALUES
            (?, ?)
        ;
    /);

    return $sth->execute(
	$args{student_id},
	$args{kind}
    );
}

1;
