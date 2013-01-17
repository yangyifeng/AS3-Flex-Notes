<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
</head>

<body>
<form action="" method="post" enctype="multipart/form-data" name="form1" id="form1">
  <label>
  <input type="file" name="Filedata" />
  </label>
  <label>
  <input type="submit" name="Submit" value="提交" />
  </label>
</form>


<?php
if(isset($_FILES["Filedata"]["tmp_name"]) && $_FILES["Filedata"]["tmp_name"] != '')
{
	move_uploaded_file($_FILES["Filedata"]["tmp_name"], "upload/" . $_FILES["Filedata"]["name"]);	
	echo "success";
}
?>
</body>
</html>
