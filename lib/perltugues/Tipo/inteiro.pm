package perltugues::Tipo::inteiro;

use base perltugues::Tipo;

our $tipo = "inteiro";

sub validator {
   my $self = shift;
   my $val  = shift;

   $val eq int $val
}

42
