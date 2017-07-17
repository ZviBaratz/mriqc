#!/bin/bash
#
# Balance nipype testing workflows across CircleCI build nodes
#

# Setting      # $ help set
set -e         # Exit immediately if a command exits with a non-zero status.
set -u         # Treat unset variables as an error when substituting.
set -x         # Print command traces before executing command.

# Exit if build_only tag is found
if [ "$(grep -qiP 'build[ _]?only' <<< "$GIT_COMMIT_MSG"; echo $? )" == "0" ]; then
    exit 0
fi

# Exit if docs_only tag is found
if [ "$(grep -qiP 'docs[ _]?only' <<< "$GIT_COMMIT_MSG"; echo $? )" == "0" ]; then
    echo "Building [docs_only], nothing to do."
    exit 0
fi

if [ "$CIRCLE_NODE_INDEX" == "0" ]; then
	echo "Testing the classifier"
	docker run -i -v $SCRATCH:/scratch -w /scratch \
	           --entrypoint="/usr/local/miniconda/bin/mriqc_clf" \
	           ${DOCKER_IMAGE}:${DOCKER_TAG} \
	           --load-classifier -X /scratch/out/T1w.csv -v
fi