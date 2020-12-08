#!/usr/bin/perl -W

use strict;
use warnings;
use Data::Dumper qw(Dumper);

my $inputFilename = "input";
if (scalar @ARGV > 0) {
    $inputFilename = shift @ARGV;
    print "using $inputFilename as input\n";
}

our %containedByMap = ();

open(my $file, "<", "$inputFilename") or die "$inputFilename: $!";
while (my $line = <$file>) {
    print "\nline=$line";
    chomp $line;

    my @parts = split(/\s+bags\s+contain\s+/, $line);
    my $container = shift @parts;
    $container =~ s/\s+/-/;
    my $unparsedContainedPart = shift @parts;
    my @containedList = split(/, /, $unparsedContainedPart);

    print "container=$container\n";

    foreach my $containedPiece (@containedList) {
        $containedPiece =~ /^(?:\d+\s+)?(\w+\s+\w+)(?:\s+bags?\.?)?$/ or die "couldn't parse \"$containedPiece\"\n";
        my $contained = $1;
        $contained =~ s/\s+/-/;
        print " contained=$contained\n";
        
        my %containers = ();
        if ($containedByMap{$contained}) {
            %containers = %{$containedByMap{$contained}};
        }
        $containers{$container} = 1;

        print "  containers: " . join(" ", sort(keys(%containers))) . "\n";
        $containedByMap{$contained} = \%containers;
    }

}
close($file);

our %outermost = ();
our $indent = -1;
my $target = "shiny-gold";
findOutermostColors($target);
delete($outermost{$target});
print "total outermost colors for $target: " . keys(%outermost) . "\n";


sub findOutermostColors {
    my $startColor = shift @_;
    my $currentIndent = " " x ++$indent;

    die "whoa whoa whoa" if $indent > 100;

    %outermost = (%outermost, ($startColor => 1)) if $indent > 0;

    print "$currentIndent$startColor\n";

    if ($containedByMap{$startColor}) {
        my %containers = %{$containedByMap{$startColor}};
        foreach my $nextContainer (sort(keys %containers)) {
            if ($outermost{$nextContainer}) {
                print $currentIndent . "already checked $nextContainer\n";
                next;
            }
            findOutermostColors($nextContainer);
        }

        print $currentIndent . "current: " . join(" ", sort(keys(%outermost))) . "\n";
    }

    $indent--;
}
