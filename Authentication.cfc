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
<cfcomponent displayname="Authentication" output="false">
	
	<cffunction name="GetKey" returntype="string" output="no" access="remote">
		<cfargument name="username" type="string" hint="A valid Prefiniti account name">
		<cfargument name="password" type="string" hint="A valid Prefiniti account password">
		
		<cfset user_id = Authenticate(username, password)>
		
		<cfif user_id NEQ 0>
			<cfif UserHasKey(username)>
				<cfset ClearOldKeys(username)>
			</cfif>
			
			<cfreturn CreateKey(username, user_id)>			
		<cfelse>
			<cfreturn "0">			
		</cfif>
	</cffunction>
	
	<cffunction name="ValidateKey" returntype="boolean" output="no" access="remote">
		<cfargument name="username" type="string" hint="A valid Prefiniti account name">
		<cfargument name="key" type="string" hint="A valid Prefiniti authentication key">
		
		<cfquery name="vk" datasource="webwarecl">
			SELECT 	id
			FROM	auth_tokens
			WHERE	token='#key#'
			AND		username='#username#'
			AND		active=1
		</cfquery>
		
		<cfif vk.RecordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
		
	</cffunction>
	
	<cffunction name="Authenticate" returntype="numeric" output="no" access="public">
		<cfargument name="username" type="string" hint="A valid Prefiniti account name">
		<cfargument name="password" type="string" hint="A valid Prefiniti account password">
		
		<cfquery name="auth" datasource="webwarecl">
			SELECT 	id
			FROM 	users 
			WHERE 	username='#username#'
			AND		password='#Hash(password)#'
		</cfquery>
		
		<cfif auth.RecordCount GT 0>
			<cfreturn #auth.id#>
		<cfelse>
			<cfreturn 0>
		</cfif>
		
	</cffunction>
	
	<cffunction name="CreateKey" returntype="string" output="no" access="public">
		<cfargument name="username" type="string" hint="A valid Prefiniti account name">
		<cfargument name="id" type="numeric" hint="A valid Prefiniti account number">
				
		<cfset tok=CreateUUID()>
						
		<cfquery name="ck" datasource="webwarecl">
			INSERT INTO auth_tokens
				(username,
				token,
				user_id,
				login_date,
				active)
			VALUES
				('#username#',
				'#tok#',
				#id#,
				#CreateODBCDateTime(Now())#,
				1)
		</cfquery>
		
		<cfreturn #tok#>
	</cffunction>
	
	<cffunction name="UserHasKey" returntype="boolean" output="no" access="public">
		<cfargument name="username" type="string" required="true">
		
		<cfquery name="uhk" datasource="webwarecl">
			SELECT * FROM auth_tokens WHERE username='#username#' AND active=1
		</cfquery>
		
		<cfif uhk.RecordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="UserIDFromKey" returntype="numeric" output="no" access="remote">
		<cfargument name="key" type="string">
		 
		<cfquery name="uidfk" datasource="webwarecl">
			SELECT user_id FROM auth_tokens WHERE token='#key#'
		</cfquery>
		
		<cfreturn #uidfk.user_id#>
	</cffunction>
	
	<cffunction name="ClearOldKeys" returntype="void" output="no" access="public" hint="clear a users keys">
		<cfargument name="username" type="string" required="true">
		
		<cfquery name="cok" datasource="webwarecl">
			UPDATE 	auth_tokens
			SET		logout_date=#CreateODBCDateTime(Now())#,
					active=0
			WHERE	username='#username#'
            AND		active=1
		</cfquery>
	</cffunction>
    
    <cffunction name="Logout" returntype="void" output="no" access="remote">
    	<cfargument name="key" type="string">
        
        <cfquery name="qlogout" datasource="webwarecl">
        	UPDATE 	auth_tokens
            SET		logout_date=#CreateODBCDateTime(Now())#,
            		active=0
			WHERE   token='#key#'              
        </cfquery>
        
        <cfreturn>
    </cffunction>
	
</cfcomponent>