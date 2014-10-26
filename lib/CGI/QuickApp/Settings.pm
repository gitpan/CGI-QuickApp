package CGI::QuickApp::Settings;
use strict;
use warnings;
require Exporter;
use vars qw($settings $DefaultClass @EXPORT  @ISA $defaultconfig);
@CGI::QuickApp::Settings::EXPORT = qw(loadSettings saveSettings $settings);
use CGI::QuickApp::Config;
@ISA                              = qw(Exporter CGI::QuickApp::Config);
$CGI::QuickApp::Settings::VERSION = '0.27';
$DefaultClass                     = 'CGI::QuickApp::Settings' unless defined $CGI::QuickApp::Settings::DefaultClass;
$defaultconfig                    = '%CONFIG%';

=head1 NAME

CGI::QuickApp::Settings

=head1 SYNOPSIS

        use CGI::QuickApp::Settings;

        use vars qw($settings);

        *settings = \$CGI::QuickApp::Settings::settings;

        loadSettings('./config.pl');

        print $settings->{key};

        $settings->{key} = 'value';

        saveSettings("./config.pl");


=head1 DESCRIPTION

settings for CGI::QuickApp.

=head2 EXPORT

loadSettings() saveSettings() $settings

=head1 Public

=head2 new()

=cut

sub new {
        my ($class, @initializer) = @_;
        my $self = {};
        bless $self, ref $class || $class || $DefaultClass;
        return $self;
}

=head2 loadSettings()

=cut

sub loadSettings {
        my ($self, @p) = getSelf(@_);
        my $do = (defined $p[0]) ? $p[0] : $defaultconfig;
        if(-e $do) {
                do $do;
        }
}

=head2 saveSettings()

=cut

sub saveSettings {
        my ($self, @p) = getSelf(@_);
        my $l = defined $p[0] ? $p[0] : $defaultconfig;
        $self->SUPER::saveConfig($l, $settings, 'settings');
}

=head1 Private

=head2 getSelf()

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'CGI::QuickApp::Settings');
        return (defined($_[0]) && (ref($_[0]) eq 'CGI::QuickApp::Settings' || UNIVERSAL::isa($_[0], 'CGI::QuickApp::Settings'))) ? @_ : ($CGI::QuickApp::Settings::DefaultClass->new, @_);
}

=head2 see Also

L<CGI> L<CGI::QuickApp::Actions> L<CGI::QuickApp::Translate> L<CGI::QuickApp::Settings> L<CGI::QuickApp::Config>

=head1 AUTHOR

Dirk Lindner <lze@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005-2008 by Hr. Dirk Lindner

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public License
as published by the Free Software Foundation; 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

=cut

1;
