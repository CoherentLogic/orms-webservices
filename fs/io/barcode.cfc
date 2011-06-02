<!---

$Id$

Copyright (C) 2011 John Willis
 
This file is part of Prefiniti.

Prefiniti is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Prefiniti is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Prefiniti.  If not, see <http://www.gnu.org/licenses/>.

--->
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