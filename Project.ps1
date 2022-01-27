<#
    .DESCRIPTION
    Dit profile.ps1 script zorgt ervoor dat de functies die hieronder zijn geschreven, meteen beschikbaar
    worden tijdens het opstarten van PowerShell. Op deze manier kun je gemakkelijk een logo of website
    project starten. Dit script maakt de mappenstructuur aan, hernoemd logo files, kopieert logo files en
    zipt uiteindelijk het hele project, zodat het in 1x door kan naar de klant.
    
    .NOTES
    Author:   Mark Wilbrink
    Created:  16-1-2022
    Modified: 24-1-2022
#>

# Globale vars die je in de verschillende functies kunt gebruiken
$global:PadProject = "D:\OneDrive\Wilbrink Design\Projects"
$global:PadProjectLaatstBekend = (Get-ChildItem -Path $PadProject -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
$global:PadLogoGuide = "D:\OneDrive\Wilbrink Design\Guides\Logo guide.pdf"
$global:PadLogoGids = "D:\OneDrive\Wilbrink Design\Guides\Logo gids.pdf"

Function Project-Start
{
    Clear-Host
    
    # Controleer op de projecten folder bestaat
    If (!(Test-Path -Path $PadProject -ErrorAction SilentlyContinue))
    {
        Write-Host "Projecten folder niet gevonden: $PadProject" -ForegroundColor Red
        Break
    }

    Do { $SoortProject = Read-Host "Wordt dit een Logo project of een Website project? Kies: Logo / Website" } While ( $SoortProject -notmatch "Logo|Website" )
    Write-Host ""    

    Do { $ProjectNaam = Read-Host "Geef de naam van het project" } While ( $ProjectNaam -eq "" )
    Write-Host ""

    # Controleer of er niet al eens eerder een project gestart is onder dezelfde naam
    If ((Test-Path -Path "$PadProject\$ProjectNaam" -ErrorAction SilentlyContinue))
    {
        Write-Host "Project folder bestaat al: $PadProject\$ProjectNaam" -ForegroundColor Red
        Write-Host ""
        Do { $Doorgaan = Read-Host "Doorgaan?" } While ($Doorgaan -notmatch "Ja|Nee")
        Write-Host ""

        If ($Doorgaan -eq "Nee")
        {
            Break
        }
    }

    If ($SoortProject -eq "Logo")
    {
        Do { $Taal = Read-Host "Wat wordt de taal van het project? Kies: nl / en" } While ( $Taal -notmatch "nl|en" )
        Write-Host ""

        # Controleer of de handleiding bestaat
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
        }
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
        }
    }
    
    If ($SoortProject -eq "Logo")
    {
        # Verschillende extensies die bij de verschillende kleurmodussen horen
        $Extensies = @{
            "Digital" = @("AI", "EPS", "PDF", "JPEG", "PNG", "SVG")
            "Print" = @("AI", "EPS", "PDF")
        }

        # Mappen structuur aanmaken
        Foreach ($Mode in $Extensies.GetEnumerator())
        {
            Foreach ($Ext in $Mode.Value)
            {
                If (!(Test-Path -Path "$PadProject\$ProjectNaam\Logo\Files\$($Mode.Name)\$Ext"))
                {
                    New-Item -Path "$PadProject\$ProjectNaam\Logo\Files\$($Mode.Name)\$Ext" -ItemType "directory" | Out-Null
                    Write-Host "Map aangemaakt: $PadProject\$ProjectNaam\Logo\Files\$($Mode.Name)\$Ext" -ForegroundColor Green
                }
                Else
                {
                    Write-Host "Map bestond al: $PadProject\$ProjectNaam\Logo\Files\$($Mode.Name)\$Ext" -ForegroundColor Yellow
                }
            }
        }
    }
    ElseIf ($SoortProject -eq "Website")
    {
        If (!(Test-Path -Path "$PadProject\$ProjectNaam\Website"))
        {
            New-Item -Path "$PadProject\$ProjectNaam\Website" -ItemType "directory" | Out-Null
            Write-Host "Map aangemaakt: $PadProject\$ProjectNaam\Website" -ForegroundColor Green
        }
        Else
        {
            Write-Host "Map bestond al: $PadProject\$ProjectNaam\Website" -ForegroundColor Yellow
        }        
    }

    # Mockups directory aanmaken
    If (!(Test-Path -Path "$PadProject\$ProjectNaam\Mockups"))
    {
        New-Item -Path "$PadProject\$ProjectNaam\Mockups" -ItemType "directory" | Out-Null
        Write-Host "Map aangemaakt: $PadProject\$ProjectNaam\Mockups" -ForegroundColor Green
    }
    Else
    {
        Write-Host "Map bestond al: $PadProject\$ProjectNaam\Mockups" -ForegroundColor Yellow
    }

    # Handleiding kopieren
    If ($SoortProject -eq "Logo")
    {
        If ($Taal -eq "en")
        {
            If (!(Test-Path -Path "$PadProject\$ProjectNaam\Logo\Files\Logo guide.pdf"))
            {
                Copy-Item -Path $PadLogoGuide -Destination "$PadProject\$ProjectNaam\Logo\Files"
                Write-Host "Handleiding gekopieerd: $PadProject\$ProjectNaam\Logo\Files\Logo guide.pdf" -ForegroundColor Green
            }
            Else
            {
                Write-Host "Handleiding bestond al: $PadProject\$ProjectNaam\Logo\Files\Logo guide.pdf" -ForegroundColor Yellow
            }
        }
        ElseIf ($Taal -eq "nl")
        {
            If (!(Test-Path -Path "$PadProject\$ProjectNaam\Logo\Files\Logo gids.pdf"))
            {
                Copy-Item -Path $PadLogoGids -Destination "$PadProject\$ProjectNaam\Logo\Files"
                Write-Host "Handleiding gekopieerd: $PadProject\$ProjectNaam\Logo\Files\Logo gids.pdf" -ForegroundColor Green
            }
            Else
            {
                Write-Host "Handleiding bestond al: $PadProject\$ProjectNaam\Logo\Files\Logo gids.pdf" -ForegroundColor Yellow
            }
        }
    }

    # Start de verkenner en open het project
    If ($SoortProject -eq "Logo")
    {
        explorer.exe "$PadProject\$ProjectNaam\Logo"
    }
    ElseIf ($SoortProject -eq "Website")
    {
        explorer.exe "$PadProject\$ProjectNaam\Website"
    }
}

Function Project-CopyFiles
{
    Clear-Host
    
    # Bekijk of er een laatste project bekend is en we die kunnen gebruiken, en vraag ook naar het pad of er een ander project geselecteerd moet worden
    If ($PadProjectLaatstBekend) { Write-Host "Laatst bekende project: $PadProjectLaatstBekend" -ForegroundColor Yellow -BackgroundColor Black }
    If ($PadProjectLaatstBekend) { Write-Host "" }

    Do 
    {
        $Pad = Read-Host "Geef het pad op van het project waar de bestanden op het bureaublad naartoe moeten worden gekopieerd of enter voor het laatst bekende pad"
        Write-Host ""
        $Pad = If (!$Pad) { $PadProjectLaatstBekend } Else { $Pad -replace '"', "" }
        $Pad = If (!$Pad) { "Laatst bekende pad was onbekend" } Else { $Pad }

        If (!(Test-Path -Path $Pad -ErrorAction SilentlyContinue))
        {
            Write-Host "Pad niet gevonden, probeer het opnieuw: $Pad" -ForegroundColor Red
            Write-Host ""
        }
    }
    While (!(Test-Path -Path $Pad -ErrorAction SilentlyContinue))

    Do { $ModeKleur = Read-Host "Wat is de kleur modus van de bestanden? Kies RGB / CMYK" } While ( $ModeKleur -notmatch "RGB|CMYK" )
    Write-Host ""

    # De verschillende extensies en paden die horen bij de verschillende kleur modussen
    If ($ModeKleur -eq "RGB")
    {
        $ExtensiesEnPaden = @{
            "AI" = "$Pad\Logo\Files\Digital\AI"
            "EPS" = "$Pad\Logo\Files\Digital\EPS"
            "PDF" = "$Pad\Logo\Files\Digital\PDF"
            "JPG" = "$Pad\Logo\Files\Digital\JPEG"
            "PNG" = "$Pad\Logo\Files\Digital\PNG"
            "SVG" = "$Pad\Logo\Files\Digital\SVG"
        }
    }
    ElseIf ($ModeKleur -eq "CMYK")
    {
        $ExtensiesEnPaden = @{
            "AI" = "$Pad\Logo\Files\Print\AI"
            "EPS" = "$Pad\Logo\Files\Print\EPS"
            "PDF" = "$Pad\Logo\Files\Print\PDF"
        }
    }

    # Kopieer de bestanden van het bureaublad naar het project, en houdt rekening met de kleur modus en de bijbehorende mappen structuur
    Foreach ($Ext in $ExtensiesEnPaden.GetEnumerator())
    {
        $Bestanden = Get-ChildItem "$([Environment]::GetFolderPath("Desktop"))" -Recurse | where { $_.GetType().Name -eq "FileInfo" -and $_.FullName -like "*$($Ext.Name)*" }

        Foreach ($Bestand in $Bestanden)
        {
            $Bestand | Copy-Item -Destination $Ext.Value
            Write-Host "$ModeKleur bestand gekopieerd: $Bestand => $($Ext.Value)" -ForegroundColor Green
        }
    }

    # Start de verkenner en open het project
    explorer.exe "$Pad\Logo\Files"
}

Function Project-RenameFiles
{
    Clear-Host
    
    # Bekijk of er een laatste project bekend is en we die kunnen gebruiken, en vraag ook naar het pad of er een ander project geselecteerd moet worden
    If ($PadProjectLaatstBekend) { Write-Host "Laatst bekende project: $PadProjectLaatstBekend" -ForegroundColor Yellow -BackgroundColor Black }
    If ($PadProjectLaatstBekend) { Write-Host "" }

    Do 
    {
        $Pad = Read-Host "Geef het pad op van het project waarvan de logo files hernoemd moeten worden of enter voor het laatst bekende pad"
        Write-Host ""
        $Pad = If (!$Pad) { $PadProjectLaatstBekend } Else { $Pad -replace '"', "" }
        $Pad = If (!$Pad) { "Laatst bekende pad was onbekend" } Else { $Pad }

        If (!(Test-Path -Path $Pad -ErrorAction SilentlyContinue))
        {
            Write-Host "Pad niet gevonden, probeer het opnieuw: $Pad" -ForegroundColor Red
            Write-Host ""
        }
    }
    While (!(Test-Path -Path $Pad -ErrorAction SilentlyContinue))

    $CMYK = Get-ChildItem $Pad -Recurse | where { $_.GetType().Name -eq "FileInfo" -and $_.FullName -like "*Print\*" -and $_.FullName -notlike "*-cmyk*" }

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

    $RGB = Get-ChildItem $Pad -Recurse | where { $_.GetType().Name -eq "FileInfo" -and $_.FullName -like "*Digital\*" -and $_.FullName -notlike "*-rgb*" }

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
    
    If ($PadProjectLaatstBekend) { Write-Host "Laatst bekende project: $PadProjectLaatstBekend" -ForegroundColor Yellow -BackgroundColor Black }
    If ($PadProjectLaatstBekend) { Write-Host "" }

    # Bekijk of er een laatste project bekend is en we die kunnen gebruiken, en vraag ook naar het pad of er een ander project geselecteerd moet worden
    Do 
    {
        $Pad = Read-Host "Geef het pad op van het project waar een .ZIP file van gemaakt moet worden of enter voor het laatst bekende pad"
        Write-Host ""
        $Pad = If (!$Pad) { $PadProjectLaatstBekend } Else { $Pad -replace '"', "" }
        $Pad = If (!$Pad) { "Laatst bekende pad was onbekend" } Else { $Pad }

        If (!(Test-Path -Path $Pad -ErrorAction SilentlyContinue))
        {
            Write-Host "Pad niet gevonden, probeer het opnieuw: $Pad" -ForegroundColor Red
            Write-Host ""
        }
    }
    While (!(Test-Path -Path $Pad -ErrorAction SilentlyContinue))

    Do { $SoortProject = Read-Host "Zip je een Logo project of een Website project? Kies: Logo / Website" } While ( $SoortProject -notmatch "Logo|Website" )
    Write-Host ""    

    If ($SoortProject -eq "Logo")
    {
        # Soorten files die je kunt uploaden in Fiverr
        $WorkFiles = "JPEG|PNG|SVG"
        $SourceFiles = "AI|EPS|PDF"

        # Test of de logo files bestaan en of het bureaublad niet gevuld is met Source en Work files
        If ((Test-Path -Path "$Pad\Logo\Files"))
        {
            If (!(Test-Path -Path "$([Environment]::GetFolderPath("Desktop"))\Source files") -and !(Test-Path -Path "$([Environment]::GetFolderPath("Desktop"))\Work files"))
            {
                # Maak een .ZIP file van de logos voor Work files
                Copy-Item -Path "$Pad\Logo\Files" -Destination "$([Environment]::GetFolderPath("Desktop"))\Work files" -Recurse
                Get-ChildItem -Path "$([Environment]::GetFolderPath("Desktop"))\Work files" -Recurse | where { $_.Attributes -eq "Directory" -and $_.BaseName -match $SourceFiles } | Remove-Item -Recurse -Force
                Get-ChildItem -Path "$([Environment]::GetFolderPath("Desktop"))\Work files" | Compress-Archive -DestinationPath "$([Environment]::GetFolderPath("Desktop"))\Work files.zip" -Force
                Remove-Item -Path "$([Environment]::GetFolderPath("Desktop"))\Work files" -Recurse -Force
                Write-Host "Work files gezipt: $([Environment]::GetFolderPath("Desktop"))\Work files.zip" -ForegroundColor Green

                # Maak een .zip file van de logos voor Source files
                Copy-Item -Path "$Pad\Logo\Files" -Destination "$([Environment]::GetFolderPath("Desktop"))\Source files" -Recurse
                Get-ChildItem -Path "$([Environment]::GetFolderPath("Desktop"))\Source files" -Recurse | where { $_.Attributes -eq "Directory" -and $_.BaseName -match $WorkFiles } | Remove-Item -Recurse -Force
                Get-ChildItem -Path "$([Environment]::GetFolderPath("Desktop"))\Source files" | Compress-Archive -DestinationPath "$([Environment]::GetFolderPath("Desktop"))\Source files.zip" -Force
                Remove-Item -Path "$([Environment]::GetFolderPath("Desktop"))\Source files" -Recurse -Force
                Write-Host "Source files gezipt: $([Environment]::GetFolderPath("Desktop"))\Source files.zip" -ForegroundColor Green
            }
            Else
            {
                Write-Host "Bureaublad bestanden voor Source/Work files bestaan al" -ForegroundColor Red
                Break
            }
        }
        Else
        {
            Write-Host "Logo files bestaan niet: $Pad\Logo\Files" -ForegroundColor Red
            Break
        }
    }
    ElseIf ($SoortProject -eq "Website")
    {
        # Test of de website files bestaan en of het bureaublad niet gevuld is met Source files
        If ((Test-Path -Path "$Pad\Website"))
        {
            If (!(Test-Path -Path "$([Environment]::GetFolderPath("Desktop"))\Source files"))
            {
                # Maak een .zip file van de website voor Source files
                Get-ChildItem -Path "$Pad\Website" | Compress-Archive -DestinationPath "$([Environment]::GetFolderPath("Desktop"))\Source files.zip" -Force
                Write-Host "Source files gezipt: $([Environment]::GetFolderPath("Desktop"))\Source files.zip" -ForegroundColor Green
            }
            Else
            {
                Write-Host "Bureaublad bestanden voor Source files bestaan al" -ForegroundColor Red
                Break
            }
        }
        Else
        {
            Write-Host "Website files bestaan niet: $Pad\Website" -ForegroundColor Red
            Break
        }
    }

    # Maak een .zip file van de mockups
    If ((Test-Path -Path "$Pad\Mockups") -and ((Get-ChildItem -Path "$Pad\Mockups" -ErrorAction SilentlyContinue).Count -ge 1))
    {
        Get-ChildItem -Path "$Pad\Mockups" | Compress-Archive -DestinationPath "$([Environment]::GetFolderPath("Desktop"))\Mockups.zip" -Force
        Write-Host "Mockups gezipt: $([Environment]::GetFolderPath("Desktop"))\Mockups.zip" -ForegroundColor Green
    }
    Else
    {
        Write-Host "Map bestond niet of was niet gevuld: $Pad\Mockups" -ForegroundColor Yellow
    }
}