#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
rsync --checksum -a --delete -v --exclude .git --exclude .nojekyll $DIR/_build/html/ $DIR/../site/
