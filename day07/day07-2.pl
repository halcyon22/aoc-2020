#!/usr/bin/perl -W

use strict;
use warnings;
use Data::Dumper qw(Dumper);

my $inputFilename = "input";
if (scalar @ARGV > 0) {
    $inputFilename = shift @ARGV;
    print "using $inputFilename as input\n";
}

our %rules = ();

open(my $file, "<", "$inputFilename") or die "$inputFilename: $!";
while (my $line = <$file>) {
    print "\nline=$line";
    chomp $line;

    my @parts = split(/\s+bags\s+contain\s+/, $line);
    my $outerColor = shift @parts;
    $outerColor =~ s/\s+/-/;
    my $unparsedInnersPart = shift @parts;
    my @innersList = split(/, /, $unparsedInnersPart);

    print "$outerColor\n";

    my %contents = ();
    foreach my $inner (@innersList) {
        if (substr($inner, 0, 2) eq "no") {
            next;
        }

        $inner =~ /^(\d+)\s+(\w+\s+\w+)(?:\s+bags?\.?)?$/ or die "couldn't parse \"$inner\"\n";
        my $count = $1;
        my $innerColor = $2;
        $innerColor =~ s/\s+/-/;
        
        print " " . $count . "x $innerColor\n";

        $contents{$innerColor} = $count;
    }
    $rules{$outerColor} = \%contents;
}
close($file);

our $indent = -1;
my $outer = "shiny-gold";
my $totalCount = sumInnerColors($outer);

print "total: $totalCount\n";

sub sumInnerColors {
    my $startColor = shift @_;
    my $currentIndent = " " x ++$indent;
    die "infinite recursion?" if $indent > 100;

    my %requiredContents = %{$rules{$startColor}};

    my $count = 0;
    foreach my $innerColor (sort(keys(%requiredContents))) {
        my $innerCount = $requiredContents{$innerColor};
        $count += $innerCount;
        print $currentIndent . " $innerColor adds $innerCount\n";

        my $numberOfFurtherColors = keys(%{$rules{$innerColor}});
        if ($numberOfFurtherColors > 0) {
            my $innerSum = sumInnerColors($innerColor);
            my $innerTotal = $innerCount * $innerSum;
            print $currentIndent . " $innerColor adds $innerCount * $innerSum = $innerTotal more\n";
            $count += $innerTotal;
        }
    }

    $indent--;
    return $count;
}
