#!/usr/bin/perl
#Copyright© 2013 SakuraGakuSha All Rights Reserved.

use strict;
use warnings;

use FindBin;
use Tyuren::SendReport;

Tyuren::SendReport->send(
    type => 'monthly'
);
