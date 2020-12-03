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
my @firsts = ();
my @seconds = ();
foreach my $entry (@entries) {
    if ($entry * 2 <= $TARGET) {
        push(@firsts, $entry);
    } else {
        push(@seconds, $entry);
    }
}

my $firstIndex = 0;
my $secondIndex = 0;

while ($firstIndex < @firsts) {
    my $first = $firsts[$firstIndex];
    my $second = $seconds[$secondIndex];
    my $sum = $first + $second;
    print "$first + $second = $sum\n";

    last if ($sum == $TARGET);

    if ($sum > $TARGET or $secondIndex == @seconds) {
        $firstIndex++;
        $secondIndex = 0;
    } else {
        $secondIndex++;
    }
}

my $first = $firsts[$firstIndex];
my $second = $seconds[$secondIndex];
my $product = $first * $second;
print "$first * $second = $product\n";
