my $i = perltugues::Tipo::inteiro->new; my $j = perltugues::Tipo::inteiro->new; $j->vale(5); ; foreach my $_ (1, 2, $j) { $i->vale($_); print $i; };
