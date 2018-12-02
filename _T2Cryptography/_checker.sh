#!/bin/bash

set -e -u -o pipefail

uut="./tema2" # Unit under test, aka homework
input_dir="./inputs"
output_dir="./outputs-sha"
scores_file="${input_dir}/scores.txt"
total_score=0
max_score=0

printf "%s Tema 2 IOCLA %s\n" \
	"$(printf '%.s=' $(seq 1 30))" \
	"$(printf '%.s=' $(seq 45 75))"

while IFS=' ' read -r task input output score; do

	printf "Task %2s %s " "${task}" "$(printf '%.s.' $(seq 1 60))"

	max_score=$((${max_score} + ${score}))

	# Run the unit under test
	ln -sf "${input_dir}/${input}" .
	stdout=$(${uut} ${task} || :) # Do not fail if homework fails
	rm -f "${input}" # the symlink

	#echo "${stdout}" | sha256sum | awk '{ print $1}' > ${output}
	echo "${stdout}" | sha256sum | awk '{ print $1}' > ${output}
	# Compare hashed output of uut with reference hash
	diff "${output}" "${output_dir}/${output}" > /dev/null && {
		printf "passed\n"
		# Gain the score for this task
		total_score=$((${total_score} + ${score}))
	} || {
		printf "failed\n"
	}

	rm "${output}" # Cleanup
done < "${scores_file}"

printf "%75s\n" "Result: ${total_score}/${max_score}"

