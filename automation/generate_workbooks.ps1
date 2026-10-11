$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$project = Split-Path -Parent $PSScriptRoot

function ConvertTo-ExcelColumn([int]$Number) {
    $name = ''
    while ($Number -gt 0) {
        $remainder = ($Number - 1) % 26
        $name = [char](65 + $remainder) + $name
        $Number = [math]::Floor(($Number - 1) / 26)
    }
    return $name
}

function Write-Utf8NoBom([string]$Path, [string]$Content) {
    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.UTF8Encoding]::new($false))
}

function Join-Row([string[]]$Cells) {
    return [string]::Join([char]9, $Cells)
}

function New-Workbook([string]$FileName, [string]$SheetName, [string]$Headers, [string[]]$Rows) {
    $temp = Join-Path $env:TEMP ([guid]::NewGuid().ToString('N'))
    $null = New-Item -ItemType Directory -Path (Join-Path $temp 'xl/worksheets') -Force
    $null = New-Item -ItemType Directory -Path (Join-Path $temp 'xl/_rels') -Force
    $null = New-Item -ItemType Directory -Path (Join-Path $temp '_rels') -Force

    Write-Utf8NoBom (Join-Path $temp '[Content_Types].xml') '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/><Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/></Types>'
    Write-Utf8NoBom (Join-Path $temp '_rels/.rels') '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>'
    $workbookXml = "<?xml version=`"1.0`" encoding=`"UTF-8`" standalone=`"yes`"?><workbook xmlns=`"http://schemas.openxmlformats.org/spreadsheetml/2006/main`" xmlns:r=`"http://schemas.openxmlformats.org/officeDocument/2006/relationships`"><sheets><sheet name=`"$SheetName`" sheetId=`"1`" r:id=`"rId1`"/></sheets></workbook>"
    Write-Utf8NoBom (Join-Path $temp 'xl/workbook.xml') $workbookXml
    Write-Utf8NoBom (Join-Path $temp 'xl/_rels/workbook.xml.rels') '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/></Relationships>'

    $xml = [System.Text.StringBuilder]::new()
    [void]$xml.Append('<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>')
    $allRows = @($Headers) + @($Rows)
    $rowNumber = 0
    foreach ($row in $allRows) {
        $rowNumber++
        [void]$xml.Append("<row r=`"$rowNumber`">")
        $columnNumber = 0
        foreach ($value in ([string]$row).Split([char]9)) {
            $columnNumber++
            $address = (ConvertTo-ExcelColumn $columnNumber) + $rowNumber
            $escaped = [System.Security.SecurityElement]::Escape([string]$value)
            [void]$xml.Append("<c r=`"$address`" t=`"inlineStr`"><is><t xml:space=`"preserve`">$escaped</t></is></c>")
        }
        [void]$xml.Append('</row>')
    }
    [void]$xml.Append('</sheetData></worksheet>')
    Write-Utf8NoBom (Join-Path $temp 'xl/worksheets/sheet1.xml') $xml.ToString()

    $output = Join-Path $project (Join-Path 'documentation' $FileName)
    if (Test-Path $output) { Remove-Item $output -Force }
    $archive = [System.IO.Compression.ZipFile]::Open($output, [System.IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($file in Get-ChildItem $temp -Recurse -File) {
            $entryName = $file.FullName.Substring($temp.Length).TrimStart('\', '/') -replace '\\', '/'
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $entryName) | Out-Null
        }
    }
    finally {
        $archive.Dispose()
    }
    Remove-Item $temp -Recurse -Force
}

$scenarios = @()
$scenarios += (Join-Row @('SCN-001','REQ-001','Registered customer signs in with valid credentials','High','Positive'))
$scenarios += (Join-Row @('SCN-002','REQ-001','Sign-in is rejected for invalid credentials','High','Negative'))
$scenarios += (Join-Row @('SCN-003','REQ-002','Search returns matching product names','High','Positive'))
$scenarios += (Join-Row @('SCN-004','REQ-002','Search with no matches presents an empty result','Medium','Boundary'))
$scenarios += (Join-Row @('SCN-005','REQ-003','Customer adds a product to the cart','High','Positive'))
$scenarios += (Join-Row @('SCN-006','REQ-003','Customer removes a product from the cart','Medium','Positive'))
$scenarios += (Join-Row @('SCN-007','REQ-004','Cart total reflects product quantity and price','High','Positive'))
$scenarios += (Join-Row @('SCN-008','REQ-005, REQ-006','Customer completes checkout and receives confirmation','High','End-to-end'))
$scenarios += (Join-Row @('SCN-009','REQ-007','Order submission preserves non-negative inventory','High','Data integrity'))
$scenarios += (Join-Row @('SCN-010','REQ-008','Sensitive credentials and payment values are not exposed','High','Security'))

$cases = @()
$cases += (Join-Row @('TC-001','SCN-001','Valid customer login','Pre-created test account; TEST_EMAIL and TEST_PASSWORD configured','Open login; enter valid email and password; submit','Customer is authenticated and account indicator is visible','High'))
$cases += (Join-Row @('TC-002','SCN-002','Invalid customer login','None','Open login; enter invalid credentials; submit','Login is rejected with an error; customer remains signed out','High'))
$cases += (Join-Row @('TC-003','SCN-003','Search for an existing product','Product catalog is available','Open products; search for Blue Top','At least one result is shown and each displayed name matches the term','High'))
$cases += (Join-Row @('TC-004','SCN-004','Search for an unknown product','Product catalog is available','Search for a unique nonexistent product name','No product cards are returned and the empty state is shown','Medium'))
$cases += (Join-Row @('TC-005','SCN-005','Add a searched product to cart','Product is available','Search product; add result; open cart','Cart contains the selected product with quantity one','High'))
$cases += (Join-Row @('TC-006','SCN-006','Remove product from cart','Cart contains a product','Select remove for the product','Removed product no longer appears in cart','Medium'))
$cases += (Join-Row @('TC-007','SCN-007','Verify cart quantity and amount','Cart contains a known product','Record unit price; add product; inspect cart amount','Quantity and calculated amount match the selected product','High'))
$cases += (Join-Row @('TC-008','SCN-008','Complete signed-in checkout','Signed-in customer; cart has an available product; test payment data','Proceed to checkout; place order; enter test payment details; pay','Order is accepted and confirmation is displayed','High'))
$cases += (Join-Row @('TC-009','SCN-009','Verify inventory cannot go negative','Database test data loaded','Submit order quantity above available stock; query inventory','Order is rejected or constrained; inventory remains zero or greater','High'))
$cases += (Join-Row @('TC-010','SCN-010','Check sensitive-data handling','Application logging is accessible in test environment','Perform login and payment; inspect UI and test logs','Passwords and full payment credentials are masked or absent','High'))

$traceability = @()
$traceability += (Join-Row @('REQ-001','Customer authentication','SCN-001, SCN-002','TC-001, TC-002','Yes','Yes','Partial','Draft'))
$traceability += (Join-Row @('REQ-002','Product search','SCN-003, SCN-004','TC-003, TC-004','Yes','Yes','No','Draft'))
$traceability += (Join-Row @('REQ-003','Cart management','SCN-005, SCN-006','TC-005, TC-006','Yes','Yes','Partial','Draft'))
$traceability += (Join-Row @('REQ-004','Cart totals','SCN-007','TC-007','Yes','Partial','Yes','Draft'))
$traceability += (Join-Row @('REQ-005','Checkout field validation','SCN-008','TC-008','Partial','Yes','No','Draft'))
$traceability += (Join-Row @('REQ-006','Order confirmation','SCN-008','TC-008','Yes','Yes','Yes','Draft'))
$traceability += (Join-Row @('REQ-007','Inventory integrity','SCN-009','TC-009','No','Partial','Yes','Draft'))
$traceability += (Join-Row @('REQ-008','Sensitive-data protection','SCN-010','TC-010','Partial','Partial','No','Draft'))

$defects = @()
$defects += (Join-Row @('','','','','','','','','','',''))
$execution = @()
$execution += (Join-Row @('RUN-001','Not executed','BASE_URL','TC-001','Not Run','','',''))
$execution += (Join-Row @('RUN-001','Not executed','BASE_URL','TC-002','Not Run','','',''))
$execution += (Join-Row @('RUN-001','Not executed','BASE_URL','TC-003','Not Run','','',''))
$execution += (Join-Row @('RUN-001','Not executed','BASE_URL','TC-004','Not Run','','',''))
$execution += (Join-Row @('RUN-001','Not executed','BASE_URL','TC-005','Not Run','','',''))
$execution += (Join-Row @('RUN-001','Not executed','BASE_URL','TC-006','Not Run','','',''))
$execution += (Join-Row @('RUN-001','Not executed','BASE_URL','TC-007','Not Run','','',''))
$execution += (Join-Row @('RUN-001','Not executed','BASE_URL','TC-008','Not Run','','',''))
$execution += (Join-Row @('RUN-001','Not executed','BASE_URL','TC-009','Not Run','','',''))
$execution += (Join-Row @('RUN-001','Not executed','BASE_URL','TC-010','Not Run','','',''))

New-Workbook 'test-scenarios.xlsx' 'Scenarios' (Join-Row @('Scenario ID','Requirement ID','Scenario','Priority','Type')) $scenarios
New-Workbook 'test-cases.xlsx' 'Cases' (Join-Row @('Case ID','Scenario ID','Title','Preconditions','Steps','Expected result','Priority')) $cases
New-Workbook 'traceability-matrix.xlsx' 'Traceability' (Join-Row @('Requirement ID','Requirement summary','Scenario IDs','Test case IDs','UI coverage','API coverage','SQL coverage','Status')) $traceability
New-Workbook 'defect-reports.xlsx' 'Defects' (Join-Row @('Defect ID','Summary','Severity','Priority','Status','Environment','Steps to reproduce','Expected result','Actual result','Owner','Created date')) $defects
New-Workbook 'test-execution-report.xlsx' 'Execution' (Join-Row @('Run ID','Execution date','Environment','Test case ID','Result','Actual result / notes','Defect ID','Executed by')) $execution