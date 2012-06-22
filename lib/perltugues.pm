package perltugues;
use utf8;

use 5.006;
use strict;
use warnings;

use Filter::Simple;
use perltugues::Converter;

FILTER {
   my $code = $_;

   my $class = shift;
   my %par   = @_;

   my $conv = perltugues::Converter->new;

   if($par{ DEBUG_INPUT }) {
      print "CODE: $code", $/;
   }

   if($par{ DEBUG_PREPARER }) {
      $conv->debug_preparer;
   }

   if($par{ DEBUG_PARSER }) {
      $conv->debug_parser;
   }

   if($par{ DEBUG_PARSER_TRACE }) {
      $conv->debug_parser_trace;
   }

   $code = $conv->convert($code);

   if($par{ DEBUG }) {
      Perl::Tidy::perltidy(source => \$code, destination => \$code)
         if eval "require Perl::Tidy";
      print $code, $/;
      exit
   }
   $_ = $code;
}
