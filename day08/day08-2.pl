#!/usr/bin/perl -W

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

our @instructionIndexesChanged = ();
my $runCount = 1;
my $maxIterations = 100;
my $finalInstructionIndex = 0;
my $inputSize = scalar(@input);
while ($finalInstructionIndex != $inputSize) {
    $finalInstructionIndex = executeInstructions(\@input);
    print "run $runCount: expected=$inputSize actual=$finalInstructionIndex\n";

    die "over $maxIterations iterations" if ++$runCount > $maxIterations;
}

sub executeInstructions {
    my @input = @{shift(@_)};

    my $changeTriedThisRun = 0;

    print "\ntried changing so far: @instructionIndexesChanged\n";

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

        if ($operation ne "acc" && !$changeTriedThisRun && !grep(/^$instructionIndex$/, @instructionIndexesChanged)) {
            print "changing instruction $instructionIndex [$currentInstruction]\n";

            if ($operation eq "nop") {
                $operation = "jmp";
            } elsif ($operation eq "jmp") {
                $operation = "nop";
            }
            $changeTriedThisRun = 1;
            push(@instructionIndexesChanged, $instructionIndex);
        }

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
    return $instructionIndex;
}