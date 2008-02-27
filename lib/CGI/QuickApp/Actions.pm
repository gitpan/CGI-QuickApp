package CGI::QuickApp::Actions;
use strict;
use warnings;
require Exporter;
use vars qw($actions $DefaultClass @EXPORT  @ISA $defaultconfig);
@CGI::QuickApp::Actions::EXPORT = qw(loadActions saveActions $actions);
use CGI::QuickApp::Config;
@CGI::QuickApp::Actions::ISA     = qw( Exporter CGI::QuickApp::Config);
$CGI::QuickApp::Actions::VERSION = '0.27';
$DefaultClass                    = 'CGI::QuickApp::Actions' unless defined $CGI::QuickApp::Actions::DefaultClass;
$defaultconfig                   = '%CONFIG%';

=head1 NAME

CGI::QuickApp::Actions

=head1 SYNOPSIS

        use vars qw($actions);

        *actions = \$CGI::QuickApp::Actions::actions;

        $actions = {

                welcome => {

                        sub => 'main',

                        file => 'content.pl',

                        title => 'Welcome',

                        whatever => 'storeyour own Stuff'

                        },
        };
        saveActions(); # stored into %CONFIG%

actions

=head1 DESCRIPTION

Actions for CGI::QuickApp.

=head2 EXPORT

loadActions() saveActions() $actions

=head1 Public

=head2 new

=cut

sub new {
        my ($class, @initializer) = @_;
        my $self = {};
        bless $self, ref $class || $class || $DefaultClass;
        return $self;
}

=head2 loadActions

=cut

sub loadActions {
        my ($self, @p) = getSelf(@_);
        my $do = (defined $p[0]) ? $p[0] : $defaultconfig;
        if(-e $do) {
                do $do;
        }
}

=head2 saveActions

=cut

sub saveActions {
        my ($self, @p) = getSelf(@_);
        $self->SUPER::saveConfig(@p, $actions, 'actions');
}

=head1 Private

=head2 getSelf

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'CGI::QuickApp::Actions');
        return (defined($_[0]) && (ref($_[0]) eq 'CGI::QuickApp::Actions' || UNIVERSAL::isa($_[0], 'CGI::QuickApp::Actions'))) ? @_ : ($CGI::QuickApp::Actions::DefaultClass->new, @_);
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
