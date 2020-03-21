#!/usr/bin/env bats

load test_helper

@test "Complain about init without title" {
	run pbb init
	((status == 1))
	want="usage: pbb init 'My blog title'"
	printf '%s\n%s\n' "got: $output" "want: $want"
	[[ $output == *$want* ]]
}

@test "Run init with simple title" {
	cd "$BATS_TEST_DIRNAME"/testdata
	run pbb init 'Testblog'
	echo "$output"
	((status == 0))

	# Git branch is "source"
	[[ $(git symbolic-ref -q --short HEAD) == 'source' ]]

	# Directories assets, images and includes exist
	[[ -d assets ]]
	[[ -d images ]]
	[[ -d includes ]]

	# Conf file contains title
	grep -qx 'blogtitle=Testblog' .pbbconfig

	# Header file contains title
	[[ $(< includes/header.html) == '<p><a href="./">Testblog</a></p>' ]]

	# TODO: check CSS file (requires installer)

	# Font links file exists
	fontlinks='includes/fontlinks.html'
	[[ -s $fontlinks ]]
	grep -Fq 'https://fonts.gstatic.com' "$fontlinks"
	grep -Fq 'https://fonts.googleapis.com' "$fontlinks"

	# Favicon header include exists
	favicon='includes/favicon.html'
	[[ -s $favicon ]]
	grep -Fq 'href="/favicon.png"' "$favicon"

	# Git history has one entry
	[[ $(git log --oneline) == *'Initialize blog with pbb' ]]

	# Example post exists
	printf -v fname '%(%F)T-my-first-post.md' -1
	[[ -s $fname ]]
	grep -Fq '# My first post' "$fname"
}

# TODO Run init with title that's complex to quote
# TODO Run init twice