package perltugues::Validate;

use perltugues::TypeResolver;

sub new {
   my $class = shift;
   my $self = bless {
      type_resolver => perltugues::TypeResolver->new,
   }, $class;
   $self
}

sub type_resolver {
   my $self = shift;
   my $tr   = shift;

   if(defined $tr) {
      $self->{type_resolver} = $tr;
      return $self
   }
   $self->{type_resolver}
}

sub validate {
   my $self = shift;
   my $tree = shift;

   if(ref $tree eq "ARRAY") {
      for my $cmd(@$tree) {
         $self->validate($cmd);
      }
   } elsif(ref $tree eq "HASH") {
      my ($key)  = keys %$tree;
      my $wanted = $self->type_resolver->type_wanted_by($tree);
      my $got    = $self->type_resolver->get_type_of($tree->{$key})

      for my $wan (@$wanted) {
         next unless defined $wan;
      }
   }

42
