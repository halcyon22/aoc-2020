#!/usr/bin/perl -W

use strict;
use warnings;
use Data::Dumper qw(Dumper);

our $VALID = 1;
our $INVALID = 0;

my $inputFilename = "input";
if (scalar @ARGV > 0) {
    $inputFilename = shift @ARGV;
    print "using $inputFilename as input\n";
}

my $validPassportCount = 0;
my %fields = ();
open(my $file, "<", "$inputFilename") or die "$inputFilename: $!";
while (my $line = <$file>) {
    chomp $line;
    my %currentFields = split(/[: ]/, $line);

    if (keys %currentFields == 0) {
        $validPassportCount++ if validate(\%fields);
        %fields = ();
    } else {
        %fields = (%fields, %currentFields);
    }
}
close($file);

$validPassportCount++ if validate(\%fields);

print "found $validPassportCount valid passports\n";

sub validate {
    my %fields = %{shift @_};
    print Dumper \%fields;
    
    delete($fields{'cid'});

    foreach my $key (keys %fields) {
        delete($fields{$key}) unless $key =~ /^(byr|iyr|eyr|hgt|hcl|ecl|pid)$/;
    }

    my $fieldCount = keys %fields;
    print "with $fieldCount fields, ";
    if ($fieldCount >= 7) {
        print "passport is valid\n";
        return $VALID;
    } else {
        print "passport is not valid\n";
        return $INVALID;
    }
}
