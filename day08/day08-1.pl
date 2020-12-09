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

my $instructionIndex = 0;
my $accumulator = 0;
my %executedInstructions = ();
while ($instructionIndex >= 0 && $instructionIndex < @input && !$executedInstructions{$instructionIndex}) {
    $executedInstructions{$instructionIndex} = 1;
    my $currentInstruction = $input[$instructionIndex];

    $currentInstruction =~ /^(\w{3})\s+([+-])(\d+)$/ or die "Couldn't parse instruction: $currentInstruction\n";
    my $operation = $1;
    my $sign = $2;
    my $number = $3;

    print "idx=$instructionIndex op=$operation sign=$sign number=$number acc=$accumulator\n";

    if ($operation eq "nop") {
        $instructionIndex++;
    } elsif ($operation eq "acc") {
        if ($sign eq '+') {
            $accumulator += $number;
        } else {
            $accumulator -= $number;
        }
        $instructionIndex++;
    } elsif ($operation eq "jmp") {
        if ($sign eq '+') {
            $instructionIndex += $number;
        } else {
            $instructionIndex -= $number;
        }
    }
}

print "finally: idx=$instructionIndex acc=$accumulator\n";