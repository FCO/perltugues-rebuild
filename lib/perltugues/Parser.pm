package perltugues::Parser;

use utf8;
use Parse::RecDescent;
use Data::Dumper;

$::RD_ERRORS       = 1;
$::RD_WARN         = 1;
$::RD_HINT         = 1;
#$::RD_AUTOSTUB     = 1;
#$::RD_AUTOACTION   = 1;

sub new {
   my $class = shift;
   $self = bless {}, $class;
   $self->{parser} = Parse::RecDescent->new($self->get_rule);
   $self
}

sub debug_trace {
   $::RD_TRACE        = 1;
}

sub parse {
   my $self = shift;
   my $code = shift;
   my @ret;
   my $tree = $self->{parser}->code($code);
   while(my $act = shift @{ $tree }) {
      push @ret, ref $act eq "ARRAY" ? @$act : $act;
   }
   
   [@ret];
}

sub converter {
   my $self = shift;
   if(@_) {
      $self->{parser}->{converter} = shift;
      return $self
   }
   $self->{parser}->{converter}
}

sub rule_header {
   my $self = shift;

   return << 'END'
      {
         my @code_functions = (qw/bla/);
         my @code_vars      = ();
      }
END
}

sub get_rule {
   my $self = shift;

   return $self->rule_header . << 'END'
      word: /[\p{L}\p{M}\p{N}]+/
      {$return = $item[-1]}
      
      #code: command(s)
      code: cmd_or_blk(s)
      {$return = $item[-1]}

      cmd_or_blk: command(s? /;/) | block(s?)
      
      command:    iteration | assign | block | cmd_op | const | declaration | function | imprima | var
      cmd_not_op: iteration | assign | block | const | declaration | function | imprima | var
      
      declaration: word ":" word(s /,/)
      {
         $thisparser->{converter}->add_type($item[1]) if $thisparser->{converter} and $thisparser->{converter}->can("add_type");
         push @code_vars, @{ $item{"word(s)"} };
         $return = [ map { {declair => [$item[1], $_] } } @{ $item[3] } ]
      }
      
      const_char: "'" /[^']|\\./ "'"
      {$return = {const_char => $item[2]} }
      
      const_str: '"' /[^"]*/ '"'
      {$return = {const_str => $item[2]} }
      
      const_int: /\d+/
      {$return = {const_int => $item[1]}}

      const_real: /\d*[\.]\d+/
      {$return = {const_real => $item[1]}}
      
      const: const_real | const_int | const_str | const_char
      {print "const$/";}
      
      var: word
      {$return = {var => $item[1]}}
      {$return = undef unless grep {$item[1] eq $_} @code_vars }
      
      assign:  var<commit> '=' command
      {$return = {assign => [$item[1], $item[4]]}}
      
      function: word '(' command(s? /,/) ')'
      {$return = {function_call => [$item{word}, $item[-2]] } }
      {$return = undef unless grep {$item[1] eq $_} @code_functions }
      
      block: '{' code(?) '}'
      { $return = {block => $item[2]->[0]} }
      {print "block$/"}

      iteration: for_cmd | foreach_cmd

      for_cmd: 'para' '(' command(s? /,/) ';' command(s? /,/) ';' command(s? /,/) ')' block
      { $return = {for_cmd => [@item[3, 5, 7, 9]]} }
      { print "FOR$/" }

      foreach_cmd: 'para_cada' var '(' command(s /,/) ')' block
      { $return = {foreach_cmd => [@item[2, 4, 6]]} }
      { print "FOREACH$/" }


      
      add: '+'
      {$item[0]}
      subtract: '-'
      {$item[0]}
      multiply: '*'
      {$item[0]}
      divide: '/'
      {$item[0]}
      
      op: add | subtract | multiply | divide
      
      cmd_op: cmd_not_op op command
      { $return = {$item[2] => [$item[1], $item[3]]} }
   
      imprima: 'imprima(' command ')'
      { $return = {imprima => $item[2]} }
   
END
}

42
