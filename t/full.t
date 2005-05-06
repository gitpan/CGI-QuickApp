use Test::More qw(no_plan);
BEGIN{ use_ok('CGI::QuickApp') }

system("
cd t/full;
perl -I../../lib -MCGI::QuickApp::Create WebApp.pm --force-create
");

ok(-d 't/full');
ok(-d 't/full/mylib');
ok(-T 't/full/mylib/WebApp/mode1.pm');
ok(-T 't/full/mylib/WebApp/mode2.pm');
ok(-T 't/full/mylib/WebApp/Mode3.pm');
ok(-T 't/full/mylib/handler_for_mode4.pm');
ok(-T 't/full/mylib/WebApp/err.pm');

ok(-d 't/full/template');
ok(-T 't/full/template/mode1');
ok(-T 't/full/template/template_name_for_error_mode');
ok(-T 't/full/template/mode3');
ok(-T 't/full/template/mode4');
ok(-T 't/full/template/template_name_for_error_mode');

