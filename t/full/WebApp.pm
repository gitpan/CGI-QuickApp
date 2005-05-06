package WebApp;

use CGI::QuickApp

    # specify run modes
    run_modes => [qw(mode1 mode2 mode3 mode4 err)],

    # specify handlers that don't agree with names of run modes
    run_mode_handlers => {
        mode3 => 'use WebApp::Mode3',
	mode4 => 'handler_for_mode4',
    },

    # specify the parameter name of run modes
    # The default is 'm'
    mode_param => 'm',

    # specify start mode
    start_mode => 'mode1',

    # specify the mode for handling error
    error_mode => 'err',

    # specify template name for run modes.
    # By default, the template name is the same as the mode's name
    templates => {
	mode2 => 'template_name_for_mode2',
	err => 'template_name_for_error_mode',
    },

    # specify the directory for template files
    # default config is  { INCLUDE_PATH => 'template' }
    template_conf => {
	INCLUDE_PATH => 'template',
    },



    # Specify the arguments for mode handlers
    # default argument is
    # ( scalar($self->query()->Vars) )
    handler_args => q+ scalar($self->query()->Vars) +,


    # specify header information
    # default character set is 'utf8'
    # default content type is 'text/html'
    header_props => {
        -charset => 'utf8',
	-type => 'text/html',
    },

    # set application-wide parameters
    params => {
    },
    ;

sub mode1 {
    (MODE => 'mode 1?');
}

sub mode2 {
    (MODE => 'mode 2?');
}

sub handler_for_mode4 {
    (MODE => 'mode 4?');
}

sub init {
#    print "init\n";
}

sub prerun {
#    print "prerun\n";
}
sub postrun {
#    print "postrun\n";
}
sub teardown {
#    print "teardown\n";
}

1;
