package perltugues::Tipo::caracter;

use base perltugues::Tipo;

our $tipo = "caracter";

sub validator {
   my $self = shift;
   my $val  = shift;

   length $val == 1
}

42
