#!/bin/sh

#  generate_docs.sh
#  DonkeyKong
#
#  Created by Travis Pell on 05/05/2020.
#  Copyright © 2020 Travis Pell. All rights reserved.
dependencyDocs=$(sourcekitten doc -- -workspace WorkSpace.xcworkspace -scheme Physics)
frameworkDocs=$(sourcekitten doc -- -workspace WorkSpace.xcworkspace -scheme DonkeyKong)
echo ${dependencyDocs%?}','${frameworkDocs:1} > kitty.json
jazzy --sourcekitten-sourcefile kitty.json
