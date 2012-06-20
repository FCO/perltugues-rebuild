=head1 NAME

perltugues::Tipo::inteiro - Tipo do pragma pertugues

=cut


package perltugues::Tipo::inteiro;

use perltugues::Tipo;
my $VERSION= 0.1;

use overload 
   "=="  => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} == $o->{valor}
                 }else{
                    return $r->{valor} == $o
                 }
              },
   "!="  => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} != $o->{valor}
                 }else{
                    return $r->{valor} != $o
                 }
              },
   ">"  => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} > $o->{valor}
                 }else{
                    return $r->{valor} > $o
                 }
              },
   "<"  => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} < $o->{valor}
                 }else{
                    return $r->{valor} < $o
                 }
              },
   ">=" => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} >= $o->{valor}
                 }else{
                    return $r->{valor} >= $o
                 }
              },
   "<=" => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} <= $o->{valor}
                 }else{
                    return $r->{valor} <= $o
                 }
              },
;
@perltugues::Tipo::inteiro::ISA = qw/perltugues::Tipo/;
sub new {
   my $class   = shift;
   my $r = $class->SUPER::new;
   $r->{valor} = 0;
   $r->{regex} = '^\d+$';
   $r->{msg}   = 'Não é Inteiro';
   bless $r, $class
}
42;

=over

=item new()

metodo new...

=back

=cut


