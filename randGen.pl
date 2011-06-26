#!/usr/bin/perl
################
# Run the program as follows:
# './randGen.pl (seed) (graph size) (increments) (filename)'
################

use strict;
use warnings;

my ($seedValue, $graphSize, $increments, $filename) = @ARGV;
my $id = 0;
my $weightSeed = 10;
open(DAT, ">$filename") || die("Cannot open file: " . $filename . "\n");

## Write default XML directives for the corresponding updml.
print DAT "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>\n";
print DAT "<?meta name=\"GENERATOR\" content=\"XML::SMART 1.3.1\" ?>\n";
print DAT "<updatesequence>\n";

while ($increments > 0) {	

	print DAT "\t<addnode id=\"" . $id++ . "\">\n";
	
	my $randVal = int(rand($seedValue)) + ($graphSize - 10);
	my $k1 = ((int(rand(100)) + 100) - $randVal) % $randVal;
	my $k2 = $randVal - $k1;
	
	while ($k1 > 0) {
		my $currNode = int(rand($graphSize));
		my $currWeight = int(rand($weightSeed)) + 1;
		print DAT "\t\t<fromedge nodename=\"" . $currNode . "\" weight=\"" . $currWeight . "\" />\n";
		$k1--; 
	} 


	while ($k2 > 0) {
		my $currNode = int(rand($graphSize));
		my $currWeight = int(rand($weightSeed)) + 1;
		print DAT "\t\t<toedge nodename=\"" . $currNode . "\" weight=\"" . $currWeight . "\" />\n";
		$k2--; 
	} 

	print DAT "\t</addnode>\n";

	$graphSize++;
	$increments--;
	print "k1 = " . $k1 . "\nk2 = " . $k2 . "\n"; 
}

print DAT "</updatesequence>\n";
close (DAT);
