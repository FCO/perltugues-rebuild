package perltugues::PerlWriter;
use utf8;
use Data::Printer;

use base "perltugues::Writer";

sub begin {
   my $self = shift;
   my $func = shift;

   if(not defined $func) {
      if(defined $self->{begin_func}) {
         return $self->{begin_func}->();
      } else {
         return $self->default_begin;
      }
   } else {
      $self->{begin_func} = $func;
   }
   return
}

sub default_begin {
   my $self = shift;
   my $rand = int rand 10000;
   my $time = time;
   my @ret  = (<<"END");
#!/usr/bin/perl

use utf8;
use strict;
use warnings;

END
   push @ret, map{"use $_;$/"} @{ $self->{includes} };
   @ret, $/
}

sub ident_incr {
   my $self = shift;
   $self->{ident}++;
   $self
}

sub ident_decr {
   my $self = shift;
   $self->{ident}--;
   $self
}

sub ident {
   my $self = shift;
   if(@_) {
      $self->{ident} = shift;
      return $self
   }
   $self->{indet_unit} x $self->{ident}
}

sub format_code {
   my $self = shift;
   my $code = shift;

   $self->ident . $code
}

sub declair {
   my $self    = shift;
   my $type    = shift;
   my $varname = shift;

   (my $ns_type = $self->{ns_types}) =~ s/\*/$type/g;

   "tie my \$$varname, '$ns_type'"
}

sub function_call {
}

sub var {
   my $self = shift;
   my $name = shift;

   "\$$name"
}

sub const_int {
   my $self = shift;
   my $val  = shift;

   $val
}

sub const_real {
   my $self = shift;
   my $val  = shift;
   $val =~ s/,/./;

   $val
}

sub const_str {
   my $self = shift;
   my $val  = shift;

   qq{"$val"}
}

sub assign {
   my $self = shift;
   my $var  = shift;
   my $data = shift;

   "${var} = $data"
}

sub add {
   my $self = shift;
   my $par1 = shift;
   my $par2 = shift;

   "$par1 + $par2"
}

sub subtract {
   my $self = shift;
   my $par1 = shift;
   my $par2 = shift;

   "$par1 - $par2"
}

sub block {
   my $self = shift;
   my @code = @_;

   $self->ident_incr;

   my $ret = join $/, "{", map({$self->format_code($_) . ";"} @code) , "}"; 

   $self->ident_decr;
   $ret
}

sub for_cmd {
   my $self = shift;
   my($init, $test, $incr, $block) = @_;

   "for($init; $test; $incr) $block"
}

sub foreach_cmd {
   my $self = shift;
   my($var, $list, $block) = @_;

   "foreach my $var (" . join(", ", $list) . ") $block"
}

sub if_cmd {
   my $self = shift;
   my($cond, $block) = @_;

   "if ($cond) $block"
}

sub unless_cmd {
   my $self = shift;
   my($cond, $block) = @_;

   "unless ($cond) $block"
}

sub imprima {
   my $self = shift;
   my $par  = shift;

   "print $par";
}

sub list_comma {
   my $self = shift;
   my @pars = @_;

   join(", ", @pars)
}

sub less_than {
   my $self = shift;
   my $par1 = shift;
   my $par2 = shift;

   "$par1 < $par2"
}

sub less_or_eq {
   my $self = shift;
   my $par1 = shift;
   my $par2 = shift;

   "$par1 <= $par2"
}

sub grater_than {
   my $self = shift;
   my $par1 = shift;
   my $par2 = shift;

   "$par1 > $par2"
}

sub grater_or_eq {
   my $self = shift;
   my $par1 = shift;
   my $par2 = shift;

   "$par1 >= $par2"
}

sub equal {
   my $self = shift;
   my $par1 = shift;
   my $par2 = shift;

   "$par1 == $par2"
}

sub not_equal {
   my $self = shift;
   my $par1 = shift;
   my $par2 = shift;

   "$par1 != $par2"
}

sub pre_incr {
   my $self = shift;
   my $var  = shift;

   "++$var"
}

sub pre_decr {
   my $self = shift;
   my $var  = shift;

   "--$var"
}

sub pos_incr {
   my $self = shift;
   my $var  = shift;

   "$var++"
}

sub pos_decr {
   my $self = shift;
   my $var  = shift;

   "$var--"
}

sub pre_incr {
   my $self = shift;
   my $var  = shift;

   "++$var"
}

sub condition {
   my $self = shift;
   my $cmd  = shift;

   "scalar( $cmd ) != 0"
}

sub write_includes {
   my $self = shift;
   $self->{includes} = [@_];
}

42
