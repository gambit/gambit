#! /usr/bin/awk -f

function tail( file1, file2 ) {
	i = 0
	while (1 == (getline < file1)) {
		file_array[i] = $0
		i++
	}
	i--
	while (i >= 0) {
		print file_array[i] > file2
		i--
	}
	return
}
BEGIN {
	tail( "../../src/bib", "foo" )
}
