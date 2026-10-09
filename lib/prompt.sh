#!/usr/bin/env bash
# Fill a template: ocd prompt <plan|crossreview|tickets|ticket|fix> key=value ...
. "$OCD_HOME/lib/common.sh"; ocd_load
ocd_fill "$@"
