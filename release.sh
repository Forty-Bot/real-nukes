#!/bin/bash
VERSION=$(git describe --abbrev=0 --tags)
git archive --format zip --prefix "real-nukes_$VERSION/" -o "real-nukes_$VERSION.zip" "$VERSION"
