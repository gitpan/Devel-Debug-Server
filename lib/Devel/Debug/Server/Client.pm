use strict;
use warnings;
package Devel::Debug::Server::Client;

use Devel::Debug::Server;

# PODNAME: Client module

# ABSTRACT: the client module for the GUI or CLI client

sub refreshData {

    my $req = { type => $Devel::Debug::Server::DEBUG_GUI_TYPE
    };
    return sendCommand($req); #we just send a void command
}

sub sendCommand {
    my($pid,$command)= @_;
    
    Devel::Debug::Server::initZeroMQ();

    my $req = { type => $Devel::Debug::Server::DEBUG_GUI_TYPE,
                command => $command,
                pid=> $pid,
    };
    my $answer = Devel::Debug::Server::send($req);

    return $answer;
   
}

sub step {
    my ($pid) = @_;
    return Devel::Debug::Server::Client::sendCommand($pid,
            {
            command => $Devel::Debug::Server::STEP_COMMAND,
    });
}


sub breakPoint {
    my ($filePath,$lineNumber) = @_;
    return Devel::Debug::Server::Client::sendCommand(undef,
            {
            command => $Devel::Debug::Server::SET_BREAKPOINT_COMMAND,
            arg1    => $filePath,
            arg2    => $lineNumber,
    });
}

sub removeBreakPoint {
    my ($file,$line) = @_;
    return Devel::Debug::Server::Client::sendCommand(undef,
            {
            command => $Devel::Debug::Server::REMOVE_BREAKPOINT_COMMAND,
            arg1    => $file,
            arg2    => $line,
    });
}

sub run {
    my ($pid) = @_;
    return Devel::Debug::Server::Client::sendCommand($pid,
            { command => $Devel::Debug::Server::RUN_COMMAND, });
}

sub suspend {
    my ($pid) = @_;
    return Devel::Debug::Server::Client::sendCommand($pid,
            { command => $Devel::Debug::Server::SUSPEND_COMMAND });
}
sub return {
    my ($pid,$returnedValue) = @_;
    my $command = { command => $Devel::Debug::Server::RETURN_COMMAND} ;
    if (defined $returnedValue){
        $command ={ command => $Devel::Debug::Server::RETURN_COMMAND,
            arg1  => $returnedValue};
    }
    return Devel::Debug::Server::Client::sendCommand($pid,$command);
}


sub eval {
    my ($pid,$expression) = @_;
    return Devel::Debug::Server::Client::sendCommand($pid,
            { command => $Devel::Debug::Server::EVAL_COMMAND, 
              arg1    => $expression });
}
1;

__END__

=pod

=head1 NAME

Client module - the client module for the GUI or CLI client

=head1 VERSION

version 0.007

=head2 refreshData

return all data necessary to display screen

=head2 sendCommand

send a command to the debug server to process whose pid is $pid. 
Returns the debug informations of the server.
The command is of the form:

            {
            command => $commandCode,
            arg1 => $firstArg, #if needed
            arg2 => $secondArg,#if needed
            arg3 => $thirdArg,#if needed
            };

=head2 step

step($pid) : send the step command to the processus of pid $pid
Return the debug informations

=head2 breakpoint

breakpoint($file,$line) : set breakpoint 

=head2 removeBreakPoint

removeBreakPoint($file,$line)

=head2 run

run() : continue program execution until breakpoint

=head2 suspend

suspend the running process

=head2 return

return($pid,$returnedValue) : cause script of pid $pid to return of current subroutine. Optionnaly you can specify the value returned with $returnedValue.

=head2 eval

eval($pid,$expression) : eval perl code contained into $expression in the script of pid $pid and returns the result

=head1 AUTHOR

Jean-Christian HASSLER <hasslerjeanchristian@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Jean-Christian HASSLER.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
