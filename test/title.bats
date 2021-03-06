#!/usr/bin/env bats

load test_helper

@test "Complain about title without title" {
	run pbb title
	((status == 1))
	want="usage: pbb title 'My blog title'"
	printf '%s\n%s\n' "got: $output" "want: $want"
	[[ $output == *$want* ]]
}

@test "Change to simple title" {
	cd /tmp/pbb-testdata
	pbb init 'Testblog'
	run pbb title 'New Title'

	echo "$output"
	((status == 0))

	# Conf file contains new title
	grep -Fqx 'blogtitle=New\ Title' .pbbconfig

	# Header file contains title
	[[ $(< includes/header.html) == '<p><a href="./">New Title</a></p>' ]]
}

@test "Change to title with quotes" {
	cd /tmp/pbb-testdata
	pbb init 'Testblog'
	run pbb title "Example Man's \"Blog\""

	echo "$output"
	((status == 0))

	# Conf file contains new title
	cat .pbbconfig
	grep -Fqx "blogtitle=Example\ Man\'s"'\ \"Blog\"' .pbbconfig

	# Header file contains title
	cat includes/header.html
	grep -q 'Example Man.s.*Blog' includes/header.html
}

@test "Change title without quoting parameters" {
	cd /tmp/pbb-testdata
	pbb init 'Testblog'
	run pbb title New Title   without    Quotes

	echo "$output"
	((status == 0))

	# Conf file contains new title
	grep -Fqx 'blogtitle=New\ Title\ without\ Quotes' .pbbconfig

	# Header file contains title
	[[ $(< includes/header.html) == '<p><a href="./">New Title without Quotes</a></p>' ]]
}
