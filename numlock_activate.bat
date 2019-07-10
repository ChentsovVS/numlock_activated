rem тест проверка автоматизации изменения ключей в реестре с помощью PS (в нашем случае - установка автовключения numlock)
rem приходится делать так, что бы не нарушать безопасность ОС 
rem поскольку скрипты ps изначально заблокированны в ОС 
rem по логике - создаем директории, назначаем переменные, делаем проверку значения и если оно верно - меняем 

chcp 65001>nul
SetLocal EnableDelayedExpansion

mkdir c:\temp\
mkdir c:\temp\numlock_active\
echo %date% > c:\temp\numlock_active\log.txt
echo %date% > c:\temp\numlock_active\buffer.txt
echo %date% > c:\temp\numlock_active\tmp.txt 
echo %date% > c:\temp\numlock_active\after_setting.txt

set log=c:\temp\numlock_active\log.txt
set task_dir=c:\temp\numlock_active\
set buffer=c:\temp\numlock_active\buffer.txt
set tmp=c:\temp\numlock_active\tmp.txt
set after_setting=c:\temp\numlock_active\after_setting.txt
set HKCU_Path='HKCU:\Control Panel\Keyboard'
set name_edit_table=InitialKeyboardIndicators

powershell.exe Get-ItemProperty -Path %HKCU_Path% -Name %name_edit_table%  > %tmp% 2>> %log% 

findstr "0" %tmp% > %buffer% 2>> %log% 

set /p numlock= < %buffer%


	
	IF "%numlock%"=="" (
		echo %date% & echo %time% & echo "Numlock activated before" >> %log%
		break
		
		
	) ELSE (	
		powershell.exe Set-ItemProperty -Path %HKCU_Path% -Name %name_edit_table% -Value 2 2>> %log%
		powershell.exe Get-ItemProperty -Path %HKCU_Path% -Name %name_edit_table% > %after_setting% 2>> %log% 
		echo "numlock active now, details see in after_setting" >> %log%
		break
		)
del /Q %buffer%
del /Q %tmp%


rem log - файл "аля" лога где будет основная инфа, task_dir - рабочая директория 
rem buffer - необходим для сохранения значения и последующей передаче в переменную 
rem tmp - временный файл для поиска значения, after_setting - последняя проверка значений (вручную - зайти и посмотреть) 
rem numlock - передача итоговых значений (после поиска) в переменную для работы if\else 
rem HKCU_Path - путь в реестре до каталога, name_edit_table - имя изменяемой таблицы 
rem отказался от перехода вреестре, буду делать напрямую пимер 37 строка. и добавил очистку лишнего 
