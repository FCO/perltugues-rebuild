package perltugues::Parser;

use utf8;
use Parse::RecDescent;
use Data::Dumper;

#$::RD_ERRORS       = 1;
#$::RD_WARN         = 1;
$::RD_HINT         = 1;
#$::RD_TRACE        = 1;
#$::RD_AUTOSTUB     = 1;
#$::RD_AUTOACTION   = 1;

sub new {
   my $class = shift;
   $self = bless {}, $class;
   $self->{parser} = Parse::RecDescent->new($self->get_rule);
   $self
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
      word: /\w+/
      {$return = $item[-1]}
      
      code: command(s /\s*;\s*/)
      {$return = $item[-1]}
      
      command: assign | cmd_not_assign
      cmd_not_assign: cmd_op | const | declaration | function | var
      cmd_not_op: assign | const | declaration | function | var
      
      declaration: word ":" word(s /\s*,\s*/)
      {
         $thisparser->{converter}->add_type($item{word});
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
