#!/usr/bin/perl -W

use strict;
use warnings;
use Data::Dumper qw(Dumper);

my $inputFilename = "input";
if (scalar @ARGV > 0) {
    $inputFilename = shift @ARGV;
    print "using $inputFilename as input\n";
}

my $rowIndex = 0;
my $columnIndex = 0;
my $treeCount = 0;
open(my $file, "<", "$inputFilename") or die "$inputFilename: $!";
while (my $line = <$file>) {
    chomp $line;
    my @row = split(//, $line);
    my $columnCount = @row;
    
    my $terrain = $row[$columnIndex];
    print "row $rowIndex, col $columnIndex : $terrain\n";
    if ($terrain eq "#") {
        $treeCount++;
    }

    $rowIndex++;
    $columnIndex += 3;
    if ($columnIndex > $columnCount-1) {
        my $wrap = $columnIndex - $columnCount;
        $columnIndex = $wrap;
    }
}
close($file);

print "i would run into $treeCount trees\n";
