package perltugues::Tipo::inteiro;

use base perltugues::Tipo;

our $tipo = "inteiro";

sub validator {
   my $self = shift;
   my $val  = shift;

   $val =~ /^\d+,\d+$/;
}

sub transform_in {
   my $self  = shift;
   my $value = shift;

   $value =~ s/,/./;
   $value
}

sub transform_out {
   my $self  = shift;
   my $value = shift;

   $value =~ s/\./,/;
   $value
}

42
