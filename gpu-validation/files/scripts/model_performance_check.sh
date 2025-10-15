#!/bin/bash

URL="${URL:-http://localhost:8000}"
MODEL_NAME="${MODEL_NAME:-TinyLlama/TinyLlama-1.1B-Chat-v1.0}"
TOKEN="${TOKEN:-}"

function do_curl {
    if [ "$1" == "chat" ]; then
        local curl_args=(
            -k -s --show-error -f -X POST "${URL}/v1/chat/completions"
            -H "Content-Type: application/json"
        )
        if [ -n "$TOKEN" ]; then
            curl_args+=(-H "Authorization: Bearer $TOKEN")
        fi
        curl_args+=(--data '{"model": "'"${MODEL_NAME}"'","messages": [{"role": "user","content": "Who am I speaking to?"}]}')
        CURL_OUTPUT=$(curl "${curl_args[@]}")
    elif [ "$1" == "metrics" ]; then
        CURL_OUTPUT=$(curl -k -s --show-error -f "${URL}/metrics")
    fi
    # shellcheck disable=SC2181
    if [ $? -ne 0 ]; then
        exit 1
    fi
}

for ((i=1; i<=5; i++))
do
    do_curl "chat"
done

do_curl "metrics"

TIME_PER_TOK_SUM=$(echo "${CURL_OUTPUT}" | grep vllm:time_per_output_token_seconds_sum\{ | cut -d ' ' -f 2)
TIME_PER_TOK_COUNT=$(echo "${CURL_OUTPUT}" | grep vllm:time_per_output_token_seconds_count\{ | cut -d ' ' -f 2)

TIME_FIRST_TOK_SUM=$(echo "${CURL_OUTPUT}" | grep vllm:time_to_first_token_seconds_sum\{ | cut -d ' ' -f 2)
TIME_FIRST_TOK_COUNT=$(echo "${CURL_OUTPUT}" | grep vllm:time_to_first_token_seconds_count\{ | cut -d ' ' -f 2)

AVG_TIME_PER_TOK=$(python -c "print(round($TIME_PER_TOK_SUM / $TIME_PER_TOK_COUNT, 4))")
AVG_TIME_TO_FIRST_TOK=$(python -c "print(round($TIME_FIRST_TOK_SUM / $TIME_FIRST_TOK_COUNT, 4))")


echo "{\"avg_time_per_tok\": \"${AVG_TIME_PER_TOK}\", \"avg_time_to_first_tok\": \"${AVG_TIME_TO_FIRST_TOK}\"}"
