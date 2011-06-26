#!/usr/bin/perl -w

use strict;
use warnings;

my ($fileName, $newfile) = @ARGV;
my %numberHash = ();

open (INDAT, "<$fileName") || die("Cannot open input file: $fileName");
open (OUTDAT, ">$newfile") || die("Cannot open output file: $newfile");

my $id = 0;

while (<INDAT>) {
	my @arr = split(" ", $_);
	
	foreach my $arrElem(@arr) {
		if ($arrElem =~ /([a-z]+\#)/) {
			if ($numberHash{$1} !~ /[\d]+/) {
				$numberHash{$1} = $id; 
				$id++;
			}
		} 
	}
}


while (my ($key, $value) = each(%numberHash)) {
	print "$key => $value\n";
}

# Code for deducing edge weights starts here
my @weightMatrix;
my @tempMat;
for (my $col = 0; $col < $id; $col++) {
	push @tempMat, 0;
}

for (my $row = 0; $row < $id; $row++) {
	push @weightMatrix, [ @tempMat ];
}

seek INDAT, 0, 0;

while (<INDAT>) {
	my @arr = split(" ", $_);
	print "$_\n";
	$weightMatrix[$numberHash{$arr[0]}][$numberHash{$arr[1]}] += 1;
}

print OUTDAT "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>\n";
print OUTDAT "<?meta name=\"GENERATOR\" content=\"XML::Smart 1.3.1\" ?>\n";
print OUTDAT "<graph edgedefault=\"directed\">\n";

my $tempid = $id;
while ($tempid > 0) {
	print OUTDAT "\t<node id=\"" . --$tempid . "\" name=\"" . $tempid . "\"/>\n";
}

foreach (my $row = 0; $row < $id; $row++) {
	foreach (my $col = 0; $col < $id; $col++) {
		if ($weightMatrix[$row][$col] > 0) {
			print OUTDAT "\t<edge source=\"$row\" target=\"$col\" weight=\"$weightMatrix[$row][$col]\"/>\n";
		}
	}
}

print OUTDAT "</graph>\n";

close (INDAT);
close (OUTDAT);