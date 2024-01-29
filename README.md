see also https://sysmanrec.com/reporting-services-role-installation-fails-with-msi-error

I observed a strange behavior of the reporting services setup process. Below a scripted workaround for it.

Symptoms:
The setup of the reporting point role fails. Under Monitoring->System Status, you see that the installation reruns every hour with the same result.

Components error message:

Site Component Manager failed to install this component, because the Microsoft Installer File for this component (srsrp.msi) could not install.

Refer to the srsrpSetup.log, the srsrpmsi.log, as well as the ConfigMgr Documentation and the Microsoft Knowledge Base for further information.

The problem:

srsrpsetup.exe calls the srsrp.msi with an install path but the srsrp.msi switches to another path during the setup. When the srsrpsetup.exe checks the installation location to register a dll, it doesn’t find it and returns an error.

The issue can obviously only occur on systems with multiple drives. 

On the reporting server, you will find the following log entries (the drives may of course be different than D: and F:):

srsrpmsi.log

MSI (s) (60:C0) [16:19:35:659]: Command Line: SRSRPINSTALLDIR=D:\SMS_SRSRP SRSRPLANGPACKFLAGS=0 CURRENTDIRECTORY=D:\SMS\bin\x64 CLIENTUILEVEL=3 MSICLIENTUSESEXTERNALUI=1 CLIENTPROCESSID=10984

…

MSI (s) (60:C0) [16:19:35:690]: PROPERTY CHANGE: Modifying TARGETDIR property. Its current value is ‘D:\SMS_SRSRP’. Its new value: ‘F:\SMS_SRSRP’.


The workaround:
At the beginning of the installation process, srsrpsetup.exe will delete the installation folder on the target drive. If you want to outsmart the process by just copying it back, you only have around 5 seconds until the failure occurs. Since you can’t say exactly when the installation will start after a failure, it makes sense to automate the process. The steps:

Copy the installation folder that the msi setup created and paste it to the drive where srsrpsetup.exe expects it. Rename it to SMS_SRSRPtemp. Delete or rename the folder that the msi created.
Set the variables in the script below and let it run. Latest after one hour, you should see that the process succeed. 
As a sign of live, the script will write a dot (‘.’) every 120 seconds.
