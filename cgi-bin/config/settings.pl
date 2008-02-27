$VAR1 = {
          'admin' => {
                       'firstname' => 'Dirk',
                       'email' => 'lze@cpan.org',
                       'street' => 'example 33',
                       'name' => 'Lindner',
                       'town' => 'Berlin'
                     },
          'actions' => '/config/actions.pl',
          'defaultAction' => 'gohome',
          'language' => 'en',
          'version' => '0.27',
          'cgi' => {
                     'bin' => undef,
                     'style' => 'Crystal',
                     'serverName' => 'cd \'/data/sf/lindnerei/lze/cgi-bin/Sidebar\'',
                     'cookiePath' => '/',
                     'title' => 'CGI::QuickApp',
                     'DocumentRoot' => undef,
                     'alias' => 'cd \'/data/sf/lindnerei\'',
                     'expires' => '+1y'
                   },
          'uploads' => {
                         'maxlength' => 2003153,
                         'path' => '/downloads/',
                         'chmod' => 420,
                         'enabled' => 1
                       },
          'translate' => '/config/translate.pl',
          'session' => '/config/session.pl',
          'config' => '/config/settings.pl',
          'scriptAlias' => 'cd \'/data/sf/lindnerei\''
        };
$settings =$VAR1;