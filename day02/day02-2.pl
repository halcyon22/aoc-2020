#!/usr/bin/perl -W

use strict;
use warnings;
use Data::Dumper qw(Dumper);

my @valid = ();
open(my $file, "<", "input") or die "input: $!";
while (my $line = <$file>) {
    chomp $line;
    my ($pos1, $pos2, $ruleCharacter, $passwd) = ($line =~ /(\d+)-(\d+)\s+(\w):\s+(\w+)/) or die "Couldn't parse $line";

    my @passwdChars = split(//, $passwd);
    my $passwdSize = @passwdChars;
    my $pos1Match = $passwdChars[$pos1-1] eq $ruleCharacter;
    my $pos2Match = $passwdChars[$pos2-1] eq $ruleCharacter;

    if (($pos1Match && !$pos2Match) || (!$pos1Match && $pos2Match)) {
        push(@valid, {
            pos1 => $pos1,
            pos2 => $pos2,
            ruleCharacter => $ruleCharacter,
            passwd => $passwd
        });
        print "valid: $pos1 | $pos2 | $ruleCharacter | $passwd\n";
    } else {
        print "invalid: $pos1 | $pos2 | $ruleCharacter | $passwd\n";
    }
}
close($file);

my $validSize = @valid;
print "valid passwords: $validSize\n";
