package perltugues::Preparer;

sub new {
   my $class = shift;
   my $self = bless {}, $class;
}

sub foreach_cmd {
   my $self  = shift;
   my $var   = shift;
   my $list  = shift;
   my $block = shift;

   my $new_var = {var => "_"};
   unshift @{ $block->{block} }, {assign => [$var, $new_var]};

   {foreach_cmd => [$new_var, $list, $block]}
}

42
