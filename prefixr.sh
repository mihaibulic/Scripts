#/bin/bash

val='body { width:100%; border:1px red solid; }'

curl -sSd "css=${val}" "http://www.prefixr.com/api/index.php"


