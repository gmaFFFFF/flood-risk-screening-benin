# Укажите путь к папке llm_raw_generation. 
# Если скрипт лежит в той же папке, можно оставить значение "." (текущая директория)
$targetFolder = "."

# Текст дисклеймера
$disclaimer = @"
> [!Warning] Не верифицированные материалы. 
> Файл был сгенерирован большой языковой моделью (LLM Gemini) и может содержать ошибки.
> **Автор не проверял файл.**
> LLM могла убедительно выдумать несуществующие факты и взаимосвязи, исказить или забыть реальные факты, обоснование.
> Используйте файл исключительно в ознакомительных целях и перепроверяйте каждый тезис.
> С авторским виденьем можно ознакомиться в заметках или плане отчета [plan_report_draft.md](30_report_drafts/plan_report_draft.md).


"@

# Создаем экземпляр кодировки UTF-8 БЕЗ вывода BOM ($false указывает не излучать сигнатуру)
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($false)

# Поиск всех .md файлов во всех подпапках, исключая сам файл дисклеймера _DISCLAIMER.md
$mdFiles = Get-ChildItem -Path $targetFolder -Filter "*.md" -Recurse | Where-Object { $_.Name -ne "_DISCLAIMER.md" }

Write-Host "Найдено файлов для обработки: $($mdFiles.Count)" -ForegroundColor Cyan

foreach ($file in $mdFiles) {
    try {
        # Чтение текущего содержимого файла (сохраняя исходную кодировку)
        $currentContent = Get-Content -Raw -Path $file.FullName -Encoding utf8
        
        # Проверка, чтобы случайно не добавить дисклеймер повторно
        if ($currentContent -like "*[!Warning] Не верифицированные материалы*") {
            Write-Host "Пропущен (уже содержит дисклеймер): $($file.FullName)" -ForegroundColor Yellow
            continue
        }

        # Объединение дисклеймера и старого содержимого
        $newContent = $disclaimer + $currentContent

        # Перезапись файла с использованием кодировки БЕЗ BOM
        [System.IO.File]::WriteAllText($file.FullName, $newContent, $Utf8NoBomEncoding)
        
        Write-Host "Обработан: $($file.FullName)" -ForegroundColor Green
    }
    catch {
        Write-Error "Ошибка при обработке файла $($file.FullName): $_"
    }
}

Write-Host "Обработка завершена." -ForegroundColor Cyan