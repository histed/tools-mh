#!/bin/bash

CLASSPATH="$CLASSPATH:$(echo /Users/histed/analysis/third-packages/poi-3.8/*.jar | tr ' ' ':')"
echo $CLASSPATH

javac -cp "$CLASSPATH" frm_jcReadXls.java

