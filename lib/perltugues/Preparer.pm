package perltugues::Preparer;

sub new {
   my $class = shift;
   my $self = bless {}, $class;
}

sub prepare_command {
   my $self = shift;
   my $cmd  = shift;

   return $cmd unless ref $cmd eq "HASH";
   my ($meth) = keys %$cmd;
   return $cmd unless $self->can($meth);
   $self->$meth($cmd)
}


42
