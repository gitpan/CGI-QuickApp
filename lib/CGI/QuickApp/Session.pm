package CGI::QuickApp::Session;
use strict;
use warnings;
require Exporter;
use vars qw( $session $DefaultClass @EXPORT  @ISA $defaultconfig);
@CGI::QuickApp::Session::EXPORT = qw(loadSession saveSession $session);
use CGI::QuickApp::Config;
@CGI::QuickApp::Session::ISA     = qw(Exporter CGI::QuickApp::Config);
$CGI::QuickApp::Session::VERSION = '0.27';
$DefaultClass                    = 'CGI::QuickApp::Session' unless defined $CGI::QuickApp::Session::DefaultClass;
$defaultconfig                   = '%CONFIG%';

=head1 NAME

CGI::QuickApp::Session

=head1 SYNOPSIS


=head1 DESCRIPTION

session for CGI::QuickApp.

=head2 EXPORT

loadConfig() saveSession() $session

=head1 Public

=head2 new

=cut

sub new {
        my ($class, @initializer) = @_;
        my $self = {};
        bless $self, ref $class || $class || $DefaultClass;
        return $self;
}

=head2 loadConfig

=cut

sub loadSession {
        my ($self, @p) = getSelf(@_);
        my $do = (defined $p[0]) ? $p[0] : $defaultconfig;
        if(-e $do) {
                do $do;
        }
}

=head2 saveSession

=cut

sub saveSession {
        my ($self, @p) = getSelf(@_);
        my $l = defined $p[0] ? $p[0] : $defaultconfig;
        $self->SUPER::saveConfig($l, $session, 'session');
}

=head1 Private

=head2 getSelf

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'CGI::QuickApp::Session');
        return (defined($_[0]) && (ref($_[0]) eq 'CGI::QuickApp::Session' || UNIVERSAL::isa($_[0], 'CGI::QuickApp::Session'))) ? @_ : ($CGI::QuickApp::Session::DefaultClass->new, @_);
}

1;
