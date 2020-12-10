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

my @input = ();

open(my $file, "<", "$inputFilename") or die "$inputFilename: $!";
while (my $line = <$file>) {
    # print "line=$line";
    chomp $line;

    push(@input, $line);
}
close($file);

my $targetNumber = 57195069;
my $rangeFound = 0;
my $firstIndex = 0;
my $inputSize = @input;
my $firstIndexLimit = $inputSize-1;
my $secondIndexLimit = $inputSize;

while (!$rangeFound && $firstIndex < $firstIndexLimit) {

    my $sum = $input[$firstIndex];
    for (my $secondIndex = $firstIndex + 1; $secondIndex < $secondIndexLimit; $secondIndex++) {
        $sum += $input[$secondIndex];

        print "sum=$sum between [$firstIndex] $input[$firstIndex] and [$secondIndex] $input[$secondIndex]\n";
        if ($sum == $targetNumber) {
            $rangeFound = $firstIndex . '-' . $secondIndex;
            last;
        }
    }

    $firstIndex++;
}

print "range found: $rangeFound\n";
my ($rangeStart, $rangeEnd) = split(/-/, $rangeFound);

my $smallest;
my $largest;
for (my $i = $rangeStart; $i <= $rangeEnd; $i++) {
    my $current = $input[$i];
    $smallest = $current if !$smallest || $smallest > $current;

    my $current = $input[$i];
    $largest = $current if !$largest || $largest < $current;
}

my $answer = $smallest + $largest;
print "$smallest + $largest = $answer\n";
