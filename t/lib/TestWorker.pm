package TestWorker;
use Moose;

sub run {
    while (1) {
        sleep 2;
        print "worker $$ here\n";
    }
}

1;
