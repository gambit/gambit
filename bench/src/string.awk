#! /usr/bin/awk -f

function string( m ) {
	for (i = 0; i < 10; i++) {
		s = "abcdef"
		while (length( s  ) <= m) {
			s = "123" s "456" s "789"
			s_length = length( s )
			s = substr( s, s_length / 2 ) substr( s, 1, s_length / 2 )
		}
	}
	return length( s )
}
BEGIN {
	string( 500000 )
}
