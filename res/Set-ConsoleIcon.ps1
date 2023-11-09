##############################################################################
##
## Script: Set-ConsoleIcon.ps1
## By: Aaron Lerch
## Website: www.aaronlerch.com/blog
##
## Set the icon of the current console window to the specified icon
##
## Usage:  Set-ConsoleIcon [string]
##
## ie:
##
## PS:1 > Set-ConsoleIcon "C:\Icons\special_powershell_icon.ico"
##
##############################################################################

Param(
    [String] $IconFile
)

$WM_SETICON = 0x80
$ICON_SMALL = 0

function Main {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") |
        Out-Null

    # Verify the file exists
    if (-not [System.IO.File]::Exists($IconFile)) {
        Write-Output "Icon file not found"
        return
    }

    $icon = New-Object System.Drawing.Icon($IconFile)

    if ($null -eq $icon) {
        Write-Output "Icon could not drawn"
        return
    }

    $consoleHandle = GetConsoleWindow

    if ($null -eq $consoleHandle) {
        Write-Output "Console window handler failed"
        return
    }

    SendMessage $consoleHandle $WM_SETICON $ICON_SMALL $icon.Handle |
        Out-Null
}

## Invoke a Win32 P/Invoke call.
## From: Lee Holmes
## http://www.leeholmes.com/blog/GetTheOwnerOfAProcessInPowerShellPInvokeAndRefOutParameters.aspx
function Invoke-Win32 {
    Param(
        [String]
        $DllName,

        [Type]
        $ReturnType,

        [String]
        $MethodName,

        [Type[]]
        $ParameterTypes,

        [Object[]]
        $Parameters
    )

    # Write-Host "$(($ParameterTypes).Count)"

    # if ($null -eq $ParameterTypes -or @($ParameterTypes).Count -eq 0) {
    #     return
    # }

    ## Begin to build the dynamic assembly
    $name = New-Object Reflection.AssemblyName 'PInvokeAssembly'

    ## karlr (2021_06_10)
    $assembly = if ($PsVersionTable.PsVersion.Major -ge 7) {
        [System.Reflection.Emit.AssemblyBuilder]::DefineDynamicAssembly(
            $name,
            'Run'
        )
    }
    else {
        [AppDomain]::CurrentDomain.DefineDynamicAssembly(
            $name,
            'Run'
        )
    }

    $module = $assembly.DefineDynamicModule('PInvokeModule')
    $type = $module.DefineType('PInvokeType', "Public,BeforeFieldInit")

    ## Go through all of the parameters passed to us.  As we do this,
    ## we clone the user's inputs into another array that we will use for
    ## the P/Invoke call.
    $inputParameters = @()
    $refParameters = @()
    $count = 1

    foreach ($type in $ParameterTypes) {
        ## If an item is a PSReference, then the user
        ## wants an [out] parameter.
        if ($type -eq [Ref]) {
            ## Remember which parameters are used for [Out] parameters
            $refParameters += $count

            ## On the cloned array, we replace the PSReference type with the
            ## .Net reference type that represents the value of the PSReference,
            ## and the value with the value held by the PSReference.
            $type = $Parameters[$count - 1].Value.GetType().MakeByRefType()
            $inputParameters += $Parameters[$count - 1].Value
        }
        else {
            ## Otherwise, just add their actual parameter to the
            ## input array.
            $inputParameters += $Parameters[$count - 1]
        }
    }

    ## Define the actual P/Invoke method, adding the [Out]
    ## attribute for any parameters that were originally [Ref]
    ## parameters.
    $method = $type.DefineMethod(
        $MethodName,
        'Public,HideBySig,Static,PinvokeImpl',
        $ReturnType,
        $ParameterTypes
    )

    foreach ($refParameter in $refParameters) {
        $method.DefineParameter($refParameter, "Out", $null)
    }

    ## Apply the P/Invoke constructor
    $ctor = [Runtime.InteropServices.DllImportAttribute].
        GetConstructor([string])

    $attr = New-Object `
        Reflection.Emit.CustomAttributeBuilder `
        $ctor, $DllName

    $method.SetCustomAttribute($attr)

    ## Create the temporary type, and invoke the method.
    $realType = $type.CreateType()

    $realType.InvokeMember(
        $MethodName,
        'Public,Static,InvokeMethod',
        $null,
        $null,
        $inputParameters
    )

    ## Finally, go through all of the reference parameters, and update the
    ## values of the PSReference objects that the user passed in.
    foreach ($refParameter in $refParameters) {
        $Parameters[$refParameter - 1].Value =
            $inputParameters[$refParameter - 1]
    }
}

function SendMessage(
    [IntPtr] $hWnd,
    [Int32] $message,
    [Int32] $wParam,
    [Int32] $lParam
) {
    $ParameterTypes = [IntPtr], [Int32], [Int32], [Int32]
    $Parameters = $hWnd, $message, $wParam, $lParam

    Invoke-Win32 `
        "user32.dll" `
        ([Int32]) `
        "SendMessage" `
        $ParameterTypes `
        $Parameters
}

function GetConsoleWindow() {
    Invoke-Win32 `
        "kernel32" `
        ([IntPtr]) `
        "GetConsoleWindow"
}

. Main
