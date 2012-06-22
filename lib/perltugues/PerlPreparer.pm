package perltugues::PerlPreparer;

use base perltugues::Preparer;
use Data::Printer;

sub foreach_cmd {
   my $self    = shift;
   my $foreach = shift;

   my $var   = $foreach->{foreach_cmd}->[0];
   my $list  = $foreach->{foreach_cmd}->[1];
   my $block = $foreach->{foreach_cmd}->[2];

   my $new_var = {var => "_"};
   unshift @{ $block->{block} }, {assign => [$var, $new_var]};

   my $ret = {foreach_cmd => [$new_var, $list, $block]};
   $ret
}

42
