#!/usr/bin/perl -W

use v5.10;
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

    delete($fields{'cid'});

    foreach my $key (keys %fields) {
        my $fieldValue = $fields{$key};
        print "$key is ";

        my $isFieldValid = $INVALID;
        given($key) {
            when('byr') { $isFieldValid = isValidBirthYear($fieldValue); }
            when('iyr') { $isFieldValid = isValidIssueYear($fieldValue); }
            when('eyr') { $isFieldValid = isValidExpirationYear($fieldValue); }
            when('hgt') { $isFieldValid = isValidHeight($fieldValue); }
            when('hcl') { $isFieldValid = isValidHairColor($fieldValue); }
            when('ecl') { $isFieldValid = isValidEyeColor($fieldValue); }
            when('pid') { $isFieldValid = isValidPassportId($fieldValue); }
        }

        if ($isFieldValid == $VALID) {
            print "valid\n";
        } else {
            delete($fields{$key});
            print "not valid\n";
        }
    }
    
    my $validFieldCount = keys %fields;
    print "with $validFieldCount valid fields, ";
    if ($validFieldCount >= 7) {
        print "passport is valid\n";
        return $VALID;
    } else {
        print "passport is not valid\n";
        return $INVALID;
    }
}

sub isValidBirthYear {
    my $birthYear = shift @_;

    return $INVALID if $birthYear !~ /^\d{4}$/;
    return $INVALID if $birthYear < 1920;
    return $INVALID if $birthYear > 2002;
    return $VALID;
}

sub isValidIssueYear {
    my $issueYear = shift @_;

    return $INVALID if $issueYear !~ /^\d{4}$/;
    return $INVALID if $issueYear < 2010;
    return $INVALID if $issueYear > 2020;
    return $VALID;
}

sub isValidExpirationYear {
    my $expirationYear = shift @_;

    return $INVALID if $expirationYear !~ /^\d{4}$/;
    return $INVALID if $expirationYear < 2020;
    return $INVALID if $expirationYear > 2030;
    return $VALID;
}

sub isValidHeight {
    my $height = shift @_;

    return $INVALID if $height !~ /^(\d{2,3})(cm|in)$/;
    my $measurement = $1;
    my $unit = $2;
    if ($unit eq "cm") {
        return $INVALID if $measurement < 150;
        return $INVALID if $measurement > 193;
        return $VALID;
    }
    if ($unit eq "in") {
        return $INVALID if $measurement < 59;
        return $INVALID if $measurement > 76;
        return $VALID;
    }

    return $INVALID;
}

sub isValidHairColor {
    my $hairColor = shift @_;

    return $INVALID if $hairColor !~ /^#[0-9a-f]{6}$/;
    return $VALID;
}

sub isValidEyeColor {
    my $eyeColor = shift @_;

    return $INVALID if $eyeColor !~ /^(amb|blu|brn|gry|grn|hzl|oth)$/;
    return $VALID;
}

sub isValidPassportId {
    my $passportId = shift @_;

    return $INVALID if $passportId !~ /^\d{9}$/;
    return $VALID;
}
