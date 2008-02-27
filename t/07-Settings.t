use strict;
use CGI::QuickApp::Settings;
use vars qw($settings);
*settings = \$CGI::QuickApp::Settings::settings;
$settings = {config => "???config.pl",};
saveSettings("./config.pl");
loadSettings("./config.pl");
my $t1 = $settings->{config};
$settings->{config} = "./config.pl";
saveSettings('./config.pl');
loadSettings('./config.pl');
my $t2 = $settings->{config};
use Test::More tests => 2;
ok($t1 eq "???config.pl");
ok($t2 eq "./config.pl");
unlink('./config.pl');
unlink('%CONFIG%');
1;
