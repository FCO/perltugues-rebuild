package perltugues;
use utf8;

use 5.006;
use strict;
use warnings;

use Filter::Simple;
use perltugues::Conterver;

FILTER {
   my $class = shift;
   my %par   = @_;


   $_ = perltugues::Converter->new->convert($_);

   if($par{ DEBUG }) {
      Perl::Tidy::perltidy(source => \$_, destination => \$_)
         if eval "require Perl::Tidy";
      print;
      exit
   }
}

42
