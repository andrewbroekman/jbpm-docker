#!/bin/bash

sed -i \
	-e "s@KC_KIE_GIT_SECRET@$KC_KIE_GIT_SECRET@" \
	-e "s@KC_BASE_URL@$KC_BASE_URL@" \
	-e "s@KC_REALM@$KC_REALM@" \
	/opt/jboss/wildfly/standalone/configuration/kie-git.json
