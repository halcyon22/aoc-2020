#!/usr/bin/perl -W

use strict;
use warnings;
use Data::Dumper qw(Dumper);

my $inputFilename = "input";
if (scalar @ARGV > 0) {
    $inputFilename = shift @ARGV;
    print "using $inputFilename as input\n";
}

my %groupQuestions = ();
my $totalAffirmative = 0;
open(my $file, "<", "$inputFilename") or die "$inputFilename: $!";
while (my $line = <$file>) {
    print "line=$line";
    chomp $line;

    my @lineQuestions = split(//, $line);
    if (@lineQuestions > 0) {
        foreach my $question (@lineQuestions) {
            $groupQuestions{$question} = 1;
        }
    } else {
        $totalAffirmative += keys %groupQuestions;
        print "total after group: $totalAffirmative\n";
        %groupQuestions = ();
    }
    print join(",", sort(keys(%groupQuestions))) . "\n";
}
close($file);

$totalAffirmative += keys %groupQuestions;
print "total affirmative questions: $totalAffirmative\n";
