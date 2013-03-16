use strict;
use warnings;
package Devel::Debug::Server::Client;

use Devel::Debug::Server;

#Abstract the client module pour the GUI or CLI client

=head2  refreshData

return all data necessary to display screen

=cut
sub refreshData {

    my $req = { type => $Devel::Debug::Server::DEBUG_GUI_TYPE
    };
    return sendCommand($req); #we just send a void command
}

=head2  sendCommand

send a command to the debug server to process whose pid is $pid. 
Returns the debug informations of the server.
The command is of the form:
    
            {
            command => $commandCode,
            arg1 => $firstArg, #if needed
            arg2 => $secondArg,#if needed
            arg3 => $thirdArg,#if needed
            };


=cut
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

=head2  step

step($pid) : send the step command to the processus of pid $pid
Return the debug informations

=cut
sub step {
    my ($pid) = @_;
    return Devel::Debug::Server::Client::sendCommand($pid,
            {
            command => $Devel::Debug::Server::STEP_COMMAND,
    });
}


=head2  breakpoint

breakpoint($file,$line) : set breakpoint 

=cut
sub breakPoint {
    my ($filePath,$lineNumber) = @_;
    return Devel::Debug::Server::Client::sendCommand(undef,
            {
            command => $Devel::Debug::Server::SET_BREAKPOINT_COMMAND,
            arg1    => $filePath,
            arg2    => $lineNumber,
    });
}

=head2  removeBreakPoint

removeBreakPoint($file,$line)

=cut
sub removeBreakPoint {
    my ($file,$line) = @_;
    return Devel::Debug::Server::Client::sendCommand(undef,
            {
            command => $Devel::Debug::Server::REMOVE_BREAKPOINT_COMMAND,
            arg1    => $file,
            arg2    => $line,
    });
}

=head2  run

run() : continue program execution until breakpoint

=cut
sub run {
    my ($pid) = @_;
    return Devel::Debug::Server::Client::sendCommand($pid,
            { command => $Devel::Debug::Server::RUN_COMMAND, });
}

=head2  return

return($pid,$returnedValue) : cause script of pid $pid to return of current subroutine. Optionnaly you can specify the value returned with $returnedValue.

=cut
sub return {
    my ($pid,$returnedValue) = @_;
    my $command = { command => $Devel::Debug::Server::RETURN_COMMAND} ;
    if (defined $returnedValue){
        $command ={ command => $Devel::Debug::Server::RETURN_COMMAND,
            arg1  => $returnedValue};
    }
    return Devel::Debug::Server::Client::sendCommand($pid,$command);
}


=head2  eval

eval($pid,$expression) : eval perl code contained into $expression in the script of pid $pid and returns the result

=cut
sub eval {
    my ($pid,$expression) = @_;
    return Devel::Debug::Server::Client::sendCommand($pid,
            { command => $Devel::Debug::Server::EVAL_COMMAND, 
              arg1    => $expression });
}
1;
