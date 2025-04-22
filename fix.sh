#!/bin/bash
sudo echo "\
# This profile allows everything and only exists to give the
# application a name instead of having the label "unconfined"

abi <abi/4.0>,
include <tunables/global>

profile burp-browser @{HOME}/BurpSuiteCommunity/burpbrowser/*/chrome flags=(unconfined) {
userns,

# Site-specific additions and overrides. See local/README for details.
include if exists <local/burpbrowser>
}" > /etc/apparmor.d/burpbrowser \
&& sudo apparmor_parser -r /etc/apparmor.d/burpbrowser \
&& echo "Fix applied!"