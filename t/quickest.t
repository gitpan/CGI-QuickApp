use Test::More qw(no_plan);
BEGIN{ use_ok('CGI::QuickApp') }

system("
cd t/quickest;
perl -I../../lib -MCGI::QuickApp::Create SuperQuickWebApp.pm --force-create
ls;
");

ok(-d 't/quickest');
ok(-d 't/quickest/mylib');
ok(-T 't/quickest/mylib/SuperQuickWebApp/mode1.pm');
ok(-T 't/quickest/mylib/SuperQuickWebApp/mode2.pm');
ok(-T 't/quickest/mylib/SuperQuickWebApp/mode3.pm');
ok(-T 't/quickest/mylib/SuperQuickWebApp/mode4.pm');

ok(-d 't/quickest/template');
ok(-T 't/quickest/template/mode1');
ok(-T 't/quickest/template/mode2');
ok(-T 't/quickest/template/mode3');
ok(-T 't/quickest/template/mode4');
