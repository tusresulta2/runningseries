$min = "3:30"
$max = "9:36"
$startAt = New-TimeSpan -Days 0 -Hours 8 -Minutes 30
$PKs = @(
	'0:',
	'1:',
	'2:',
	'3:',
	'4:',
	'5:',
	'6:',
	'7: Avituallamiento 1 SOLO AGUA',
	'8:',
	'9:',
	'10:',
	'11: Avituallamiento 2',
	'12:',
	'13:',
	'14:',
	'15:',
	'15.8: 1 Voluntario CRUCE',
	'16:',
	'16.2: Avituallamiento 3',
	'17:',
	'17.8: 2 Voluntarios CRUCE',
	'18: CARRETERA COMPLICADA',
	'19:',
	'20:',
	'20.1: 2 Voluntarios CRUCE',
	'20.5: 1 Voluntario ARROYO',
	'21:',
	'22:',
	'22.7: CONTROL + 1 Voluntario Avituallamiento 4',
	'23:',
	'24:',
	'25:',
	'25.4: 1 Voluntario - CRUCE camino menor/calle',
	'26:',
	'26.5: 2 Voluntarios - CRUCE + Avituallamiento 5 SOLO AGUA',
	'27:',
	'28:',
	'29:',
	'30:',
	'31:',
	'32:',
	'33:',
	'33.2: 2 Voluntarios - CRUCE + Avituallamiento 6',
	'34:',
	'35:',
	'36:',
	'36.7: CONTROL + 1 Voluntario Avituallamiento 7',
	'37:',
	'38:',
	'38.4: 2 voluntarios - CRUCE',
	'38.9: 1 voluntario - ENTRADA Via',
	'39:',
	'40:',
	'41:',
	'42:',
	'42.9: 2 Voluntarios - CRUCE + Avituallamiento 8'
	'43:',
	'44:',
	'45:',
	'46:',
	'47:',
	'47.3: 1 Voluntario - Avituallamiento 9 SOLO AGUA',
	'48:',
	'49:',
	'49.3: 1 Voluntario - CONTROL Relevos',
	'50:'
)

$minSecs = ([int]($min.Split(":")[0]))*60 + ([int]($min.Split(":")[1]))
$maxSecs = ([int]($max.Split(":")[0]))*60 + ([int]($max.Split(":")[1]))

write "Punto;Tiempo primero;Tiempo corte;Hora primero;Hora corte" 
$PKs | Foreach-Object { 
	$km = [double]($_.Split(":")[0])
	$info = "PK" + $km + $_.Split(":")[1]
	$totalTimeMin = ("{0:hh\:mm\:ss}" -f [timespan]::fromseconds($km*$minSecs))
	$totalTimeMax = ("{0:hh\:mm\:ss}" -f [timespan]::fromseconds($km*$maxSecs))
	
	$hourMin = ("{0:hh\:mm\:ss}" -f ( $startAt + [timespan]::fromseconds($km*$minSecs) ))
	$hourMax = ("{0:hh\:mm\:ss}" -f ( $startAt + [timespan]::fromseconds($km*$maxSecs) ))
	
	write "$info;$totalTimeMin;$totalTimeMax;$hourMin;$hourMax" 
}