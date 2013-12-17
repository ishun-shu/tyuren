package Tyuren::DB::LoginInfo;

use strict;
use warnings;

use FindBin;
use Params::Validate;

sub select {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	idm => { regex => qr/\A[0-9a-f]{16}\z/ },
    });

    my $sth = $dbh->prepare(qq/
        SELECT
            *
        FROM
            login_info
        WHERE
            felica_idm = ?
        ;
    /);

    $sth->execute(
	$args{idm},
    );

    return $sth->fetch();
}

sub insert {
    my $self = shift;
    my $dbh = shift;
    my %args = Params::Validate::validate(@_, {
	idm      => { regex => qr/\A[0-9a-f]{16}\z/ },
	password => { regex => qr/\A[0-9a-f]{64}\z/ },
    });

    my $sth = $dbh->prepare(qq/
        INSERT INTO
            login_info
            (felica_idm, user_password)
        VALUES
            (? ,?)
        ;
    /);

    return $sth->execute(
	$args{idm},
	$args{password}
    );
}

1;
