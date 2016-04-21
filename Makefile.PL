# Module makefile for Thread::Cancel (using ExtUtils::MakeMaker)

require 5.006;

use strict;
use warnings;

use ExtUtils::MakeMaker;

# Construct make file
WriteMakefile(
    'NAME'          => 'Thread::Cancel',
    'AUTHOR'        => 'Jerry D. Hedden <jdhedden AT cpan DOT org>',
    'VERSION_FROM'  => 'lib/Thread/Cancel.pm',
    'ABSTRACT_FROM' => 'lib/Thread/Cancel.pm',
    'PREREQ_PM'     => { 'threads'         => 1.36,
                         'Test::More'      => 0.50,
                       },
    ((ExtUtils::MakeMaker->VERSION() lt '6.25') ?
        ('PL_FILES' => { })            : ()),
    ((ExtUtils::MakeMaker->VERSION() gt '6.30') ?
        ('LICENSE'  => 'perl')         : ()),
);

# EOF