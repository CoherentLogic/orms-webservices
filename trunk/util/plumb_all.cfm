<cfquery name="plumb_all" datasource="webwarecl">
	SELECT id FROM orms
</cfquery>


<cfparam name="r" default="">

<cfoutput query="plumb_all">
	<cfset r = CreateObject("component", "fs.resource")>
	<cfset r.Get(id)>
	<cfset r.Plumb()>
	Plumbed (#r.r_owner#/#r.r_type#) #id#<br>

	<cfset barcode = CreateObject("component", "fs.output.barcode")>
	<cfset barcode.write(r)>
	
</cfoutput>
	