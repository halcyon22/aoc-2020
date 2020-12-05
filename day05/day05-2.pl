#!/usr/bin/perl -W

use strict;
use warnings;
use Data::Dumper qw(Dumper);

my $inputFilename = "input";
if (scalar @ARGV > 0) {
    $inputFilename = shift @ARGV;
    print "using $inputFilename as input\n";
}

my @rowNumberSpace = ();
foreach my $i (0..127) {
    $rowNumberSpace[$i] = $i;
}

my @columnNumberSpace = ();
foreach my $i (0..7) {
    $columnNumberSpace[$i] = $i;
}

my %seatIdSpace = ();
foreach my $i (0..1023) {
    $seatIdSpace{$i} = $i;
}

my $maxSeatId = 0;
my $minSeatId = 1023;

open(my $file, "<", "$inputFilename") or die "$inputFilename: $!";
while (my $line = <$file>) {
    chomp $line;

    my @fullSeatCode = split(//, $line);
    my @rowCode = @fullSeatCode;
    my @columnCode = ();
    unshift(@columnCode, pop(@rowCode));
    unshift(@columnCode, pop(@rowCode));
    unshift(@columnCode, pop(@rowCode));

    print "row code = @rowCode\n";
    
    my @remainingRowNumbers = @rowNumberSpace;
    my $remainingRowSpaceSize = @remainingRowNumbers;
    foreach my $flag (@rowCode) {
        $remainingRowSpaceSize = $remainingRowSpaceSize / 2;
        for (0..$remainingRowSpaceSize-1) {
            if ($flag eq "F") {
                pop(@remainingRowNumbers);
            } elsif ($flag eq "B") {
                shift(@remainingRowNumbers);
            }
        }
    }

    my $rowNumber = $remainingRowNumbers[0];

    print "column code = @columnCode\n";

    my @remainingColumnNumbers = @columnNumberSpace;
    my $remainingColumnSpaceSize = @remainingColumnNumbers;
    foreach my $flag (@columnCode) {
        $remainingColumnSpaceSize = $remainingColumnSpaceSize / 2;
        for (0..$remainingColumnSpaceSize-1) {
            if ($flag eq "L") {
                pop(@remainingColumnNumbers);
            } elsif ($flag eq "R") {
                shift(@remainingColumnNumbers);
            }
        }
    }

    my $columnNumber = $remainingColumnNumbers[0];

    my $seatId = $rowNumber * 8 + $columnNumber;
    print "$rowNumber * 8 + $columnNumber = $seatId\n";

    $maxSeatId = $seatId if $seatId > $maxSeatId;
    $minSeatId = $seatId if $seatId < $minSeatId;

    delete($seatIdSpace{$seatId});
}
close($file);

print "min seat: $minSeatId\n";
print "max seat: $maxSeatId\n";

foreach my $seatId (0..$minSeatId) {
    delete($seatIdSpace{$seatId});
}
foreach my $seatId ($maxSeatId..1023) {
    delete($seatIdSpace{$seatId});
}

print "remaining seat ids: " . join(" ", keys(%seatIdSpace)) . "\n";
