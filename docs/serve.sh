#!/bin/bash

OpenBrowser () {
  	URL='http://localhost:4000'
  	python -mwebbrowser $URL
}



BASEDIR=$(dirname $0)
cd $BASEDIR\

awhile=2
sleep $awhile && OpenBrowser & 

jekyll serve 
