package perltugues::TypeResolver; 
use utf8;

sub get_type_of {
   my $self = shift;
   my $tree = shift;

   my $types = {      
      const_char    => [undef],
      const_str     => [undef],
      const_int     => [undef],
      const_real    => [undef],
      condition     => [undef],
      equal         => ["any", "any"],
      not_equal     => ["any", "any"],
      grater_than   => ["number", "number"],
      less_than     => ["number", "number"],
      grater_or_eq  => ["number", "number"],
      less_or_eq    => ["number", "number"],
      declair       => [undef, sub{shift; shift->[0]}],
      var           => [undef],
      assign        => [sub{shift->get_type_of(shift->[0])}, sub{shift->get_type_of(shift->[0])}],
      function_call => [undef],
      pre_incr      => ["number"],
      pos_incr      => ["number"],
      pre_decr      => ["number"],
      pos_decr      => ["number"],
      add           => ["number", "number"],
      subtract      => ["number", "number"],
      multiply      => ["number", "number"],
      divide        => ["number", "number"],
      block         => [undef],
      if_cmd        => ["inteiro"],
      unless_cmd    => ["inteiro"],
      for_cmd       => [undef, "inteiro", undef],
      foreach_cmd   => [undef],
      imprima       => [undef],
   };

   if(ref $tree eq "HASH" and keys %$tree == 1) {
      my ($key) = keys %$tree;
      my $type = $types->{$key};
      $type = $type->($tree->{$key}) if ref $type eq "CODE";
      return $type;
   } else {
      return $types->{$tree} if exists $types->{$tree};
      return $tree;
   }
}

sub can_receive {
   my $self = shift;
   my $wait = shift;
   my $got  = shift;

   if($wait eq "inteiro") {
      return 1 if $got eq "inteiro";
      return 1 if $got eq "real";
   } elsif($wait eq "caracter") {
      return 1 if $got eq "caracter";
      return 1 if $got eq "texto";
   } elsif($wait eq "real") {
      return 1 if $got eq "real";
   } elsif($wait eq "texto") {
      return 1 if $got eq "texto";
   }
}

sub real_types {
   my $self = shift;
   my $subt = shift;

   my @types    = qw/inteiro real caracter texto/;
   my %subtypes = (number => "inteiro|real");

   return $subt if grep {$subt eq $_} @types;
   return $self->real_types($subtypes{$subt}) if exists $subtypes{$subt};

   return map{$self->real_types($_)} split /\|/, $subt if $subt =~ /\|/;
   $subt
}

sub get_type_of {
   my $self = shift;
   my $tree = shift;

   my $types = {      
      const_char    => "caracter",
      const_str     => "texto",
      const_int     => "inteiro",
      const_real    => "real",
      condition     => "inteiro"
      equal         => "inteiro",
      not_equal     => "inteiro",
      grater_than   => "inteiro",
      less_than     => "inteiro",
      grater_or_eq  => "inteiro",
      less_or_eq    => "inteiro",
      #list_comma    => "list",
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
   } elsif(ref $tree eq "ARRAY") {
      return [ map {$self->get_type_of($_)} @$tree ]
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
