package perltugues::PerlWriter;
use utf8;
use Data::Printer;

use base "perltugues::Writer";

sub begin {
   my $self = shift;
   my $rand = int rand 10000;
   my $time = time;
   my @ret  = (<<"END");
#!/usr/bin/perl

use utf8;
use strict;
use warnings;

\$SIG{__DIE__} = sub{ warn "ERRO!!!\$/"};

package perltugues::AreaSegura::Das${time}::Numero${rand};

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

   "my \$$varname = $ns_type->new"
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

sub const_str {
   my $self = shift;
   my $val  = shift;

   qq{"$val"}
}

sub assign {
   my $self = shift;
   my $var  = shift;
   my $data = shift;

   "${var}->vale($data)"
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

sub write_includes {
   my $self = shift;
   $self->{includes} = [@_];
}

42
