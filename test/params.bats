#!/usr/bin/env bats

@test "Complain about no subcommand" {
	run pbb
	((status == 1))
	want='usage: pbb'
	printf '%s\n%s\n' "got: $output" "want: $want"
	[[ $output == *$want* ]]
}

@test "Complain about non-existent subcommand" {
	run pbb foo
	((status == 1))
	want='usage: pbb'
	printf '%s\n%s\n' "got: $output" "want: $want"
	[[ $output == *$want* ]]
}

@test "Complain about init without title" {
	run pbb init
	((status == 1))
	want="usage: pbb init 'My blog title'"
	printf '%s\n%s\n' "got: $output" "want: $want"
	[[ $output == *$want* ]]
}

@test "Complain about title without title" {
	run pbb title
	((status == 1))
	want="usage: pbb title 'My blog title'"
	printf '%s\n%s\n' "got: $output" "want: $want"
	[[ $output == *$want* ]]
}