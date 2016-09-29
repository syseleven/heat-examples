<html>
<head>
<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type"><title>Home</title>
<link href='https://fonts.googleapis.com/css?family=Poiret One' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
</head>
<body>

<div class=container>
<div class=page-header>
<div style="font-family: Poiret One; font-size: 1.5em; letter-spacing: 0.3em;">

<?php
echo "<br>";
echo "<h1> AnyApp </h1>";
echo "<br>";
session_start();
echo "<br>";
if (isset($_SESSION['upstream-servers'])) {
  if (strpos($_SESSION['upstream-servers'], $_SERVER['SERVER_ADDR']) !== false) {
  } else {
  	$_SESSION['upstream-servers'] = $_SERVER["SERVER_ADDR"]." ".$_SESSION['upstream-servers'];
  }
} else {
  	$_SESSION['upstream-servers'] = $_SERVER["SERVER_ADDR"]." ";
}
if (isset($_SESSION['upstream-servers'])) {
  echo "<br>";
  echo "Upstream server list:<br>".$_SESSION['upstream-servers'];
}
echo "<br>";
echo "<br>";
echo "Backend server ".$_SERVER["SERVER_ADDR"];
echo "<br>";

?>

</div>
</div>
</div>
</body>
</html>



