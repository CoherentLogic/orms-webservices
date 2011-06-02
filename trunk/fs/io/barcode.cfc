<cfcomponent displayname="barcode" hint="ORMS barcode output filter">

	<cffunction name="write" access="public" returntype="string" output="false" hint="Write a barcode">
		<cfargument name="resource" type="fs.resource" required="true">
		
		<cfparam name="dest_path" default="">
		<cfset dest_path = "d:\inetpub\orms\repos\#resource.r_owner#\#resource.r_type#\#resource.r_id#">
		
		
		<cfset cmd_str = "/c d:\inetpub\orms\util\uuid2barcode.bat #resource.r_id# ""#dest_path#""">
		
		<cfexecute name="c:\windows\system32\cmd.exe" arguments="#cmd_str#" timeout="30">		
		</cfexecute>
		
	</cffunction>
</cfcomponent> 