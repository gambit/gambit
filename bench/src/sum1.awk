#! /usr/bin/awk -f

function sum1( file1 ) {
	while (1 == (getline < file1)) {
		return_value += $1
	}
	return return_value
}
BEGIN {
	sum1( "../../src/rn100" )
}
