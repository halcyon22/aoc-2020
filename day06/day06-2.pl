#!/usr/bin/perl -W

use strict;
use warnings;
use Data::Dumper qw(Dumper);

my $inputFilename = "input";
if (scalar @ARGV > 0) {
    $inputFilename = shift @ARGV;
    print "using $inputFilename as input\n";
}

my %allQuestions = ();
foreach my $question ('a'..'z') {
    $allQuestions{$question} = 1;
}

my %groupQuestions = %allQuestions;
my $totalAffirmative = 0;
open(my $file, "<", "$inputFilename") or die "$inputFilename: $!";
while (my $line = <$file>) {
    print "line=$line";
    chomp $line;

    my @lineQuestions = split(//, $line);
    if (@lineQuestions > 0) {
        foreach my $remainingQuestion (keys %groupQuestions) {
            my $remainingQuestionFound = grep(/$remainingQuestion/, @lineQuestions);
            if (!$remainingQuestionFound) {
                delete($groupQuestions{$remainingQuestion});
            }
        }
    } else {
        $totalAffirmative += keys %groupQuestions;
        print "group count: " . keys(%groupQuestions) . "\n";
        %groupQuestions = %allQuestions;
    }
    print "remaining questions: " . join(",", sort(keys(%groupQuestions))) . "\n";
}
close($file);

$totalAffirmative += keys %groupQuestions;
print "total affirmative questions: $totalAffirmative\n";
