package perltugues::PerlWriter;

use base "perltugues::Writer";

sub begin {
   my $self = shift;
   my @ret = (<<'END');
#!/usr/bin/perl

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

sub get_code_for {
   my $self = shift;
   my $meth = shift;

   $self->ident . $self->$meth(@_)
}

sub declair {
   my $self    = shift;
   my $type    = shift;
   my $varname = shift;

   (my $ns_type = $self->{ns_types}) =~ s/\*/$type/g;

   "my \$$varname = $ns_type->new;"
}

sub function_call {
}

sub write_includes {
   my $self = shift;
   $self->{includes} = [@_];
}

42
