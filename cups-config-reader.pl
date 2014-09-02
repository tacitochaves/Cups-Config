#!/usr/bin/env perl
#
# This program will maintain the printers that are with Block state.
#
# Author: Tácito Chaves - 2014-08-21
# e-mail: chaves@tchaves.com.br
# skype: tacito.chaves

use strict;
use warnings;

use POSIX qw(strftime);

my $date_today = strftime "%Y-%m-%d %X", localtime;

# adds the lib directory
use FindBin;
use lib "$FindBin::Bin/lib";

# loads the module
use CUPS::Conf;

# instantiates and read the file
my $cnf = CUPS::Conf->new;

#$cnf->read("$FindBin::Bin/cups.conf");
$cnf->read("printers.conf");

# presents data
for my $printer ( keys %{ $cnf->config } ) {
    # checks the printer status
    if ( lc( $cnf->config($printer)->{State} ) eq 'stopped' ) {
        print "Impressora " . $printer . " esta Block $date_today \n";
        $cnf->pses_enable($printer);
        $cnf->log_file( $printer, $date_today );
    }
}
