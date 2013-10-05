<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
    </head>
    <body>
        <form action="uploadfile.php" method="post"
              enctype="multipart/form-data">
            <label for="file">Image: </label>
            <input type="file" name="file" id="file"><br>
            <input type="submit" name="submit" value="Submit">
        </form>
        <h2>UPLOADED IMAGES</h2>
        <div>
            <?php
                $files = scandir("uploadedimages/");
                foreach($files as $file){
                    if($file === '.' || $file === '..') {continue;} 
                    echo '<div>'.$file.'</div>';
                    echo '<img src="uploadedimages/'.$file.'" alt="some image" style="height:100px;">';
                    echo '<br>';
                }
            ?>
        </div>
    </body>
</html>
