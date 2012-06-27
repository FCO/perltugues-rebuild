package perltugues::Tipo::inteiro;

use base perltugues::Tipo;

our $tipo  = "inteiro";
our $value = 0;

sub validator {
   my $self = shift;
   my $val  = shift;

   $val eq int $val
}

42
