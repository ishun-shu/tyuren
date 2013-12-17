package Tyuren::DB::MemberAddress;

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
            member_address
        WHERE
            student_id = ?
        ;
    /);

    $sth->execute(
	$args{student_id},
    );

    return $sth->fetch();
}

sub insert {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	student_id => { regex => qr/\A[0-9]+\z/ },
	email      => { type => Params::Validate::SCALAR },
	email2     => { type => Params::Validate::SCALAR, optional => 1 },
   });

    my $sth = $dbh->prepare(qq/
        INSERT INTO
            member_address
            (student_id, email, email2)
        VALUES
            (?, ?, ?)
        ;
    /);

    return $sth->execute(
	$args{student_id},
	$args{email},
	defined $args{email2} ? $args{email2} : "",
    );
}

sub update_email {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	student_id => { regex => qr/\A[0-9]+\z/ },
	email      => { type => Params::Validate::SCALAR },
   });

    my $sth = $dbh->prepare(qq/
        UPDATE
            member_address
        SET
            email = ?
        WHERE
            student_id = ?
        ;
    /);

    return $sth->execute(
	$args{email},
	$args{student_id},
    );
}

sub update_email2 {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	student_id => { regex => qr/\A[0-9]+\z/ },
	email2     => { type => Params::Validate::SCALAR },
   });

    my $sth = $dbh->prepare(qq/
        UPDATE
            member_address
        SET
            email2 = ?
        WHERE
            student_id = ?
        ;
    /);

    return $sth->execute(
	$args{email2},
	$args{student_id},
    );
}

1;
