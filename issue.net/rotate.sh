#!/bin/bash
files=(/opt/issue.net/*.net)
cp "${files[RANDOM % ${#files[@]}]}" /etc/issue.net
