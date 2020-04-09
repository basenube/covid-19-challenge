Include %occInclude

Class MSPConfig.FHIRInstaller
{

ClassMethod DisableJournalSystemWide() As %Status
{
		Set tSC = $System.Status.OK()
		
		Try
		{
            Do $System.OBJ.SetTransactionMode(0, .tSC)
            Quit:$System.Status.IsError(tSC)
            
			Set tNS=$Namespace
			Set $Namespace="%SYS"
			
			Set err=0
			
			Do INT^JRNSTOP(.err,0)
			
			If err'=0 
			{
				Set tSC = $System.Status.Error(5001,"Error when trying to disable journal system wide. INT^JRNSTOP returned err: "_err)
			}
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Set $Namespace=tNS
		
		Quit tSC
}

ClassMethod DoFHIRServerSetup(pNamespace As %String) As %Status
{
		Set tSC = $System.Status.OK()
		
		Try
		{
			Set tNS=$Namespace
			ZN "HSLIB"

			/// Prepare APPINT NameSpace for FHIRServer
			Do ##class(HS.HC.Util.Installer).InstallFoundation(pNamespace)
			Do ##class(HS.FHIRServer.Installer).InstallNamespace(pNamespace)

			ZN pNamespace

			// Install an instance of a FHIR Service into the current namespace
			Set tFHIRApp = "/csp/healthshare/fhirserver/fhir/r4"
			Set tStrategyClass = "HS.FHIRServer.Storage.Json.InteractionsStrategy"
			Set tMetadataConfigKey = "HL7v40"
			Do ##class(HS.FHIRServer.Installer).InstallInstance(tFHIRApp, tStrategyClass, tMetadataConfigKey,"",0)

			// Automatically Setting up the FHIRServer in Debug mode to allow 
			// unauthenticated requests from IAM for testing routes.
			Set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(tFHIRApp) 
			Set configData = strategy.GetServiceConfigData() 
			Set configData.DebugMode = 4
			Do strategy.SaveServiceConfigData(configData)

		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}

		ZN tNS
		
		Quit tSC
}

ClassMethod PopulateFHIRServer(pNamespace As %String) As %Status
{
		Set tSC = $System.Status.OK()
		
		Try
		{
			Set tNS=$Namespace
			ZN pNamespace

			/// Load FHIR Resources Into configured FHIRServer
			Set tSC = ##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles("/tmp/output/fhir","FHIRServer","/csp/healthshare/fhirserver/fhir/r4")
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}

		ZN tNS
		
		Quit tSC
}

ClassMethod SetupIAMUser() As %Status
{
		Set tSC = $System.Status.OK()
		
		Try
		{
			//Enabling the IAM User role on the build so it is available
			Set Properties("Enabled") = 1
			Set Properties("PasswordNeverExpires") = 1
			Set Properties("Password")="sys"

			Set tSC = ##class(Security.Users).Modify("IAM", .Properties)
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
}

ClassMethod EnableIAMAPIEndpoint() As %Status
{
		Set tSC = $System.Status.OK()
		
		Try
		{
			//Enabling the IAM User role on the build so it is available
			Set Properties("Enabled") = 1
			Set tSC = ##class(Security.Applications).Modify("/api/iam", .Properties)
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
}

/// You can customize this to run code during docker build
XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
	<Namespace Name="${Namespace}" Create="no">
		<IfDef Var="SourceDir">
            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
            <Import File="${SourceDir}" Recurse="true"/>
		</IfDef>
	</Namespace>

	<Log Text="Setting Up FHIRSERVER in APPINT NameSpace..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="DoFHIRServerSetup" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>

	<Log Text="Populating FHIRSERVER with DEMO FHIR Data" Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="PopulateFHIRServer" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>

	<Log Text="Enabling IAM User..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="SetupIAMUser" CheckStatus="true">
	</Invoke>

	<Log Text="Enabling IAM API Endpoint..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="EnableIAMAPIEndpoint" CheckStatus="true">
	</Invoke>
</Manifest>
}

}
