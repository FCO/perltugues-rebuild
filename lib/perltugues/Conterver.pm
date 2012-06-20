package perltugues::Converter;
use perltugues::Parser;
use perltugues::PerlWriter;

sub new {
   my $class = shift;
   my $ns_types = "perltugues::Tipo::*";
   my $data = {
      parser   => perltugues::Parser->new,
      writer   => perltugues::PerlWriter->new(ns_types => $ns_types),
      ns_types => $ns_types,
      types    => {},
   };
   my $self = bless $data, $class;
   $self->{parser}->converter($self);
   $self
}

sub add_type {
   my $self = shift;
   my $type = shift;

   (my $ns_type = $self->{ns_types}) =~ s/\*/$type/g;

   $self->{types}->{$ns_type}++
}

sub convert {
   my $self = shift;
   my $code = shift;
   my $tree = $self->{parser}->parse($code);
   $self->{writer}->write_includes(keys %{ $self->{types} });
   my @new_code = $self->{writer}->begin;
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
