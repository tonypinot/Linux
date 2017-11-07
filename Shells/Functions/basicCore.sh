#!/bin/sh

#------------------------------------------------------------#
# FUNCTIONS
#------------------------------------------------------------#

function IsEmpty()
{
	value=$1
	label=$2

	if [[ -z $value ]]; then
		if [[ ! -z $label ]]; then echo "$label: NOK (Is empty!)"; fi
		true
	else		
		if [[ ! -z $label ]]; then echo "$label: OK ($value)"; fi
		false
	fi
}