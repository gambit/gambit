#! /usr/bin/awk -f

function array1( m ) {
		for (k = 0; k < 100; k++) {
			for (i = 0; i < m; i++) {
				x[i] = i 
			}
			for (n = m - 1; j >= 0; j--) {
				y[j] = x[j]
			}
		}
		return
}
BEGIN {
	array1( 200000 )
}
