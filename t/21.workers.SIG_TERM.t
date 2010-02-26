use Test::More tests => 4;
use lib qw(lib);
use lib qw(t/lib);
use strict;

{
    package Manager;
    use MooseX::Workers::Job;
    use Moose;
    with qw(MooseX::Workers);

    sub _kill_workers {
        my $self = shift;
        my @keys = $self->get_worker_ids;

        foreach my $wheel_id ( @keys ) {
            warn "going to kill_worker($wheel_id)\n";
            my $t = $self->kill_worker($wheel_id);
        }
    }
    sub sig_TERM {
        my ($self) = @_;
        $self->_kill_workers();
     #   $self->num_workers = 0; # Don't do this!
    }

    sub worker_manager_start {
        ::pass('started worker manager');
    }

    sub worker_manager_stop {
        ::pass('stopped worker manager');
    }

    sub worker_stdout {
        my ( $self, $output, $wheel ) = @_;
        ::is( $output, "HELLO", "STDOUT" );
    }

    sub worker_stderr {
        my ( $self, $output, $wheel ) = @_;
        ::is( $output, "WORLD", "STDERR" );
    }

    sub worker_error { ::fail('Got error?'.@_) }

    sub worker_started { 
        my ( $self, $job ) = @_;
        ::pass("worker started");
        kill "TERM", $$;    # Send the worker manager (myself) the TERM signal
    }
    
    sub worker_done  { 
        my ( $self, $job ) = @_;
        ::pass("worker_done");
    }

    sub run {
        my $self = shift;

        for my $i (1..2) {
            $self->spawn( sub { 
                require TestWorker;
                TestWorker->run();
            } );
        }

        POE::Kernel->run();
    }
    no Moose;
}


Manager->new()->run();


