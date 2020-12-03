#!/usr/bin/perl -W

use strict;
use warnings;
use Data::Dumper qw(Dumper);

my @input = ();
open(my $file, "<", "input") or die "input: $!";
while (my $line = <$file>) {
    chomp $line;
    push(@input, $line);
}
close($file);

my $TARGET = 2020;

my @entries = sort { $a <=> $b } @input;
my @firsts = @entries;
my @seconds = @entries;
my @thirds = @entries;

foreach my $first (@firsts) {
    foreach my $second (@seconds) {
        foreach my $third (@thirds) {
            my $sum = $first + $second + $third;
            print "$first + $second + $third = $sum\n";
            if ($sum == $TARGET) {
                my $product = $first * $second * $third;
                print "product = $product\n";
                exit 0;
            }
        }
    }
}