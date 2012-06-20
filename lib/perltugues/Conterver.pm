package perltugues::Converter;
use perltugues::Parser;
use perltugues::PerlWriter;

sub new {
   my $class = shift;
   my $data = {
      parser   => perltugues::Parser->new,
      writer   => perltugues::PerlWriter->new(ns_types => "perltugues::Type::*"),
   };
   bless $data, $class;
}

sub convert {
   my $self = shift;
   my $code = shift;
   my $tree = perltugues::Parser->new->parse($code);
   my @new_code;
   for my $cmd(@$tree) {
      push @new_code, $self->convert_command($cmd);
   }
   join "", @new_code
}

sub convert_command {
   my $self = shift;
   my $tree = shift;

   if(ref $tree eq "ARRAY"){
      return @$tree;
   } elsif(ref $tree eq "HASH") {
      for my $cmd(keys %$tree) {
         my @pars = $self->convert_command($tree->{$cmd});
         return $self->{writer}->get_code_for($cmd, @pars), $/;
      }
   }
}

42
