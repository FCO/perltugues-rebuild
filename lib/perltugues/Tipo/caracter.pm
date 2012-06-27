package perltugues::Tipo::caracter;

use base perltugues::Tipo;

our $tipo  = "caracter";
our $value = "\0";

sub validator {
   my $self = shift;
   my $val  = shift;

   length $val == 1
}

42
