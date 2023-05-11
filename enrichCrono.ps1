$delimitador = ";"
$result = ""
$inscritos = Get-Content -Raw i.json | ConvertFrom-Json
$inscritos