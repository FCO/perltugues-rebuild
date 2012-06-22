package perltugues::Tipo;
use Carp;

our $tipo = "generico";

sub TIESCALAR {
   my $class = shift;
   bless {
      valor => undef,
   }, $class;
}

sub STORE {
   my $self = shift;
   my $val  = shift;
   $self->test($val);
   $self->{valor} = $val;
}

sub FETCH {
   my $self = shift;
   my $val  = shift;
   $self->test($self->{valor});
   $self->{valor}
}

sub test {
   my $self   = shift;
   my $val    = shift;
   my $ns     = ref $self;
   my $nstipo = "${ns}::tipo";
   $self->validator($val) || croak $self->{msg} || "valor '$val' não corresponde ao tipo '$$nstipo'";
}

sub validator {
   0
}

42
