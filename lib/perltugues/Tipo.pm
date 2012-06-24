package perltugues::Tipo;
use Carp;

our $tipo = "generico";
our $msg;

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
   $self->{valor} = $self->transform_in($val);
}

sub FETCH {
   my $self = shift;
   my $val  = $self->transform_out($self->{valor});
   $self->test($val);
   $self->{valor}
}

sub transform_out {
   my $self  = shift;
   my $value = shift;

   $value
}

sub transform_in {
   my $self  = shift;
   my $value = shift;

   $value
}

sub test {
   my $self   = shift;
   my $val    = shift;
   my $ns     = ref $self;
   my $nstipo = "${ns}::tipo";
   my $error = "valor '$val' não corresponde ao tipo '$$nstipo'";
   if(defined $msg) {
      my $data = (val => $val, tipo => $$nstipo);
      ($error = $msg) =~ s/\[%\s*(\w+)\s*%\]/$data{$1}/ge;
   }
   $self->validator($val) || croak $error
}

sub validator {
   0
}

42
