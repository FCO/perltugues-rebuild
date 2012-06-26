package perltugues::TypeResolver; 
use utf8;

sub get_type_of {
   my $self = shift;
   my $tree = shift;

   my $types = {      
      const_char    => "caracter",
      const_str     => "texto",
      const_int     => "inteiro",
      condition     => "inteiro"
      equal         => "inteiro",
      not_equal     => "inteiro",
      grater_than   => "inteiro",
      less_than     => "inteiro",
      grater_or_eq  => "inteiro",
      less_or_eq    => "inteiro",
      const_real    => "real",
      list_comma    => "list",
      declair       => sub{shift->[0]},
      var           => sub{},
      assign        => sub{$self->get_type_of(shift->[0])},
      function_call => sub{},
      pre_incr      => sub{$self->get_type_of(shift->[0])},
      pos_incr      => sub{$self->get_type_of(shift->[0])},
      pre_decr      => sub{$self->get_type_of(shift->[0])},
      pos_decr      => sub{$self->get_type_of(shift->[0])},
      add           => sub{$self->decide($self->get_type_of(shift->[0]), $self->get_type_of(shift->[1]))},
      subtract      => sub{$self->decide($self->get_type_of(shift->[0]), $self->get_type_of(shift->[1]))},
      multiply      => sub{$self->decide($self->get_type_of(shift->[0]), $self->get_type_of(shift->[1]))},
      divide        => sub{$self->decide($self->get_type_of(shift->[0]), $self->get_type_of(shift->[1]))},
      block         => undef,
      if_cmd        => undef,
      unless_cmd    => undef,
      for_cmd       => undef,
      foreach_cmd   => undef,
      imprima       => undef,
   };

   if(ref $tree eq "HASH" and keys %$tree == 1) {
      my ($key) = keys %$tree;
      my $type = $types->{$key};
      $type = $type->($tree->{$key}) if ref $type eq "CODE";
      return $type;
   }
}

sub decide {
   my $self  = shift;
   my $type1 = shift;
   my $type2 = shift;

   if($type1 eq $type2) {
      return $type1
   } elsif(($type1 eq "inteiro" or $type1 eq "real") and ($type2 eq "inteiro" or $type2 eq "real")) {
      return "real"
   } elsif(($type1 eq "caracter" or $type1 eq "texto") and ($type2 eq "caracter" or $type2 eq "texto")) {
      return "texto"
   } else {
      return
   }
}

42
