if [ "$url_o" != "" ];
then
  url="$url_o"
fi

if [ "$dump" != "0" ];
then
  # trim whitespace from query
  say "    ${e}->${x} Dumping upload file (no upload)"
  echo "$url/upload/v4?$(echo "package=bash-$VERSION&token=$token&$query" | tr -d ' ')"
  cat "$upload_file"
else
  if [ "$save_to" != "" ];
  then
    say "${e}==>${x} Copying upload file to ${save_to}"
    cp "$upload_file" "$save_to"
  fi

  say "${e}==>${x} Gzipping contents"
  gzip -nf9 "$upload_file"

  query=$(echo "${query}" | tr -d ' ')
  say "${e}==>${x} Uploading reports"
  say "    ${e}url:${x} $url"
  say "    ${e}query:${x} $query"

  # Full query without token (to display on terminal output)
  queryNoToken=$(echo "package=bash-$VERSION&token=secret&$query" | tr -d ' ')
  # now add token to query
  query=$(echo "package=bash-$VERSION&token=$token&$query" | tr -d ' ')

  if [ "$ft_s3" = "1" ];
  then
    say "${e}->${x}  Pinging Codecov"
    say "$url/upload/v4?$queryNoToken"
    # shellcheck disable=SC2086,2090
    res=$(curl $curl_s -X POST $curlargs $cacert \
          --retry 5 --retry-delay 2 --connect-timeout 2 \
          -H 'X-Reduced-Redundancy: false' \
          -H 'X-Content-Type: application/x-gzip' \
          "$url/upload/v4?$query" || true)
    # a good reply is "https://codecov.io" + "\n" + "https://storage.googleapis.com/codecov/..."
    status=$(echo "$res" | head -1 | grep 'HTTP ' | cut -d' ' -f2)
    if [ "$status" = "" ] && [ "$res" != "" ];
    then
      s3target=$(echo "$res" | sed -n 2p)
      say "${e}->${x}  Uploading to"
      say "${s3target}"

      # shellcheck disable=SC2086
      s3=$(curl -fiX PUT $curlawsargs \
          --data-binary @"$upload_file.gz" \
          -H 'Content-Type: application/x-gzip' \
          -H 'Content-Encoding: gzip' \
          "$s3target" || true)

      if [ "$s3" != "" ];
      then
        say "    ${g}->${x} View reports at ${b}$(echo "$res" | sed -n 1p)${x}"
        exit 0
      else
        say "    ${r}X>${x} Failed to upload"
      fi
    elif [ "$status" = "400" ];
    then
        # 400 Error
        say "${g}${res}${x}"
        exit ${exit_with}
    fi
  fi

  say "${e}==>${x} Uploading to Server"

  # shellcheck disable=SC2086,2090
  res=$(curl -X POST $curlargs $cacert \
        --data-binary @"$upload_file.gz" \
        --retry 5 --retry-delay 2 --connect-timeout 2 \
        -H 'Content-Type: text/plain' \
        -H 'Content-Encoding: gzip' \
        -H 'X-Content-Encoding: gzip' \
        -H 'Accept: text/plain' \
        "$url/upload/v2?$query&attempt=$i" || echo 'HTTP 500')
  # HTTP 200
  # http://....
  status=$(echo "$res" | head -1 | cut -d' ' -f2)
  if [ "$status" = "" ] || [ "$status" = "200" ];
  then
    say "    View reports at ${b}$(echo "$res" | head -2 | tail -1)${x}"
    exit 0
  else
    say "    ${g}${res}${x}"
    exit ${exit_with}
  fi

  say "    ${r}X> Failed to upload coverage reports${x}"
fi

exit ${exit_with}
