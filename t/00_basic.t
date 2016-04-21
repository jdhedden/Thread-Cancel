use strict;
use warnings;

use Test::More 'no_plan';

use_ok('Thread::Cancel');

eval {
    require Thread::Suspend;
    import Thread::Suspend;
};

if ($Thread::Cancel::VERSION) {
    diag('Testing Thread::Cancel ' . $Thread::Cancel::VERSION);
}

can_ok('threads', qw(cancel));

my $thr = threads->create(sub { while (1) { } });
ok($thr, 'Thread created');
ok($thr->is_running(), 'Thread running');
ok(! $thr->is_detached(), 'Thread not detached');
ok(! $thr->cancel(), 'Thread cancelled');
threads->yield();
ok(! $thr->is_running(), 'Thread not running');
ok($thr->is_detached(), 'Thread detached');

$thr = threads->create(sub { threads->self()->cancel(); });
threads->yield();
ok(! $thr->is_running(), 'Thread not running');
ok($thr->is_detached(), 'Thread detached');

$thr = threads->create(sub { while (1) { } });
my $thr2 = threads->create(sub { while (1) { } });
ok($thr && $thr2, 'Thread created');
$thr->detach();
ok(! threads->cancel(), 'Threads cancelled');
threads->yield();
ok(! $thr2->is_running(), 'Thread not running');
ok($thr2->is_detached(), 'Thread detached');
ok($thr->is_running(), 'Thread still running');
ok($thr->is_detached(), 'Thread detached');
ok(! $thr->cancel(), 'Thread cancelled');
threads->yield();
ok(! $thr->is_running(), 'Thread not running');

$thr = threads->create(sub { while (1) { } });
$thr2 = threads->create(sub { while (1) { } });
ok($thr && $thr2, 'Thread created');
$thr2->detach();
ok(! threads->cancel($thr2, $thr->tid()), 'Threads cancelled');
threads->yield();
ok(! $thr->is_running(), 'Thread not running');
ok($thr->is_detached(), 'Thread detached');
ok(! $thr2->is_running(), 'Thread not running');
ok($thr2->is_detached(), 'Thread detached');

SKIP:
{
    skip('Thread::Suspend not available', 4) unless threads->can('suspend');

    $thr = threads->create(sub { threads->self()->suspend(); });
    threads->yield();
    ok($thr->is_suspended(), 'Thread suspended');
    ok(! $thr->cancel(), 'Thread cancelled');
    threads->yield();
    ok(! $thr->is_running(), 'Thread not running');
    ok($thr->is_detached(), 'Thread detached');
}

# EOF
