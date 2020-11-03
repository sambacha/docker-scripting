elif [ "$CI" = "true" ] && [ "$CIRCLECI" = "true" ];
then
  say "$e==>$x Circle CI detected."
  # https://circleci.com/docs/environment-variables
  service="circleci"
  branch="$CIRCLE_BRANCH"
  build="$CIRCLE_BUILD_NUM"
  job="$CIRCLE_NODE_INDEX"
  if [ "$CIRCLE_PROJECT_REPONAME" != "" ];
  then
    slug="$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME"
  else
    # git@github.com:owner/repo.git
    slug="${CIRCLE_REPOSITORY_URL##*:}"
    # owner/repo.git
    slug="${slug%%.git}"
  fi
  pr="$CIRCLE_PR_NUMBER"
  commit="$CIRCLE_SHA1"
  search_in="$search_in $CIRCLE_ARTIFACTS $CIRCLE_TEST_REPORTS"