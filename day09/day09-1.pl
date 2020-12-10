#!/usr/bin/perl -W

use v5.10;
use strict;
use warnings;
use Data::Dumper qw(Dumper);

my $inputFilename = "input";
if (scalar @ARGV > 0) {
    $inputFilename = shift @ARGV;
    print "using $inputFilename as input\n";
}

my $windowSize = 25;
my $targetNumber = 0;
my @window = ();

open(my $file, "<", "$inputFilename") or die "$inputFilename: $!";
while (my $line = <$file>) {
    # print "line=$line";
    chomp $line;
    $targetNumber = $line;

    if (@window == $windowSize) {
        print "looking for numbers that sum to $targetNumber\n";
        print "  in window: @window\n";

        my $foundOne = 0;
        for (my $firstIndex = 0; $firstIndex < $windowSize && !$foundOne; $firstIndex++) {
            for (my $secondIndex = 0; $secondIndex < $windowSize && !$foundOne; $secondIndex++) {
                my $first = $window[$firstIndex];
                my $second = $window[$secondIndex];
                next if $first == $second;

                my $sum = $first + $second;
                # print "$first + $second = $sum\n";
                if ($targetNumber == $sum) {
                    $foundOne = 1;
                }
            }
        }
        last if !$foundOne;

        shift(@window);
    }
    push(@window, $targetNumber);
}
close($file);

print "$targetNumber doesn't have a pair in the previous $windowSize that sum to it\n";
