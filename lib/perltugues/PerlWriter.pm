package perltugues::PerlWriter;
use utf8;

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

sub get_code_for {
   my $self = shift;
   my $meth = shift;

   my $ret = $self->ident . $self->$meth(@_);
   $ret
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

sub imprima {
   my $self = shift;
   my $par  = shift;

   "print $par";
}

sub write_includes {
   my $self = shift;
   $self->{includes} = [@_];
}

42
