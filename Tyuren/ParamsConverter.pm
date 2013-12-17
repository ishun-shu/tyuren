package Tyuren::ParamsConverter;

use strict;
use warnings;

use utf8;
use Digest::SHA qw/sha256_hex/;
use CGI;

sub get_params {
    my $self = shift;
    my $data;
    if ( $ENV{'REQUEST_METHOD'} eq 'POST') {
	read(STDIN, $data, $ENV{'CONTENT_LENGTH'});
    } else {
	$data = $ENV{'QUERY_STRING'};
    }
    my $params;
    for my $param (split(/&/, $data)) {
	my ($key, $value) = split(/=/, $param);
	$value = $self->encrypt($value) if $key eq 'password';
	$params->{$key} = CGI::unescape($value);
    }
    return $params;
}

sub encrypt {
    my $self = shift;
    my $value = shift;
    return sha256_hex($value);
}

1;
