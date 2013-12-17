package Tyuren::DB;

use strict;
use warnings;

use FindBin;
use DBI;

my $datasource = "DBI:mysql:tyuren:localhost";
my $user = "tyuren";
my $password = "sakuragakusha";

sub get_db {
    my $dbh = DBI->connect($datasource, $user, $password);
    return $dbh;
}

1;
