#!/bin/sh
exec dhcp-helper -n -s "${IP:-NODATA}"
