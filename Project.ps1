<#
    .DESCRIPTION
    Dit profile.ps1 script zorgt ervoor dat de functies die hieronder zijn geschreven, meteen beschikbaar
    worden tijdens het opstarten van PowerShell. Op deze manier kun je gemakkelijk een logo of website
    project starten. Dit script maakt de mappenstructuur aan, hernoemd logo files, kopieert logo files en
    zipt uiteindelijk het hele project, zodat het in 1x door kan naar de klant.
    
    .NOTES
    Author:   Mark Wilbrink
    Created:  16-1-2022
    Modified: 31-1-2022
#>

# Globale vars die je in elke functie kunt aanroepen
$global:PadProjecten = "D:\OneDrive\Wilbrink Design\Projects"

Function Project-Start
{
    Clear-Host

    # Paden handleidingen
    $PadLogoGuide = "D:\OneDrive\Wilbrink Design\Documents\Logo guide.pdf"
    $PadLogoGids = "D:\OneDrive\Wilbrink Design\Documents\Logo gids.pdf"

    # Controleren of het projecten pad uberhaupt bestaat, anders dit script niet verder starten
    If (!(Test-Path -Path $PadProjecten -ErrorAction SilentlyContinue))
    {
        Write-Host "Projecten folder niet gevonden: $PadProjecten" -ForegroundColor Red
        Break
    }

    # We hebben verschillende projecten, kies hier het type
    Do { $SoortProject = Read-Host "Wordt dit een Logo project of een Website project? Kies: Logo / Website" } While ( $SoortProject -notmatch "Logo|Website" )
    Write-Host ""    

    # Naam van het project, dit wordt ook de folder naam
    Do { $ProjectNaam = Read-Host "Geef de naam van het project" } While ( $ProjectNaam -eq "" )
    Write-Host ""

    # Controleren of het project niet al eens eerder is aangemaakt
    If ((Test-Path -Path "$PadProjecten\$ProjectNaam" -ErrorAction SilentlyContinue))
    {
        Write-Host "Project folder bestaat al: $PadProjecten\$ProjectNaam" -ForegroundColor Red
        Write-Host ""
        Do { $Doorgaan = Read-Host "Doorgaan?" } While ($Doorgaan -notmatch "Ja|Nee")
        Write-Host ""

        If ($Doorgaan -eq "Nee")
        {
            Break
        }
    }

    # Logo en website zaken in orde maken
    If ($SoortProject -eq "Logo")
    {
        # Taal van het project i.v.m. de logo handleiding
        Do { $Taal = Read-Host "Wat wordt de taal van het project? Kies: nl / en" } While ( $Taal -notmatch "nl|en" )
        Write-Host ""

        # Verschillende extensies die we gebruiken om de folders mee aan te maken
        $Extensies = @("AI", "EPS", "PDF", "SVG", "PNG", "JPEG")

        # Maak de mappenstructuur aan voor het logo
        Foreach ($Extensie in $Extensies)
        {
            If (!(Test-Path -Path "$PadProjecten\$ProjectNaam\Logo\Files\$Extensie"))
            {
                New-Item -Path "$PadProjecten\$ProjectNaam\Logo\Files\$Extensie" -ItemType "directory" | Out-Null
                Write-Host "Map aangemaakt: $PadProjecten\$ProjectNaam\Logo\Files\$Extensie" -ForegroundColor Green
            }
            Else
            {
                Write-Host "Map bestond al: $PadProjecten\$ProjectNaam\Logo\Files\$Extensie" -ForegroundColor Yellow
            }
        }

        # Taal = Engels, controleer of de handleiding gevonden kan worden, zo ja, kopieer het naar de juiste locatie
        If ($Taal -eq "en")
        {
            If (!(Test-Path -Path $PadLogoGuide -ErrorAction SilentlyContinue))
            {
                Write-Host "Handleiding niet gevonden: $PadLogoGuide" -ForegroundColor Red
                Write-Host ""
                Do { $Doorgaan = Read-Host "Doorgaan?" } While ($Doorgaan -notmatch "Ja|Nee")
                Write-Host ""

                If ($Doorgaan -eq "Nee")
                {
                    Break
                }
            }
            Else
            {
                Copy-Item -Path $PadLogoGuide -Destination "$PadProjecten\$ProjectNaam\Logo\Files"
                Write-Host "Handleiding gekopieerd: $PadProjecten\$ProjectNaam\Logo\Files\Logo guide.pdf" -ForegroundColor Green
            }
        }
        # Taal = Nederlands, controleer of de handleiding gevonden kan worden, zo ja, kopieer het naar de juiste locatie
        ElseIf ($Taal -eq "nl")
        {
            If (!(Test-Path -Path $PadLogoGids -ErrorAction SilentlyContinue))
            {
                Write-Host "Handleiding niet gevonden: $PadLogoGids" -ForegroundColor Red
                Write-Host ""
                Do { $Doorgaan = Read-Host "Doorgaan?" } While ($Doorgaan -notmatch "Ja|Nee")
                Write-Host ""

                If ($Doorgaan -eq "Nee")
                {
                    Break
                }
            }
            Else
            {
                Copy-Item -Path $PadLogoGids -Destination "$PadProjecten\$ProjectNaam\Logo\Files"
                Write-Host "Handleiding gekopieerd: $PadProjecten\$ProjectNaam\Logo\Files\Logo gids.pdf" -ForegroundColor Green
            }
        }

        # Start de verkenner en open het project
        explorer.exe "$PadProjecten\$ProjectNaam\Logo"
    }
    # Maak de map aan voor de website
    ElseIf ($SoortProject -eq "Website")
    {
        If (!(Test-Path -Path "$PadProjecten\$ProjectNaam\Website"))
        {
            New-Item -Path "$PadProjecten\$ProjectNaam\Website" -ItemType "directory" | Out-Null
            Write-Host "Map aangemaakt: $PadProjecten\$ProjectNaam\Website" -ForegroundColor Green
        }
        Else
        {
            Write-Host "Map bestond al: $PadProjecten\$ProjectNaam\Website" -ForegroundColor Yellow
        }        

        # Start de verkenner en open het project
        explorer.exe "$PadProjecten\$ProjectNaam\Website"
    }

    # Map aanmaken voor de mockups
    If (!(Test-Path -Path "$PadProjecten\$ProjectNaam\Mockups"))
    {
        New-Item -Path "$PadProjecten\$ProjectNaam\Mockups" -ItemType "directory" | Out-Null
        Write-Host "Map aangemaakt: $PadProjecten\$ProjectNaam\Mockups" -ForegroundColor Green
    }
    Else
    {
        Write-Host "Map bestond al: $PadProjecten\$ProjectNaam\Mockups" -ForegroundColor Yellow
    }
}

Function Project-CopyFiles
{
    Clear-Host

    $PadLaatsteProject = (Get-ChildItem -Path $PadProjecten -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
    
    # Bekijk of er een laatste project bekend is en we die kunnen gebruiken, en vraag ook naar het pad of er een ander project geselecteerd moet worden
    If ($PadLaatsteProject) { Write-Host "Laatst bekende project: $PadLaatsteProject" -ForegroundColor Yellow -BackgroundColor Black }
    If ($PadLaatsteProject) { Write-Host "" }

    Do 
    {
        $Pad = Read-Host "Geef het pad op van het project waar de bestanden op het bureaublad naartoe moeten worden gekopieerd of enter voor het laatst bekende pad"
        Write-Host ""
        $Pad = If (!$Pad) { $PadLaatsteProject } Else { $Pad -replace '"', "" }
        $Pad = If (!$Pad) { "Laatst bekende pad was onbekend" } Else { $Pad }

        If (!(Test-Path -Path $Pad -ErrorAction SilentlyContinue))
        {
            Write-Host "Pad niet gevonden, probeer het opnieuw: $Pad" -ForegroundColor Red
            Write-Host ""
        }
    }
    While (!(Test-Path -Path $Pad -ErrorAction SilentlyContinue))

    # De verschillende extensies en paden die horen bij de verschillende kleurmodussen
    $ExtensiesEnPaden = @{
        "AI" = "$Pad\Logo\Files\AI"
        "EPS" = "$Pad\Logo\Files\EPS"
        "PDF" = "$Pad\Logo\Files\PDF"
        "SVG" = "$Pad\Logo\Files\SVG"
        "PNG" = "$Pad\Logo\Files\PNG"
        "JPG" = "$Pad\Logo\Files\JPEG"
    }

    # Kopieer de bestanden van het bureaublad naar het project, en houdt rekening met de kleurmodus en de bijbehorende mappen
    Foreach ($Extensie in $ExtensiesEnPaden.GetEnumerator())
    {
        $Bestanden = Get-ChildItem "$([Environment]::GetFolderPath("Desktop"))" -Recurse | where { $_.GetType().Name -eq "FileInfo" -and $_.FullName -like "*$($Extensie.Name)*" }

        Foreach ($Bestand in $Bestanden)
        {
            $Bestand | Copy-Item -Destination $Extensie.Value
            Write-Host "Bestand gekopieerd: $Bestand => $($Extensie.Value)" -ForegroundColor Green
        }

        If (!$Bestanden)
        {
            Write-Host "Geen bestanden gevonden voor extensie: $($Extensie.Name)" -ForegroundColor Yellow
        }
    }

    # Start de verkenner en open het project
    explorer.exe "$Pad\Logo\Files"
}

Function Project-RenameFiles
{
    Clear-Host

    $PadLaatsteProject = (Get-ChildItem -Path $PadProjecten -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
    
    # Bekijk of er een laatste project bekend is en we die kunnen gebruiken, en vraag ook naar het pad of er een ander project geselecteerd moet worden
    If ($PadLaatsteProject) { Write-Host "Laatst bekende project: $PadLaatsteProject" -ForegroundColor Yellow -BackgroundColor Black }
    If ($PadLaatsteProject) { Write-Host "" }

    Do 
    {
        $Pad = Read-Host "Geef het pad op van het project waarvan de logo files hernoemd moeten worden of enter voor het laatst bekende pad"
        Write-Host ""
        $Pad = If (!$Pad) { $PadLaatsteProject } Else { $Pad -replace '"', "" }
        $Pad = If (!$Pad) { "Laatst bekende pad was onbekend" } Else { $Pad }

        If (!(Test-Path -Path $Pad -ErrorAction SilentlyContinue))
        {
            Write-Host "Pad niet gevonden, probeer het opnieuw: $Pad" -ForegroundColor Red
            Write-Host ""
        }
    }
    While (!(Test-Path -Path $Pad -ErrorAction SilentlyContinue))

    Do { $KleurModus = Read-Host "Is dit een CMYK + RGB of een RGB only project? Kies: CMYK / RGB" } While ( $KleurModus -notmatch "CMYK|RGB" )
    Write-Host ""

    # De verschillende extensies en de kleurmodus die erbij hoort
    $ExtensiesCMYK = "AI|EPS|PDF"
    $ExtensiesRGB = "SVG|PNG|JPG"

    If ($KleurModus -eq "CMYK")
    {
        # Vraag alle files op in alleen de sub folders
        $CMYK = Get-ChildItem $Pad\Logo\Files\*\* | where { $_.GetType().Name -eq "FileInfo" -and $_.FullName -match $ExtensiesCMYK -and $_.FullName -notlike "*-cmyk*" }
        $RGB = Get-ChildItem $Pad\Logo\Files\*\* | where { $_.GetType().Name -eq "FileInfo" -and $_.FullName -match $ExtensiesRGB -and $_.FullName -notlike "*-rgb*" }
    }
    ElseIf ($KleurModus -eq "RGB")
    {
        # Vraag alle files op in alleen de sub folders
        $RGB = Get-ChildItem $Pad\Logo\Files\*\* | where { $_.GetType().Name -eq "FileInfo" -and $_.FullName -notlike "*-rgb*" }
    }

    # Hernoem de CMYK bestanden, sloop de prefix eraf en plaats er een suffix op
    If ($CMYK)
    {
        Foreach ($ModeKleur in $CMYK)
        {
            $ModeKleur | Rename-Item -NewName { (($_.BaseName + '-cmyk' + $_.Extension) -replace "([^_]+_)", "") }
            $BestandNieuw = (($ModeKleur.BaseName + '-cmyk' + $_.Extension) -replace "([^_]+_)", "")
            Write-Host "Print file: Suffix 'cmyk' toegevoegd en prefix eraf gehaald: $BestandNieuw" -ForegroundColor Green
        }
    }
    Else
    {
        Write-Host "Print files: De bestanden zijn niet gevonden of de bestanden waren al hernoemd" -ForegroundColor Yellow
    }

    # Hernoem de RGB bestanden, sloop de prefix eraf en plaats er een suffix op
    If ($RGB)
    {
        Foreach ($ModeKleur in $RGB)
        {
            $ModeKleur | Rename-Item -NewName { (($_.BaseName + '-rgb' + $_.Extension) -replace "([^_]+_)", "") }
            $BestandNieuw = (($ModeKleur.BaseName + '-rgb' + $_.Extension) -replace "([^_]+_)", "")
            Write-Host "Digital file: Suffix 'rgb' toegevoegd en prefix eraf gehaald: $BestandNieuw" -ForegroundColor Green
        }
    }
    Else
    {
        Write-Host "Digital files: De bestanden zijn niet gevonden of de bestanden waren al hernoemd" -ForegroundColor Yellow
    }

    # Start de verkenner en open het project
    explorer.exe "$Pad\Logo\Files"
}

Function Project-Zip
{
    Clear-Host

    $PadLaatsteProject = (Get-ChildItem -Path $PadProjecten -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
    
    If ($PadLaatsteProject) { Write-Host "Laatst bekende project: $PadLaatsteProject" -ForegroundColor Yellow -BackgroundColor Black }
    If ($PadLaatsteProject) { Write-Host "" }

    # Bekijk of er een laatste project bekend is en we die kunnen gebruiken, en vraag ook naar het pad of er een ander project geselecteerd moet worden
    Do 
    {
        $Pad = Read-Host "Geef het pad op van het project waar een .ZIP file van gemaakt moet worden of enter voor het laatst bekende pad"
        Write-Host ""
        $Pad = If (!$Pad) { $PadLaatsteProject } Else { $Pad -replace '"', "" }
        $Pad = If (!$Pad) { "Laatst bekende pad was onbekend" } Else { $Pad }

        If (!(Test-Path -Path $Pad -ErrorAction SilentlyContinue))
        {
            Write-Host "Pad niet gevonden, probeer het opnieuw: $Pad" -ForegroundColor Red
            Write-Host ""
        }
    }
    While (!(Test-Path -Path $Pad -ErrorAction SilentlyContinue))

    # Tijdelijke folder aanmaken
    $TempMap = New-Item -Path "$([Environment]::GetFolderPath("Desktop"))\$(Get-Random)" -ItemType "directory"

    # Test of de logo files bestaan en maak de .ZIP files aan
    If ((Test-Path -Path "$Pad\Logo\Files"))
    {
        # De verschillende .ZIP files met de bijbehorende mappen
        $WorkFiles = "SVG|PNG|JPEG"
        $SourceFiles = "AI|EPS|PDF"

        # Maak de .ZIP files aan voor Work files en Source files
        Copy-Item -Path "$Pad\Logo\Files\" -Destination "$(($TempMap).FullName)\Logo\" -Recurse

        # Maak de .ZIP file aan voor Work files
        Get-ChildItem "$TempMap\Logo" -Directory | where { $_.FullName -match $WorkFiles } | Compress-Archive -DestinationPath "$TempMap\Logo\Work files.zip" -Force
        Write-Host "Work files gezipt: $TempMap\Logo\Work files.zip" -ForegroundColor Green

        # Maak de .ZIP file aan voor Source files
        Get-ChildItem "$TempMap\Logo" -Directory | where { $_.FullName -match $SourceFiles } | Compress-Archive -DestinationPath "$TempMap\Logo\Source files.zip" -Force
        Write-Host "Source files gezipt: $TempMap\Logo\Source files.zip" -ForegroundColor Green
    }
    Else
    {
        Write-Host "Logo files bestaan niet: $Pad\Logo\Files" -ForegroundColor Yellow
        Break
    }

    # Test of de website files bestaan en maak een .ZIP file aan
    If ((Test-Path -Path "$Pad\Website"))
    {
        # Maak de folder voor de website files
        New-Item -Path "$TempMap\Website" -ItemType "directory"

        # Maak de .ZIP file aan voor Source files
        Get-ChildItem -Path "$Pad\Website" | Compress-Archive -DestinationPath "$TempMap\Website\Source files.zip" -Force
        Write-Host "Source files gezipt: $TempMap\Source files.zip" -ForegroundColor Green
    }
    Else
    {
        Write-Host "Website files bestaan niet: $Pad\Website" -ForegroundColor Yellow
        Break
    }

    # Test of de mockup files bestaan en maak een .ZIP file aan
    If ((Test-Path -Path "$Pad\Mockups") -and ((Get-ChildItem -Path "$Pad\Mockups" -ErrorAction SilentlyContinue).Count -ge 1))
    {
        # Maak de .ZIP file aan voor de mockup files
        Get-ChildItem -Path "$Pad\Mockups" | Compress-Archive -DestinationPath "$TempMap\Mockups.zip" -Force
        Write-Host "Mockups gezipt: $TempMap\Mockups.zip" -ForegroundColor Green
    }
    Else
    {
        Write-Host "Map bestond niet of was niet gevuld: $Pad\Mockups" -ForegroundColor Yellow
    }

    # Start de verkenner en open de folder
    explorer.exe "$TempMap"
}