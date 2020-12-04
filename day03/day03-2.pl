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
    chomp $line;
    my @row = split(//, $line);
    push(@input, \@row);
}
close($file);

my $right1Down1TreeCount = count_trees(1, 1, \@input);
my $right3Down1TreeCount = count_trees(3, 1, \@input);
my $right5Down1TreeCount = count_trees(5, 1, \@input);
my $right7Down1TreeCount = count_trees(7, 1, \@input);
my $right1Down2TreeCount = count_trees(1, 2, \@input);
my $product = $right1Down1TreeCount * $right3Down1TreeCount * $right5Down1TreeCount * $right7Down1TreeCount * $right1Down2TreeCount;
print "product = $product\n";

sub count_trees {
    my $right = shift @_;
    my $down = shift @_;
    my @input = @{shift @_};

    print "right=$right down=$down\n";

    my $rowIndex = 0;
    my $columnIndex = 0;
    my $treeCount = 0;
    while ($rowIndex < @input) {
        my @row = @{$input[$rowIndex]};
        my $columnCount = @row;
        
        my $terrain = $row[$columnIndex];
        print "row $rowIndex, col $columnIndex : $terrain\n";
        if ($terrain eq "#") {
            $treeCount++;
        }

        $rowIndex += $down;
        $columnIndex += $right;
        if ($columnIndex > $columnCount-1) {
            my $extra = $columnIndex - $columnCount;
            $columnIndex = $extra;
        }
    }
    print "for right=$right down=$down, i would run into $treeCount trees\n";
    return $treeCount;
}
