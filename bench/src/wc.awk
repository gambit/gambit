#! /usr/bin/awk -f

function wc( file1 ) {
	while (1 == (getline < file1)) {
		nl++
		nw += NF
		nc += length( $0 ) + 1
	}
	return
}
BEGIN {
	wc( "../../src/bib" )
}
