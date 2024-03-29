use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'perltugues',
    AUTHOR              => q{Fernando Correa de Oliveira <fco@cpan.org>},
    VERSION_FROM        => 'lib/perltugues.pm',
    ABSTRACT_FROM       => 'lib/perltugues.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    EXE_FILES		=> [qw{bin/perltugues}],
    PREREQ_PM => {
        'Test::More'		=> 0,
	'Parse::RecDescent'	=> 1.967009,
	'Filter::Simple'	=> 0.84,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'perltugues-*' },
);
