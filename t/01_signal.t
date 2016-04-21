use strict;
use warnings;

use threads;
use threads::shared;

use Test::More 'no_plan';

use_ok('Thread::Cancel', 'SIGILL');

my $thr = threads->create(sub { while (1) { } });
ok($thr, 'Thread created');
ok($thr->is_running(), 'Thread running');
ok(! $thr->is_detached(), 'Thread not detached');
ok(! $thr->cancel(), 'Thread cancelled');
threads->yield();
ok(! $thr->is_running(), 'Thread not running');
ok($thr->is_detached(), 'Thread detached');

$SIG{'ILL'} = sub {
    is(shift, 'ILL', 'Received cancel signal');
    threads->exit();
};

$thr = threads->create(sub { while (1) { } });
ok(! $thr->cancel(), 'Sent cancel signal');
threads->yield();

# EOF
