# Script Parameters
param ($Configuration = "Debug")

# Create sandbox.cmd file.
function create_sandbox_scripts
{
    # Remove existing sandbox-install.cmd file. We want to regenerate this each time.
    if (Test-Path sandbox-install.cmd -PathType Leaf)
    {
        Remove-Item -Path sandbox-install.cmd -Force
    }

    # Remove existing sandbox-uninstall.cmd file. We want to regenerate this each time.
    if (Test-Path sandbox-uninstall.cmd -PathType Leaf)
    {
        Remove-Item -Path sandbox-uninstall.cmd -Force
    }

    # Get parent folder to use for installation path.
    $ProjectName = (Get-Item $PSScriptRoot).Name

    $Content = @"
C:\$ProjectName\SampleBundle\bin\x64\$Configuration\SampleBundle.exe /install /passive
"@

    # Write Content to sandbox-install.cmd.
    Set-Content -Path $PSScriptRoot\sandbox-install.cmd -Value $Content

    # Generate sandbox-uninstall.cmd file.
    $Content = @"
C:\$ProjectName\SampleBundle\bin\x64\$Configuration\SampleBundle.exe /uninstall /passive
"@

    # Write Content to sandbox-uninstall.cmd.
    Set-Content -Path $PSScriptRoot\sandbox-uninstall.cmd -Value $Content
}

# Create sandbox.wsb file. 
function create_sandbox_file
{
    # Remove existing sandbox.wsb file. We want to regenerate this each time.
    if (Test-Path sandbox.wsb -PathType Leaf)
    {
        Remove-Item -Path sandbox.wsb -Force
    }

    # Get parent folder to use for SandboxFolder.
    $ProjectName = (Get-Item $PSScriptRoot).Name

    # Generate sandbox.wsb file.
    $Content = @"
<Configuration>
	<MappedFolders>
		<MappedFolder>
			<HostFolder>$PSScriptRoot</HostFolder>
			<SandboxFolder>C:\$ProjectName</SandboxFolder>
			<ReadOnly>true</ReadOnly>
		</MappedFolder>
	</MappedFolders>
    <LogonCommand>
        <Command>C:\$ProjectName\sandbox-install.cmd</Command>
    </LogonCommand>
</Configuration>
"@

    # Write Content to sandbox.wsb.
    Set-Content -Path $PSScriptRoot\sandbox.wsb -Value $Content
}

function launch_sandbox
{
    # Launch the sandbox if we successfully created it.
    if (Test-Path sandbox.wsb -PathType Leaf)
    {
        .\sandbox.wsb
    }
}

function main
{
    # Create sandbox-*.cmd files.
    create_sandbox_scripts

    # Create sandbox.wsb file.
    create_sandbox_file

    # Launch the sandbox.
    launch_sandbox
}

main