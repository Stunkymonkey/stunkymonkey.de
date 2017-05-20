#!/bin/bash

BASE=$(dirname $(readlink -f $0))

{
	cat <<-END
	<!DOCTYPE HTML>
	<html>
	<head>
	<title>stunkymonkey</title>
	 <meta charset="utf-8">
	<meta name="author" content="stunkymonkey">
	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
	<meta name="viewport" content="initial-scale=1">
	<style type="text/css">
	END

	cat style.css

	cat <<-END
	</style>
	</head>
	<body>
	<div class="card">
	END

	markdown README.md

	cat <<- END
	</div>
	</body>
	</html>
	END
} > $BASE/index.html
