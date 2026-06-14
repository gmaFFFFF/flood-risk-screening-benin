$basePath = (Get-Item .).FullName
$exportPath = Join-Path $basePath "export"

Write-Host "Начинаем поиск и конвертацию markdown-файлов..." -ForegroundColor Cyan

Get-ChildItem -Path $basePath -Filter "*.md" -Recurse -File | ForEach-Object {
    $filePath = $_.FullName
    $relativePath = $filePath.Substring($basePath.Length + 1)
    
    if ($relativePath -notmatch '^export\\' -and $relativePath -notmatch '(^|\\)\.') {
        
        $outRelativePath = $relativePath -replace '\.md$', '.docx'
        $outPath = Join-Path $exportPath $outRelativePath
        
        $outDir = Split-Path $outPath -Parent
        if (-not (Test-Path $outDir)) {
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
        }
        
        Write-Host "Конвертирую: $relativePath -> $outRelativePath"
        
        # 1. Читаем файл в строгом UTF-8, чтобы избежать "кракозябр"
		$utf8 = [System.Text.Encoding]::UTF8
		$content = [System.IO.File]::ReadAllText($filePath, $utf8)

		# 2. Конвертируем ссылки Obsidian в стандартный Markdown, очищая их от якорей (#) и %20
		$content = [regex]::Replace($content, '!\[\[([^|\]]+)(?:\|[^\]]+)?\]\]', {
			param($match)
			$imagePath = $match.Groups[1].Value
			
			# 1. Отрезаем всё, начиная с символа # (включая его)
			$imagePath = $imagePath -replace '#.*$', ''
			
			# 2. Заменяем %20 обратно на обычные пробелы
			$imagePath = $imagePath -replace '%20', ' '
			
			return "![]($imagePath)"
		})
		
		# Защита от исчезновения строк вида [[Текст]]: URL
		$content = $content -replace '\]\]\s*:', ']]\:'

		# 3. Генерируем имя временного файла (.md)
		$tempFile = [System.IO.Path]::GetTempFileName() -replace '\.tmp$', '.md'

		# 4. Сохраняем временный файл в строгом UTF-8 без BOM (Byte Order Mark)
		$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
		[System.IO.File]::WriteAllText($tempFile, $content, $utf8NoBom)
        
        # Получаем пути для поиска картинок
        $currentFileDir = Split-Path $filePath -Parent
        $resourcesDir = Join-Path $currentFileDir "_resources"
        $pandocResourcePaths = "$resourcesDir;$currentFileDir;$basePath"
        
        # Добавляем параметр -f markdown, чтобы Pandoc точно знал формат
        $pandocArgs = @(
            "-f", "markdown",
            "`"$tempFile`"", 
            "-o", "`"$outPath`"",
            "--resource-path=`"$pandocResourcePaths`"" 
        )
        
        # Запускаем Pandoc и перехватываем процесс (-PassThru)
        $process = Start-Process -FilePath "pandoc" -ArgumentList $pandocArgs -NoNewWindow -PassThru
        
        try {
            # Ждем максимум 30 секунд
            $process | Wait-Process -Timeout 30 -ErrorAction Stop
        } catch {
            Write-Host "  [!] ОШИБКА: Зависание при обработке (возможно, не удалось скачать внешнюю картинку). Пропускаю..." -ForegroundColor Red
            # Принудительно убиваем зависший процесс
            if (-not $process.HasExited) {
                Stop-Process -Id $process.Id -Force
            }
        }
        
        # Удаляем временный файл
        Remove-Item -Path $tempFile -Force
    }
}

Write-Host "Готово! Экспорт завершен." -ForegroundColor Green