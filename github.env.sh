elif [ "$GITHUB_ACTIONS" != "" ];
then
  say "$e==>$x GitHub Actions detected."

  # https://github.com/features/actions
  service="github-actions"

  # https://help.github.com/en/articles/virtual-environments-for-github-actions#environment-variables
  branch="${GITHUB_REF#refs/heads/}"
  if [  "$GITHUB_HEAD_REF" != "" ];
  then
    # PR refs are in the format: refs/pull/7/merge
    pr="${GITHUB_REF#refs/pull/}"
    pr="${pr%/merge}"
    branch="${GITHUB_HEAD_REF}"
  fi
  commit="${GITHUB_SHA}"
  slug="${GITHUB_REPOSITORY}"
  build="${GITHUB_RUN_ID}"
  build_url=$(urlencode "http://github.com/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}")
