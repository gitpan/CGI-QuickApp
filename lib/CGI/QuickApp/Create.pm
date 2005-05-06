package CGI::QuickApp::Create;

use strict;
$ENV{q(I am gonna create files for your app, ok?)} = 1;

use Data::Dumper;
use Getopt::Long;
use File::Path;
use File::Spec::Functions;
use Template;

my ($script_name, $template_dir) = ('webapp.cgi', 'template');
my @include_dir = qw(mylib .);
my $force_create;

sub create_tmpl_files {
    my @files = @_;
    if(not -d $template_dir){
	mkdir $template_dir, 0777 or die "Couldn't create template directory\n";
    }
    foreach my $file (map{catfile($template_dir, $_)} @files){
#	print "$file\n";
	open my $f, '>', $file or die "Couldn't create template file $file\n";
    }
}


my $handler_template =<<'.';
[% IF module %]
package [% module %];
[% END %]

[% IF module %]
sub handler {
[% ELSE %]
sub [% funcname %] {
[% END %]
    my %res;


    return %res;
}
[% IF module %]
1;
[% END %]
.

my $tt = Template->new() or die $Template::ERROR;

sub create_handler_pm_files {
    my @pm = @_;
    foreach my $module (@pm){
	my @p = split /::/, $module;
	my $file = (pop @p).'.pm';
	my $path = catfile($include_dir[0], catfile(@p));
#	print "$path\n";
	mkpath([$path], 0, 0755);

	open my $f, '>', catfile($path, $file)
	    or die "Couldn't create template file $file";
	my $output;
	$tt->process(\$handler_template,
		     { module => $module },
		     \$output) or die $tt->error;
	print {$f} $output;
    }
}

sub create_handlers {
    my @func = @_;
    if(@func){
	open my $f, '>>', $0;
	print {$f} "\n\n__END__\n__GENERATED_MODE_HANDLERS__\n";
	foreach my $func (@func){
	    my $output;
	    $tt->process(\$handler_template,
			 { funcname => $func },
			 \$output) or die $tt->error;
	    print {$f} $output;
	}
    }
}

my $script_template = <<'.';
#!/usr/bin/perl

use lib qw([% lib %]);
use [% module %];
[% module %]::go();
.

sub create_script_file {
    my $module = shift;

    open my $f, '>', $script_name
	or die "Couldn't create script file $script_name";
    my $output;
    $tt->process(\$script_template,
		 { module => $module,
		   lib => join( q/ /, @include_dir) },
		 \$output) or die $tt->error;
    print {$f} $output;
}

sub create_files {
    my %gargs = @_;
    my $result = GetOptions ("script-name=s"  => \$script_name,
			     "template-dir=s" => \$template_dir,
			     "include-dir=s"  => \@include_dir,
			     "force-create"   => \$force_create,
			     );
#    print Dumper \%gargs;

    if(!-e $script_name ||
       (-e $script_name && $force_create)){
	create_tmpl_files(values %{$gargs{templates}});
	create_handler_pm_files(map{$_->[1]} 
				grep{$_->[0] ne 'sub'}
				values %{$gargs{run_mode_handlers}});

	create_handlers(map{$_->[1]}
			grep{$_->[0] eq 'sub'}
			values %{$gargs{run_mode_handlers}});
	create_script_file($gargs{caller_package});
    }
    else {
	print "\nFiles already exist. Use --force-create instead.\n\n";
    }
}

1;
__END__
