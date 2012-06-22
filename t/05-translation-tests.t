#!perl -T

my @tests;
BEGIN{
@tests = <t/tests/*.pt>;

require Test::More;
Test::More->import(tests => @tests + 2);
use_ok("perltugues::Converter");
}
ok(my $obj = perltugues::Converter->new, "perltugues::Converter object created");
$obj->writer->begin(sub{});

diag( "Testing perltugues $perltugues::VERSION, Perl $], $^X" );

for my $test(@tests) {
   (my $wanted = $test) =~ s/\.pt$/.pl/;
   diag( "comparing $test´s response with '$wanted'..." );

   open my $CODE, "<", $test;
   my $perltugues_code = join "", <$CODE>;

   open my $WANT, "<", $wanted;
   my $wanted_response = join "", <$WANT>;

   is(unident($obj->convert($perltugues_code)), unident($wanted_response), "testing '$test'");
}



sub unident {
   my $code = shift;
   (my $ret = $code) =~ s/\s+/ /gsm;
   $ret
}

