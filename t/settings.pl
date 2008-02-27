$VAR1 = {
         'admin'   => {'firstname' => 'Dirk', 'email' => 'lze@cpan.org', 'street' => 'example 33', 'name' => 'Lindner', 'town' => 'Berlin'},
         'actions' => 'cgi-bin/config/actions.pl',
         'tree'          => {'navigation' => 'cgi-bin/config/tree.pl', 'links' => 'cgi-bin/config/links.pl'},
         'defaultAction' => 'news',
         'language'      => 'en',
         'version'       => '0.23',
         'cgi' =>
           {'bin' => 'cgi-bin', 'style' => 'Crystal', 'serverName' => 'http://lindnerei.sourceforge.net/', 'cookiePath' => '/', 'title' => 'CGI::QuickApp', 'mod_rewrite' => 0, 'alias' => 'cgi-bin', 'DocumentRoot' => 'htdocs', 'expires' => '+1y'},
         'uploads'     => {'maxlength' => 2003153, 'path' => 'htdocs/downloads/', 'chmod' => 420, 'enabled' => 1},
         'translate'   => 'cgi-bin/config/translate.pl',
         'session'     => 'cgi-bin/config/session.pl',
         'config'      => 'cgi-bin/config/settings.pl',
         'scriptAlias' => 'cgi-bin'
};
$settings = $VAR1;
