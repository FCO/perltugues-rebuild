package perltugues::PerlWriter;

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
   bless $data, $class
}

sub ident_incr {
   my $self = shift;
   $self->{ident}++;
   $self
}

sub ident_decr {
   my $self = shift;
   $self->{ident}--;
   $self
}

sub ident {
   my $self = shift;
   if(@_) {
      $self->{ident} = shift;
      return $self
   }
   $self->{indet_unit} x $self->{ident}
}

sub get_code_for {
   my $self = shift;
   my $meth = shift;

   $self->ident . $self->$meth(@_)
}

sub declair {
   my $self    = shift;
   my $type    = shift;
   my $varname = shift;

   (my $ns_type = $self->{ns_types}) =~ s/\*/$type/g;

   "my \$$varname = $ns_type->new;"
}

sub function_call {
}

42
