#! /usr/bin/awk -f

function cat( file1, file2 ) {
	while (1 == (getline < file1)) {
		print $0 > file2
	}
	return
}
BEGIN {
	cat( "../../src/bib", "foo" )
}
