#! /usr/bin/awk -f

function sumloop( m ) {
	for (i = 0; i < m; i++) {
		return_value++
	}
	return return_value
}
BEGIN {
	sumloop( 100000000 )
}
