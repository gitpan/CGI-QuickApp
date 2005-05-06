use inc::Module::Install;


name            ('CGI-QuickApp');
abstract        ('Prototyping reusable web-apps very quickly');
author          ('Yung-chung Lin <xern@cpan.org>');
version_from    ('VERSION');
license         ('perl');

requires  ('CGI::Application');
requires  ('Template');
build_requires  ('Test::More');
auto_install();

&WriteAll;

