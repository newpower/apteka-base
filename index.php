<html>
<head>
  <title>Загрузка файлов на сервер</title>
</head>
<body>
      <h2><p><b> Форма для загрузки файлов </b></p></h2>
      <form action="obmen.php" method="post" enctype="multipart/form-data">
      <input type="file" name="filename"><br> 
      <input type="text" name="action" value="get"><br> 
      <input type="text" name="user_id" value="55"><br> 
      
      <input type="submit" value="Ok"><br>
      </form>
</body>
</html>