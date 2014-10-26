package CGI::QuickApp::Config;
use strict;
use warnings;
require Exporter;
use vars qw($config $DefaultClass @EXPORT  @ISA $defaultconfig);
@CGI::QuickApp::Config::EXPORT  = qw(loadConfig saveConfig $config);
@ISA                            = qw(Exporter);
$CGI::QuickApp::Config::VERSION = '0.27';
$DefaultClass                   = 'CGI::QuickApp::Config' unless defined $CGI::QuickApp::Config::DefaultClass;
$defaultconfig                  = '%CONFIG%';

=head1 NAME

CGI::QuickApp::Config

=head1 DESCRIPTION

Config for CGI::QuickApp.

use this for whatever you want to store.


=head2 EXPORT

loadConfig() saveConfig() $config

=head1 Public

=head2 new()

=cut

sub new {
        my ($class, @initializer) = @_;
        my $self = {};
        bless $self, ref $class || $class || $DefaultClass;
        return $self;
}

=head2 loadConfig()

=cut

sub loadConfig {
        my ($self, @p) = getSelf(@_);
        my $do = (defined $p[0]) ? $p[0] : $defaultconfig;
        if(-e $do) {
                do $do;
        }
}

=head2 saveConfig()

=cut

sub saveConfig {
        my ($self, @p) = getSelf(@_);
        my $saveAs = defined $p[0] ? $p[0] : $defaultconfig;
        $config = defined $p[1] ? $p[1] : $config;
        my $var = defined $p[2] ? $p[2] : 'config';
        use Data::Dumper;
        my $content = Dumper($config);
        $content .= "\$$var =\$VAR1;";
        use Fcntl qw(:flock);
        use Symbol;
        my $fh = gensym();
        my $rsas = $saveAs =~ /^(\S+)$/ ? $1 : 0;

        if($rsas) {
                open $fh, ">$rsas.bak" or warn "$/CGI::QuickApp::Config::saveConfig$/ $! $/ File: $rsas $/Caller: " . caller() . $/;
                flock $fh, 2;
                seek $fh, 0, 0;
                truncate $fh, 0;
                print $fh $content;
                close $fh;
        }
        if(-e "$rsas.bak") {
                rename "$rsas.bak", $rsas or warn "$/CGI::QuickApp::Config::saveConfig$/ $! $/ File: $rsas $/Caller: " . caller() . $/;
                do $rsas;
        }
}

=head1 Private

=head2 getSelf()

see L<HTML::Menu::TreeView>

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'CGI::QuickApp::Config');
        return (defined($_[0]) && (ref($_[0]) eq 'CGI::QuickApp::Config' || UNIVERSAL::isa($_[0], 'CGI::QuickApp::Config'))) ? @_ : ($CGI::QuickApp::Config::DefaultClass->new, @_);
}

=head2 see Also

L<CGI> L<CGI::QuickApp> L<CGI::QuickApp::Actions> L<CGI::QuickApp::Translate> L<CGI::QuickApp::Settings> L<CGI::QuickApp::Config>

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
