package perltugues::Writer;
use utf8;
use Carp;

sub new {
   my $class = shift;
   my %pars  = @_;
   my $data = {
      ident      => 0,
      ident_unit => "   ",
      ns_types   => "*",
   };
   for my $key(keys %$data) {
      $data->{$key} = $pars{$key} if exists $pars{$key}
   }
   my $self = bless $data, $class;
   for my $meth (qw/begin ident_incr ident_decr ident get_code_for declair function_call write_includes/) {
      croak "Classe '$class' não implementa '$meth'" unless $self->can($meth)
   }
   $self
}

42
