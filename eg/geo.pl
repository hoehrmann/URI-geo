#!perl -w
use URI;

my $u = URI->new('geo:13.4125,103.8667');
print $u->latlng(), "\n";
