<?php

 

function get_config()
{
	$arr=array();
	$arr['active']=1; 
	$arr['req'] = array_merge($_GET, $_POST);
	$arr['rand_value']=rand(1000000, 9900000); 
	$arr['delete_files']=0; 

	$arr['dir_input']='./input/';
	$arr['dir_output']='./output/';
	$arr['dir_arhiv_in']='./arhive/in/';
	$arr['dir_arhiv_out']='./arhive/out/';
	$arr['file_name']=$arr['dir_arhiv_out'].'r'.$arr['rand_value'].'.zip';
	return $arr;
}

	$config=get_config();

	//снова создаем новый объект ZipArchive
	$zip = new ZipArchive;
	$res = $zip->open($config['file_name'], ZipArchive::CREATE);
	
	if (isset($config['req']['user_id']))
	{
		if (isset($config['req']['action']) and ($config['req']['action'] == 'put'))
		{
			 if ($_FILES["filename"]["size"] < 1024*3*1024) 
			 {
				 // Проверяем загружен ли файл
				if(is_uploaded_file($_FILES["filename"]["tmp_name"]))
			  	{

			    	 $get_file_name=$config['dir_arhiv_in'].$config['rand_value'].$_FILES["filename"]["name"];
			     	move_uploaded_file($_FILES["filename"]["tmp_name"], $get_file_name);
					
					$zip2 = new ZipArchive;
					$res = $zip2->open($get_file_name);
					if ($res === TRUE) {
					//обозначаем папку, в которую будет производится разархивирование 
					//если папка несуществует, она будет создана
					    $zip2->extractTo($config['dir_output']);
					    $zip2->close();
						if ($config['delete_files'] == 1) {unlink($get_file_name);}
						if (!isset($config['req']['order_id'])){$config['req']['order_id']=$config['rand_value'];}
						$zip->addFromString('message_'.$config['req']['user_id'].'_'.$config['req']['order_id'].'.xml', set_message('Файлы успешно переданы на сервер'));
					//если архив НЕ открылся
					} else {
						$zip->addFromString('message_'.$config['req']['user_id'].'_'.$config['rand_value'].'.xml', set_message('Ошибка  Не получилось из-за ошибки '.$res));
					    echo 'Не получилось из-за ошибки #'.$res; // где $res - код ошибки
					}
			   	}
			   	else {
			   		//echo "ssss";
			   		$zip->addFromString('message_'.$config['req']['user_id'].'_'.$config['rand_value'].'.xml', set_message('Ошибка  202 Ошибка загрузки файла'));
			   }
			 }
			 else {
				 	
			   
			 }
		}
		if (isset($config['req']['action']) and ($config['req']['action'] == 'get'))
		{
			if (isset($config['req']['get_price']) and ($config['req']['get_price'] == '1'))
			{
				$text2 = file_get_contents($config['dir_input']."data.csv");
				$zip->addFromString('data.csv', $text2);
				//$text2 = file_get_contents($config['dir_input']."polibase.csv");
				//$zip->addFromString('polibase.csv', $text2);
				$zip->addFromString('message_'.$config['req']['user_id'].'_'.$config['rand_value'].'.xml', set_message('Правйс листы получены!'));
			}
			//echo $config['file_name'];
			$mas_files=array();
		
			if ($config['req']['user_id'] == '55')
			{
				$user_id_old=$config['req']['user_id'];
				$config['req']['user_id']=get_user_id();
				$zip->addFromString('params_'.$user_id_old.'_'.$config['rand_value'].'.xml', set_parametrs('user_id',get_user_id('55')));
			}
			
		}
	}
	else{
		$zip->addFromString('message_'.$config['rand_value'].'_1.xls', set_message('Ошибка  100 не задан user_id'));
	}
	
	$zip->addFromString('version_'.$config['req']['user_id'].'.txt', set_message('Проверочный файл распаковки архива.'.$config['rand_value']));
	
	
	//Отправляем все файлы для этого клиента
	$mas_files=get_files_user_dir_input(array('string'=> '_'.$config['req']['user_id'].'_'),$config) ;
	foreach ($mas_files as $value) {
		$text2 = file_get_contents($config['dir_input'].$value);
		$zip->addFromString($value, $text2);
		//unlink($config['dir_input'].$value);
		//echo $value."string";
	}
	
	//закрываем работу с архивом
	$zip->close();
	 // Читаем содержимое
		  
	$text = file_get_contents($config['file_name']);
	header('Content-Type: application/zip');
	echo $text; 
	if ($config['delete_files'] == 1) {unlink($config['file_name']);}
		
function set_message($value)
{
	if ((strlen($value) >0) and 1)
	{
		return iconv('UTF-8', 'windows-1251', "<xml version=\"1.0\" encoding=\"windows-1251\">
			<message text=\"".$value."\" date=\"".date("Y-m-d H:i:s")."\">
			</Message>
			</xml>
	");
	}
	else {
		return 'no_params';
	}
}
function set_parametrs($name,$string)
{
	if ((strlen($name) >0) and (strlen($string) >0))
	{
		return "<xml version=\"1.0\" encoding=\"UTF-8\">
			<SetParam name=\"".$name."\" value=\"".$string."\">
			</SetParam>
			</xml>
	";
	}

}
function get_user_id($string)
{
	return "55";

}
function get_files_user_dir_input($arr_param,$config)
{
	if (!isset($config['active']))
	{
		$config=get_config();
	}
	if ($handle = opendir($config['dir_input'])) {  
    while (false !== ($file = readdir($handle))) {
        if ($file != "." && $file != "..") {
        	if ((isset($arr_param['string'])) and (strpos($file, $arr_param['string']) > 0))
			{
				$files[] = $file; 
			} 
					//echo $file."file".strpos($file, $arr_param['string']);
        }  

    }  
    closedir($handle);  
	}  
	return $files;
	
}

?>