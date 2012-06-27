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
      
      code: cmd_or_blk(s?) | /;+/
      { $return = $item[1] }

      cmd_or_blk: command(s? /;/) | block(s?)
      
      command:      declaration | const | iteration | conditional | incr_decr | eq_math | assign | block | cmd_op | function | imprima | list | var
      cmd_not_op:   declaration | const | iteration | conditional | incr_decr | eq_math | assign | block |          function | imprima |        var
      cmd_not_list: declaration | const | iteration | conditional | incr_decr | eq_math | assign | block | cmd_op | function | imprima |        var

      return_value: const | incr_decr | eq_math | assign | cmd_op | list | var
      
      type: word

      declaration: type ":" word(s /,/)
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
      {$return = {function_call => [$item[1], $item[3]] } }
      {$return = undef unless grep {$item[1] eq $_} @code_functions }

      begin_end_block: 'begin' (':')(?) code (/;+/)(s?) 'end'
      { $return = {block => $item[3]->[0]} }

      curly_block: '{' code (/;+/)(s?) '}'
      { $return = {block => $item[2]->[0]} }

      block: begin_end_block | curly_block

      #condition: declaration | const | assign | cmd_op | function | var
      condition: return_value
      { $return = { condition => $item[1] } }

      conditional: if_cmd | unless_cmd

      if_cmd:     'se' '(' condition ')' block
      { $return = {if_cmd => [@item[3, 5]]} }

      nao: 'nao' | 'não' | 'n' | 'ñ'
      que: 'que' | 'q'

      unless_names: 'a' nao 'ser' que

      unless_cmd: unless_names '(' condition ')' block
      { $return = {unless_cmd => [@item[3, 5]]} }

      iteration: for_cmd | foreach_cmd | while_cmd | until_cmd

      for_cmd: 'para' '(' command(s? /,/) ';' condition(?) ';' command(s? /,/) ')' block
      { $return = {for_cmd => [@item[3, 5, 7, 9]]} }

      foreach_cmd: ('para cada' | 'para_cada' | 'paraCada') var '(' list ')' block
      { $return = {foreach_cmd => [@item[2, 4, 6]]} }

      while_cmd: 'enquanto' '(' condition(?) ')' block
      { $return = {while_cmd => [@item[3, 5]]} }

      ate: 'ate' | 'ateh'

      until_name: ate que

      until_cmd: 'enquanto' '(' condition(?) ')' block
      { $return = {until_cmd => [@item[3, 5]]} }

      add:          '+'
      {$item[0]}
      subtract:     '-'
      {$item[0]}
      multiply:     '*'
      {$item[0]}
      divide:       '/'
      {$item[0]}

      equal:        '=='
      {$item[0]}
      not_equal:    '!='
      {$item[0]}
      grater_than:  '>'
      {$item[0]}
      less_than:    '<'
      {$item[0]}
      grater_or_eq: '>='
      {$item[0]}
      less_or_eq: '<='
      {$item[0]}
      
      op_math: add | subtract | multiply | divide

      op_bin: op_math | grater_than | less_than | grater_or_eq | less_or_eq | equal | not_equal

      plus_eq_math: var '+=' command
      { $return = {assign => [$item[1], {add => [$item[1], $item[3]]}]} }
      
      minus_eq_math: var '-=' command
      { $return = {assign => [$item[1], {add => [$item[1], $item[3]]}]} }
      
      star_eq_math: var '*=' command
      { $return = {assign => [$item[1], {add => [$item[1], $item[3]]}]} }
      
      slash_eq_math: var '/=' command
      { $return = {assign => [$item[1], {add => [$item[1], $item[3]]}]} }

      eq_math: plus_eq_math | minus_eq_math | star_eq_math | slash_eq_math

      pre_incr: '++' var
      { $return = {pre_incr => $item[2]} }
      pos_incr: var '++'
      { $return = {pos_incr => $item[2]} }
      incr: pre_incr | pre_incr
      
      pre_decr: '--' var
      { $return = {pre_decr => $item[2]} }
      pos_decr: var '--'
      { $return = {pos_decr => $item[2]} }
      decr: pre_decr | pre_decr

      incr_decr: incr | decr
      
      cmd_op: cmd_not_op op_bin command
      { $return = {$item[2] => [$item[1], $item[3]]} }
   
      imprima: 'imprima(' return_value ')'
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

      ate: 'ate' | 'até' | 'ateh'

      a_cada: 'a cada' return_value
      { $return = $item[2] }

      num_list: 'de' return_value ate return_value a_cada(?)
      { $return = {list_interval => [@item[2, 4, 6]]} }

      list: num_list | list_comma
   
END
}

42
