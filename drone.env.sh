elif [ "$CI" = "drone" ] || [ "$DRONE" = "true" ];
then
  say "$e==>$x Drone CI detected."
  # http://docs.drone.io/env.html
  # drone commits are not full shas
  service="drone.io"
  branch="$DRONE_BRANCH"
  build="$DRONE_BUILD_NUMBER"
  build_url=$(urlencode "${DRONE_BUILD_LINK}")
  pr="$DRONE_PULL_REQUEST"
  job="$DRONE_JOB_NUMBER"
  tag="$DRONE_TAG"
