package perltugues::Parser;

use Parse::RecDescent;
use Data::Dumper;

#$::RD_ERRORS       = 1;
#$::RD_WARN         = 1;
#$::RD_HINT         = 1;
#$::RD_TRACE        = 1;
#$::RD_AUTOSTUB     = 1;
#$::RD_AUTOACTION   = 1;

sub new {
   my $class = shift;
   bless {parser => Parse::RecDescent->new($self->get_rule)}, $class;
}

sub parse {
   my $self = shift;
   my @ret;
   my $code = $self->{parser}->code(shift @ARGV);
   while(my $act = shift @{ $code }) {
      push @ret, ref $act eq "ARRAY" ? @$act : $act;
   }
   
   print Dumper \@ret;
}

sub get_rule {
   return << 'END'
      {
         my @code_functions = (qw/bla/);
         my @code_vars      = ();
      }
      
      word: /\w+/
      {$return = $item[-1]}
      
      code: command(s /\s*;\s*/)
      {$return = $item[-1]}
      
      command: assign | cmd_not_assign
      cmd_not_assign: cmd_op | const | declaration | function | var
      cmd_not_op: assign | const | declaration | function | var
      
      declaration: word ":" word(s /\s*,\s*/)
      {
         push @code_vars, @{ $item{"word(s)"} };
         $return = [ map { {declair => [$item{word}, $_] } } @{ $item{"word(s)"} } ]
      }
      
      const_char: "'" /[^']|\\./ "'"
      {$return = $item{quote} . $item[2] . $item{quote} }
      
      q_const_str: '"' /[^"]*/ '"'
      {$return = $item{quote} . $item[2] . $item{quote} }
      
      const_str: q_const_str | const_char
      
      const: /\d+/ | const_str
      
      var: word
      {$return = $item[-1]}
      {$return = undef unless grep {$item[-1] eq $_} @code_vars }
      
      assign:  var<commit> '=' cmd_not_assign
      {$return = {assign => [$item{var}, $item[-1]]}}
      
      function: word '(' command(s? /\s*,\s*/) ')'
      {$return = {function_call => [$item{word}, $item[-2]] } }
      {$return = undef unless grep {$item[1] eq $_} @code_functions }
      
      block: '{' code '}'
      
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
   
   
END
}

42
