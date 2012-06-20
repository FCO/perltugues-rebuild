#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'perltugues' ) || print "Bail out!\n";
}

diag( "Testing perltugues $perltugues::VERSION, Perl $], $^X" );
