package Tyuren::DB::PointHistory;

use strict;
use warnings;

use FindBin;
use Params::Validate;

sub select_all {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	student_id => { regex => qr/\A[0-9]+\z/ },
    });

    my $sql = qq/
        SELECT
            *
        FROM
            point_history
        WHERE
            student_id = ?
        ;
    /;
    return $dbh->selectall_arrayref($sql, {}, $args{student_id});
}

sub insert {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	student_id => { regex => qr/\A[0-9]+\z/ },
	point      => { regex => qr/\A[0-9]+\z/ },
	memo       => { type => Params::Validate::SCALAR, optional => 1 },
    });

    my $sth = $dbh->prepare(qq/
        INSERT INTO
            point_history
            (student_id, point, memo)
        VALUES
            (? ,?, ?)
        ;
    /);

    return $sth->execute(
	$args{student_id},
	$args{point},
	defined $args{memo} ? $args{memo} : "",
    );
}

sub update_status {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	history_id => { regex => qr/\A[0-9]+\z/ },
	status     => { regex => qr/\A[0-1]\z/ },
   });

    my $sth = $dbh->prepare(qq/
        UPDATE
            point_history
        SET
            status = ?
        WHERE
            history_id = ?
        ;
    /);

    return $sth->execute(
	$args{status},
	$args{history_id},
    );
}

1;
