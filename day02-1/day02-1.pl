#!/usr/bin/perl -W

use strict;
use warnings;
use Data::Dumper qw(Dumper);

my @valid = ();
open(my $file, "<", "input") or die "input: $!";
while (my $line = <$file>) {
    chomp $line;
    my ($minCount, $maxCount, $ruleCharacter, $passwd) = ($line =~ /(\d+)-(\d+)\s+(\w):\s+(\w+)/) or die "Couldn't parse $line";

    my @passwdChars = split(//, $passwd);
    my $actualCount = 0;
    foreach my $char (@passwdChars) {
        $actualCount++ if ($char eq $ruleCharacter);
    }

    if ($actualCount >= $minCount && $actualCount <= $maxCount) {
        push(@valid, {
            minCount => $minCount,
            maxCount => $maxCount,
            ruleCharacter => $ruleCharacter,
            passwd => $passwd,
            actualCount => $actualCount
        });
        print "valid: $minCount | $actualCount | $maxCount | $ruleCharacter | $passwd\n";
    } else {
        print "invalid: $minCount | $actualCount | $maxCount | $ruleCharacter | $passwd\n";
    }
}
close($file);

print "valid passwords: " . scalar @valid . "\n";
