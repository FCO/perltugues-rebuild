package perltugues::Converter;
use utf8;
use perltugues::Parser;
use perltugues::PerlWriter;
use Data::Dumper ();

sub new {
   my $class = shift;
   my $ns_types = "perltugues::Tipo::*";
   my $data = {
      parser       => perltugues::Parser->new,
      writer       => perltugues::PerlWriter->new(ns_types => $ns_types),
      ns_types     => $ns_types,
      types        => {},
      DEBUG_PARSER => 0,
      dumper       => sub{print Data::Dumper::Dumper @_},
   };
   my $self = bless $data, $class;
   $self->{dumper} = sub{Data::Printer::p(@_)} if eval "require Data::Printer";
   $self->parser->converter($self);
   $self
}

sub debug_parser {shift->{DEBUG_PARSER} = 1};
sub parser       {shift->{parser}}
sub writer       {shift->{writer}}

sub add_type {
   my $self = shift;
   my $type = shift;

   (my $ns_type = $self->{ns_types}) =~ s/\*/$type/g;

   $self->{types}->{$ns_type}++
}

sub convert {
   my $self = shift;
   my $code = shift;
   my $tree = $self->parser->parse($code);
   $self->{dumper}->($tree) if $self->{DEBUG_PARSER};
   $self->writer->write_includes(keys %{ $self->{types} });
   my @new_code = $self->writer->begin;
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
