use strict;
use warnings;

use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

# Test out that we can load the setup sql into the database
my $db_file = 'TestDB.sqlite';
if (-f $db_file) {
    unlink($db_file) or die "Can't remove $db_file: $!"
}

my $sqlite3_return = system("sqlite3 $db_file < bin/setup_blog_db.sql");
is $sqlite3_return, 0, "Database was loaded successfully";

# Okay, now let's configure our app to use this database
my $t = Test::Mojo->new('App', {
    blog_db_file => $db_file,
    port         => '12345',
});

# Hide all the extra "trace" level logging, because I don't want the test to
# be noisy
$t->app->log->level('debug');

# Check that various pages will load successfully
$t->get_ok('/')->status_is(200);
$t->get_ok('/about')->status_is(200);
$t->get_ok('/entry/18')->status_is(200);
$t->get_ok('/random')->status_is(200);
$t->get_ok('/backwards')->status_is(200);
$t->get_ok('/forwards')->status_is(200);

# TODO: test an invalid entry. it should 404. it does not currently do that

unlink($db_file) or die "Can't remove $db_file: $!";

done_testing;
