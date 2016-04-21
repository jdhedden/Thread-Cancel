use strict;
use warnings;

BEGIN {
    if ($] > 5.008) {
        require threads;
        import threads;
        require threads::shared;
        import threads::shared;
    }
}

use Test::More 'no_plan';

use_ok('Thread::Cancel', 'SIGILL');

my $thr = threads->create(sub { while (1) { } });
ok($thr, 'Thread created');
ok($thr->is_running(), 'Thread running');
ok(! $thr->is_detached(), 'Thread not detached');
ok(! $thr->cancel(), 'Thread cancelled');
threads->yield();
sleep(1);
ok(! $thr->is_running(), 'Thread not running');
ok($thr->is_detached(), 'Thread detached');

SKIP: {
    skip('ok broken in 5.8.0', 2) if ($] == 5.008);
    $SIG{'ILL'} = sub {
        is(shift, 'ILL', 'Received cancel signal');
        threads->exit();
    };

    $thr = threads->create(sub { while (1) { } });
    ok(! $thr->cancel(), 'Sent cancel signal');
    threads->yield();
    sleep(1);
}

# EOF
