#!/bin/sh -f

# microphone testing
function test_mic {
	arecord -vv -f dat /dev/null
}
