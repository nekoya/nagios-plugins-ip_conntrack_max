#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;

my $STATE_OK        = 0;
my $STATE_WARNING   = 1;
my $STATE_CRITICAL  = 2;
my $STATE_UNKNOWN   = 3;
my $STATE_DEPENDENT = 4;

sub usage {
    print "usage: check_ip_conntrack_max.pl -c <correct value>\n\n";
    print "options:\n";
    print "  -c, --correct=<INTEGER>\n";
    exit $STATE_UNKNOWN;
}

my $opt = sub {
    my %opt;
    my @options = (\%opt, qw/help correct=i/);
    GetOptions(@options) or usage();
    \%opt;
}->();
my $expected = $opt->{correct} or usage();

my $got = `cat /proc/sys/net/ipv4/ip_conntrack_max`;
chomp $got;

if ($got != $expected) {
    print "got: $got, expected: $expected\n";
    exit $STATE_CRITICAL;
}

print "ip_conntrack_max: $got\n";
exit $STATE_OK;
