use Test::More tests => 30;
use URI;
use strict;

my $u;

$u = URI->new('geo:');
$u->altitude(3);

ok(!$u->is_valid, "altitude only is invalid");

$u->latlng(1,2);

is $u, "geo:1,2,3", "not confused by setting altitude before latlng";
is $u->latlng, 2, "latlng returns two coordinates";
is $u->altitude, 3, "setting latlng does not alter altitude";
is $u->crs, "wgs84", "crs default value is 'wgs84'";
ok($u->is_valid, "geo:1,2,3 is valid");

$u = URI->new('geo:-11.1,-22.2,-33.3');
is [$u->latlng]->[0], -11.1;
is [$u->latlng]->[1], -22.2;
is $u->altitude, -33.3;

$u->crs("wgs84");
is $u, "geo:-11.1,-22.2,-33.3;crs=wgs84", "crs can be made explicit";

$u->crs("xxx");
is $u, "geo:-11.1,-22.2,-33.3;crs=xxx";

ok((not defined $u->uncertainty), "uncertainty has no default value");

$u->uncertainty(44);
is $u->uncertainty, 44;
is $u, "geo:-11.1,-22.2,-33.3;crs=xxx;u=44";

$u = URI->new('geo:1,2,3;u=');

is $u->uncertainty, "", "uncertainty with empty string as value";
$u->uncertainty(undef);
ok((not defined $u->uncertainty), "passing undef unsets uncertainty");
is $u, "geo:1,2,3";

$u = URI->new('geo:1,2,3;crs=xxx');
is $u->crs, "xxx";
$u->crs(undef);
is $u, "geo:1,2,3", "passing undef removes crs parameter";

$u->altitude(undef);
is $u, "geo:1,2", "passing undef removes altitude";

ok($u->is_valid, "geo:1,2 is valid");

$u = URI->new('geo:');
$u->latlng(13.4125, 103.8667);
ok($u->is_valid, "code in synopsis is valid");

$u = URI->new('geo:1,2,3;crs=');
is $u->crs, "", "crs with empty string as value";
ok(!$u->is_valid, "crs with empty string as value is invalid");

$u = URI->new('geo:1,2');
$u->latlng(undef);
is $u, "geo:", "passing undef removes latlng";

$u = URI->new('geo:1,2');
$u->parameters(a => 1, b => undef);
is $u, "geo:1,2;a=1;b", "parameter construction";

$u->parameters(a => 1, a => 2);
is $u, "geo:1,2;a=1;a=2", "repeated parameters";
is_deeply [$u->parameters], [a => 1, a => 2];

$u->parameters(undef);
is $u, "geo:1,2", "parameter removal";
is_deeply [$u->parameters], [];

