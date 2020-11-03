yaml=$(cd "$git_root" && \
          git ls-files "*codecov.yml" "*codecov.yaml" 2>/dev/null \
       || hg locate "*codecov.yml" "*codecov.yaml" 2>/dev/null \
       || cd "$proj_root" && find . -maxdepth 1 -type f -name '*codecov.y*ml' 2>/dev/null \
       || echo '')
yaml=$(echo "$yaml" | head -1)

if [ "$yaml" != "" ];
then
  say "    ${e}Yaml found at:${x} $yaml"
  if [[ "$yaml" != /* ]]; then
    # relative path for yaml file given, assume relative to the repo root
    yaml="$git_root/$yaml"
  fi
  config=$(parse_yaml "$yaml" || echo '')

  # TODO validate the yaml here

  if [ "$(echo "$config" | grep 'codecov_token="')" != "" ] && [ "$token" = "" ];
  then
    say "${e}-->${x} token set from yaml"
    token="$(echo "$config" | grep 'codecov_token="' | sed -e 's/codecov_token="//' | sed -e 's/"\.*//')"
  fi

  if [ "$(echo "$config" | grep 'codecov_url="')" != "" ] && [ "$url_o" = "" ];
  then
    say "${e}-->${x} url set from yaml"
    url_o="$(echo "$config" | grep 'codecov_url="' | sed -e 's/codecov_url="//' | sed -e 's/"\.*//')"
  fi

  if [ "$(echo "$config" | grep 'codecov_slug="')" != "" ] && [ "$slug_o" = "" ];
  then
    say "${e}-->${x} slug set from yaml"
    slug_o="$(echo "$config" | grep 'codecov_slug="' | sed -e 's/codecov_slug="//' | sed -e 's/"\.*//')"
  fi
else
  say "    ${g}Yaml not found, that's ok! Learn more at${x} ${b}http://docs.codecov.io/docs/codecov-yaml${x}"
fi

if [ "$branch_o" != "" ];
then
  branch=$(urlencode "$branch_o")
else
  branch=$(urlencode "$branch")
fi

if [ "$slug_o" = "" ];
then
  urlencoded_slug=$(urlencode "$slug")
else
  urlencoded_slug=$(urlencode "$slug_o")
fi

query="branch=$branch\
       &commit=$commit\
       &build=$([ "$build_o" = "" ] && echo "$build" || echo "$build_o")\
       &build_url=$build_url\
       &name=$(urlencode "$name")\
       &tag=$([ "$tag_o" = "" ] && echo "$tag" || echo "$tag_o")\
       &slug=$urlencoded_slug\
       &service=$service\
       &flags=$flags\
       &pr=$([ "$pr_o" = "" ] && echo "${pr##\#}" || echo "${pr_o##\#}")\
       &job=$job\
       &cmd_args=$(IFS=,; echo "${codecov_flags[*]}")"
