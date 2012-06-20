=head1 NAME

perltugues::Tipo::caracter - Tipo do pragma pertugues

=cut


package perltugues::Tipo::caracter;
use utf8;

use perltugues::Tipo;

my $VERSION= 0.1;

use overload 
   "=="  => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} eq $o->{valor}
                 }else{
                    return $r->{valor} eq $o
                 }
              },
   "!="  => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} ne $o->{valor}
                 }else{
                    return $r->{valor} ne $o
                 }
              },
   ">"  => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} gt $o->{valor}
                 }else{
                    return $r->{valor} gt $o
                 }
              },
   "<"  => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} lt $o->{valor}
                 }else{
                    return $r->{valor} lt $o
                 }
              },
   ">=" => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} ge $o->{valor}
                 }else{
                    return $r->{valor} ge $o
                 }
              },
   "<=" => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} le $o->{valor}
                 }else{
                    return $r->{valor} le $o
                 }
              },
;

@perltugues::Tipo::caracter::ISA = qw/perltugues::Tipo/;
sub new {
   my $class   = shift;
   my $r = $class->SUPER::new;
   $r->{valor} = 0;
   $r->{regex} = '^.?$';
   $r->{msg}   = 'Não é um Caracter';
   bless $r, $class
}
42;

=over

=item new()

metodo new...

=back

=cut


