package perltugues::Converter;
use utf8;
use perltugues::Parser;
use perltugues::PerlPreparer;
use perltugues::PerlWriter;
use Data::Dumper ();

sub new {
   my $class = shift;
   my $ns_types = "perltugues::Tipo::*";
   my $data = {
      parser         => perltugues::Parser->new,
      writer         => perltugues::PerlWriter->new(ns_types => $ns_types),
      preparer       => perltugues::PerlPreparer->new,
      ns_types       => $ns_types,
      types          => {},
      DEBUG_PARSER   => 0,
      DEBUG_PREPARER => 0,
      dumper         => sub{print Data::Dumper::Dumper @_},
   };
   my $self = bless $data, $class;
   $self->{dumper} = sub{Data::Printer::p(@_)} if eval "require Data::Printer";
   $self->parser->converter($self);
   $self
}

sub debug_parser       {shift->{DEBUG_PARSER} = 1};
sub debug_preparer     {shift->{DEBUG_PREPARER} = 1};
sub debug_parser_trace {shift->parser->debug_trace};
sub parser             {shift->{parser}}
sub writer             {shift->{writer}}
sub preparer           {shift->{preparer}}
sub dumper             {my $self = shift; $self->{dumper}->(@_)}

sub add_type {
   my $self = shift;
   my $type = shift;

   (my $ns_type = $self->{ns_types}) =~ s/\*/$type/g;

   $self->{types}->{$ns_type}++
}

sub prepare {
   my $self = shift;
   my $tree = shift;

   if(ref $tree eq "ARRAY"){
      #for my $val(@$tree) {
      #   $val = $self->prepare($val);
      #}
   } elsif(ref $tree eq "HASH") {
      my ($cmd) = keys %$tree;
      $tree = $self->preparer->prepare_command($tree);
      $self->prepare($tree->{$cmd});
   }
   $tree
}

sub convert {
   my $self = shift;
   my $code = shift;
   $code =~ s/\s+/ /gsm;
   $code =~ s/^\s+|\s+$//gsm;
   my $tree = $self->parser->parse($code);
   $self->dumper($tree) if $self->{DEBUG_PARSER};
   $tree = $self->prepare($tree);
   if($self->{DEBUG_PREPARER}) {
      print "-" x 30, $/;
      $self->dumper($tree);
   }
   $self->writer->write_includes(keys %{ $self->{types} });
   my @new_code = $self->writer->begin || ();
   for my $cmd(@$tree) {
      $cmd = $self->prepare($cmd);
      push @new_code, $self->convert_command($cmd);
   }
   join ";$/", @new_code
}

sub convert_command {
   my $self = shift;
   my $tree = shift;

   if(ref $tree eq "ARRAY"){
      #my @ret = map {$self->convert_command($_)} @$tree;
      my @ret;
      for my $val(@$tree) {
         my ($pret) = $self->convert_command($val);
         push @ret, $pret;
      }
      return @ret
   } elsif(ref $tree eq "HASH") {
      my ($cmd) = keys %$tree;
      ($cmd) = keys %$tree;
      my @pars = $self->convert_command($tree->{$cmd});
      return $self->writer->get_code_for($cmd, @pars), $/;
   } else {
      return $tree
   }
}

42
