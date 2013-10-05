<?php

$allowedExts = array("gif", "jpeg", "jpg", "png");
$temp = explode(".", $_FILES["file"]["name"]);
$extension = end($temp);
if (in_array($extension, $allowedExts)) {
    if ($_FILES["file"]["error"] > 0) {
        echo "Return Code: " . $_FILES["file"]["error"] . "<br>";
        echo '<a href="index.php">Go back</a>';
    } else {
        echo "Upload: " . $_FILES["file"]["name"] . "<br>";
        echo "Type: " . $_FILES["file"]["type"] . "<br>";
        echo "Size: " . ($_FILES["file"]["size"] / 1024) . " kB<br>";
        echo "Temp file: " . $_FILES["file"]["tmp_name"] . "<br>";

        if (file_exists("uploadedimages/" . $_FILES["file"]["name"])) {
            echo $_FILES["file"]["name"] . " already exists. ";
        } else {
            move_uploaded_file($_FILES["file"]["tmp_name"], "uploadedimages/" . $_FILES["file"]["name"]);
            echo "Stored in: " . "uploadedimages/" . $_FILES["file"]["name"];
            echo "<br>";
            echo '<img src="uploadedimages/' . $_FILES["file"]["name"] . '" alt="uploadedimage">';
        }
        echo '<a href="index.php">Go back</a>';
    }
} else {
    echo "Invalid file";
}
?>

