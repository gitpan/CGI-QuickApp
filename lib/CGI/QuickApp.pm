package CGI::QuickApp;

use strict;
use base 'CGI::Application';
use CGI::Carp qw(fatalsToBrowser);
use Template;
use Data::Dumper;

### global arguments
our %gargs = (
	      header_props => {
		  -charset => 'utf8',
		  -type => 'text/html',
	      },
	      mode_param => 'm',
	      template_conf => {
		  INCLUDE_PATH => 'template',
	      },
	     );




my $callback_template = <<'CALLBACK';

[% IF prereq %]
require [% prereq %];
[% END %]
sub mode_[% mode %] {
  my $self = shift;
  my %arg = @_;
  [% IF mode %]
  %arg = (%arg,
	  [% IF prereq %]
	  [% prereq %]::handler
	  [% ELSE %]
          [% method %]
	  [% END %]
          (
	   [% IF handler_args %]
	   [% handler_args %]
	   [% ELSE %]
	   # The default arguments
	   scalar($self->query()->Vars)
	   [% END %]
	   )
	  );
  [% END %]
  $self->cgi_output('[% template_file %]', %arg);
}

CALLBACK


sub create_mode_callbacks {
    my $mode = shift;
    my ($type, $callback) = @{shift()};
    my $template = shift;
    my $handler_args = shift;

    my $vars;
    $vars->{prereq}   = $callback if $type eq 'use';
    $vars->{method}   = $callback;
    $vars->{mode}     = $mode;
    $vars->{template_file} = $template;
    $vars->{handler_args} = $handler_args;

    my $output;
    my $tt = Template->new () or die $Template::ERROR;
    $tt->process(\$callback_template, $vars, \$output) || die $tt->error();
    eval $output;
#    print $output;
    die $@ if $@;
}


sub import {
    my $package = shift;
    my ($caller_package) = (caller(0))[0];
    $gargs{caller_package} = $caller_package;

    if(ref($_[0]) eq 'ARRAY'){
	$gargs{run_modes} = shift;
	foreach (@{$gargs{run_modes}}){
	  $gargs{run_mode_handlers}->{$_} = "use $gargs{caller_package}::$_";
	}
    }
    else {
	%gargs = (%gargs, @_);
    }


    foreach my $n (@{$gargs{run_modes}}){
      $gargs{run_mode_handlers}->{$n} = $caller_package.'::'.$n
	if not exists $gargs{run_mode_handlers}->{$n};
      $gargs{templates}->{$n} = $n
	if not exists $gargs{templates}->{$n};
    }

    {
	no strict;

	foreach my $k (keys %{$gargs{run_mode_handlers}}){
	    my $v = $gargs{run_mode_handlers}->{$k};
	    if($v =~ s/^\s*sub\s+//o){
		$gargs{run_mode_handlers}->{$k} =
		    [ 'sub', $gargs{caller_package}.'::'.$v ];
	    }
	    elsif($v =~ s/^\s*(use)?\s+//o){
		$gargs{run_mode_handlers}->{$k} = [ 'use', $v ];
	    }
	    else {
		$gargs{run_mode_handlers}->{$k} = [ 'use', $v ];
	    }
	}
    }


    $gargs{start_mode} = $gargs{run_modes}->[0] if not exists $gargs{start_mode};

    {
      no strict;
      *{$caller_package.'::go'} = \&{'go'};
      
      foreach ( qw(init prerun postrun) ){
	*{__PACKAGE__.'::'."cgiapp_$_"} = *{$caller_package.'::'.$_};
      }
      *{__PACKAGE__.'::teardown'} = *{$caller_package.'::teardown'};
    }

    if($ENV{q(I am gonna create files for your app, ok?)}){
	&CGI::QuickApp::Create::create_files(%gargs);
	exit;
    }
}


sub setup {
    my $self = shift;

    $self->start_mode($gargs{start_mode});


    foreach my $mode (keys %{$gargs{run_mode_handlers}}){
	create_mode_callbacks(
			      $mode,
			      $gargs{run_mode_handlers}->{$mode},
			      $gargs{templates}->{$mode},
			      $gargs{handler_args},
			      );
    }

    $self->run_modes(map{$_=>"mode_$_"} @{$gargs{run_modes}});
    $self->mode_param($gargs{mode_param});
    $self->header_props(%{$gargs{header_props}});
    while(my($k,$v) = each %{$gargs{params}}){
	$self->param($k => $v);
    }
}


sub go { __PACKAGE__->new->run }

sub cgi_output {
    my $self = shift;
    my $template_file = shift;
    my %more_args = @_;
    my $q = $self->query;
    my $output;
    my $tt = Template->new (%{$gargs{template_conf}}) or die $Template::ERROR;
    $tt->process($template_file, \%more_args => \$output) or die $tt->error();
    $output;
}




1;

__END__

=head1 NAME

CGI::QuickApp - Prototyping reusable web-apps very quickly

=head1 SUPER QUICK USAGE

    # In "SuperQuickWebApp.pm" ...
    package SuperQuickWebApp;
    use CGI::QuickApp [qw(mode1 mode2 mode3)];
    __END__


    # Create the files for web app
    % perl -MCGI::QuickApp::Create SuperQuickWebApp.pm

    # It creates the following files:

      mylib/SuperQuickWebApp/mode1.pm
      mylib/SuperQuickWebApp/mode2.pm
      mylib/SuperQuickWebApp/mode3.pm
      template/mode1
      template/mode2
      template/mode3
      webapp.cgi

=head1 DESCRIPTION

CGI::QuickApp may help you build web-based applications more quickly
and more concisely. It is built upon L<CGI::Application>, so it
retains the strong points of run modes, but the interface is much
cleaner.

=head1 AUTOMATIC FILE CREATION

CGI::QuickApp::Create is designed for creating related files
automatically for you. Once you have the web app module written up,
CGI::QuickApp::Create may create related files for you.

    % perl -MCGI::QuickApp::Create YourWebApp.pm
       --script-name you_cgi_script         # default => webapp.cgi
       --template-dir your_template_dir     # default => template/
       --include-dir your_path_for_modules  # default => qw(mylib .)
       --force-create                       # use when webapp.cgi exists

The options can be omitted if you just like default settings.


=head1 A FULL EXAMPLE

The following is the full example showing available parameters
for configuring your WebApp.

    package WebApp;

    use CGI::QuickApp

    # Specify run modes
    run_modes => [qw(mode1 mode2 mode3 mode4 err)],

    # Specify handlers that don't agree with names of run modes
    run_mode_handlers => {
	# if 'use' or 'sub' is omitted,
	# 'use' is assumed for creating files.
        mode3 => 'use WebApp::Mode3',
	mode4 => 'sub handler_for_mode4',

        # if the handler is a subroutine, the subroutine
        # will be write back to the original webapp module.
        # This doesn't seem the best solution. I'll see to that.
    },

    # Specify the parameter name of run modes
    # The default is 'm'
    mode_param => 'm',

    # Specify start mode
    # If the start mode is not given, first element of run modes
    # will be the start mode
    start_mode => 'mode1',

    # Specify the mode for handling error
    error_mode => 'err',

    # Specify template name for run modes.
    # By default, the template name is the same as the mode's name
    templates => {
	mode2 => 'template_name_for_mode2',
	err => 'template_name_for_error_mode',
    },

    # Specify the directory for template files
    # Default config is  { INCLUDE_PATH => 'template' }
    # It will be forwarded to the constructor of Template Toolkit
    template_conf => {
	INCLUDE_PATH => 'template',
    },


    # Specify the arguments for mode handlers
    # default argument is   ( scalar($self->query()->Vars) )
    handler_args => q+ scalar($self->query()->Vars) +,


    # Specify header information
    # default character set is 'utf8'
    # default content type is 'text/html'
    header_props => {
        -charset => 'utf8',
	-type => 'text/html',
    },

    # Set application-wide parameters
    params => {
    },
    ;


    # The same as cgiapp_init(), cgiapp_prerun(), cgiapp_postrun()
    # but prefix is stripped for brevity
    sub init {}
    sub prerun {}
    sub postrun {}
    sub teardown {}


=head1 NOTE

Currently, only Template Toolkit is supported. Apology to
CGI::Application users! Support is coming soon.

=head1 THE AUTHOR

Yung-chung Lin (a.k.a. xern) E<lt>xern@cpan.orgE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself

=cut
