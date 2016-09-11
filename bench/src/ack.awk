#! /usr/bin/awk -f

function ack( m, n ) {
	if (m == 0) {
		return_value = n + 1 
	} else if (n == 0) {
		return_value = ack( m - 1, 1)
	} else {
		return_value = ack( m - 1, ack( m, n - 1) )
	}
	return return_value
}
BEGIN {
	ack( 3, 9 )
}
