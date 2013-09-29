#!/usr/bin/env perl
use strict;
use warnings;
use Devel::Debug::Server::Agent;

# PODNAME: debugAgent.pl

# ABSTRACT: The devel::Debug agent

my $commandToLaunch = join(' ',@ARGV);
Devel::Debug::Server::Agent::loop($commandToLaunch);

__END__

=pod

=head1 NAME

debugAgent.pl - The devel::Debug agent

=head1 VERSION

version 0.006

=head1 SYNOPSIS

#on command-line

#... first launch the debug server (only once)

tom@house:debugServer.pl 

server is started...

#now launch your script(s) to debug 

tom@house:debugAgent.pl path/to/scriptToDebug.pl

#in case you have arguments

tom@house:debugAgent.pl path/to/scriptToDebug.pl arg1 arg2 ...

#now you can send debug commands with the Devel::Debug::Server::Client module

=head1 DESCRIPTION

To debug a perl script, simply start the server and launch the script with debugAgent.pl.

=head1 AUTHOR

Jean-Christian HASSLER <hasslerjeanchristian@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Jean-Christian HASSLER.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
