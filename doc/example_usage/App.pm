package App;
use Moose;
use SubApp;

sub run {
    while () {
        sleep 5;
        print "App awake: $$\n";
        print "SubApp says : " . SubApp::hello . "\n";
    }
}

1;
