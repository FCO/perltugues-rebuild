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
      code: cmd_or_blk(s?) (';')(s?)
      {$return = $item[1]}

      cmd_or_blk: command(s? /;/) | block(s?)
      
      command:      declaration | const | iteration | assign | block | cmd_op | function | imprima | list | var
      cmd_not_op:   declaration | const | iteration | assign | block |          function | imprima |        var
      cmd_not_list: declaration | const | iteration | assign | block | cmd_op | function | imprima |        var
      
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

      const_real: /\d+,\d+/
      {$return = {const_real => $item[1]}}
      
      const: const_real | const_int | const_str | const_char
      
      var: word
      {$return = {var => $item[1]}}
      {$return = undef unless grep {$item[1] eq $_} @code_vars }
      
      assign:  var<commit> '=' command
      {$return = {assign => [$item[1], $item[4]]}}
      
      function: word '(' command(s? /,/) ')'
      {$return = {function_call => [$item{word}, $item[-2]] } }
      {$return = undef unless grep {$item[1] eq $_} @code_functions }
      
      block: '{' cmd_or_blk(s?) '}'
      { $return = {block => $item[2]->[0]} }

      condition: declaration | const | assign | cmd_op | function | var

      iteration: for_cmd | foreach_cmd

      for_cmd: 'para' '(' command(s? /,/) ';' condition(?) ';' command(s? /,/) ')' block
      { $return = {for_cmd => [@item[3, 5, 7, 9]]} }

      foreach_cmd: ('para cada' | 'para_cada' | 'paraCada') var '(' list ')' block
      { $return = {foreach_cmd => [@item[2, 4, 6]]} }

      add:          '+'
      {$item[0]}
      subtract:     '-'
      {$item[0]}
      multiply:     '*'
      {$item[0]}
      divide:       '/'
      {$item[0]}

      grater_than:  '>'
      {$item[0]}
      less_than:    '<'
      {$item[0]}
      grater_or_eq: '>='
      {$item[0]}
      less_or_eq: '<='
      {$item[0]}
      equal:        '=='
      {$item[0]}
      not_equal:    '!='
      {$item[0]}
      
      op_bin: add | subtract | multiply | divide | grater_than | less_than | grater_or_eq | less_or_eq | equal | not_equal
      
      cmd_op: cmd_not_op op_bin command
      { $return = {$item[2] => [$item[1], $item[3]]} }
   
      imprima: 'imprima(' command ')'
      { $return = {imprima => $item[2]} }

      list_comma: <leftop: cmd_not_list ',' command>
      {
         sub get_list_comma_item {
            my $tree = shift;
            if(ref $tree eq "ARRAY") {
               return map{get_list_comma_item($_)} @$tree;
            } elsif(ref $tree eq "HASH") {
               if(exists $tree->{list_comma}) {
                  return get_list_comma_item($tree->{list_comma});
               }
            }
            $tree
         }
         $return = {list_comma => [get_list_comma_item($item[1])]} 
      }

      num_list: cmd_not_list '..' cmd_not_list

      list: list_comma | num_list
   
END
}

42
