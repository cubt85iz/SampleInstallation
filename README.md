# SampleInstallation

This installation demonstrates an installation failure in Windows Sandbox after applying KB5011048.

## Prerequisites

KB5011048 must be installed on host machine.

## Procedures

Compile solution in VS2022.
Execute sandbox-install.ps1 from Powershell.

## Observations

Observe directory is not created in Program Files and installation log for SamplePackage in %temp% indicates an error occurred. Observe error states `Failed to bind to CLR. Error code 0x8007007E`.

