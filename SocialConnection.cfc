
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

---><cfcomponent displayname="SocialConnection" output="false" hint="Web service for interfacing with friends">
	
    <cffunction name="GetFriends" hint="Retrieve an array containing usernames of all friends of 'username'" returntype="array" access="remote" output="no">
    	<cfargument name="username" type="string">
        
        <cfset uro = CreateObject("component", "UserResource")>
        <cfset uid = uro.UserIDFromUsername(username)>
        
       	<cfquery name="gf" datasource="webwarecl">
        	SELECT * FROM friends WHERE source_id=#uid#
        </cfquery>
        
        <cfset oa = ArrayNew(1)>
        
        <cfoutput query="gf">
        	<cfset ArrayAppend(oa, uro.UsernameFromUserID(target_id))>            
        </cfoutput>
        
        <cfreturn #oa#>
    </cffunction>
    
    <cffunction name="GetFriendCount" hint="Retrieve a friend count" returntype="numeric" access="remote" output="no">
    	<cfargument name="username" type="string">
        
        <cfset uro = CreateObject("component", "UserResource")>
        <cfset uid = uro.UserIDFromUsername(username)>
        
       	<cfquery name="gf" datasource="webwarecl">
        	SELECT id FROM friends WHERE source_id=#uid#
        </cfquery>             
        
        <cfreturn #gf.RecordCount#>
    </cffunction>
    
    <cffunction name="GetLocation" hint="Retrieve a user's online location" returntype="string" access="remote" output="no">
    	<cfargument name="username" type="string">
                
        <cfquery name="gl" datasource="webwarecl">
        	SELECT location FROM users WHERE username='#username#'
        </cfquery>
        
        <cfreturn #gl.location#>        
    </cffunction>

    <cffunction name="GetLocationURL" hint="Retrieve a user's online location URL" returntype="string" access="remote" output="no">
    	<cfargument name="username" type="string">
                
        <cfquery name="glu" datasource="webwarecl">
        	SELECT location_url FROM users WHERE username='#username#'
        </cfquery>
        
        <cfreturn #glu.location_url#>        
    </cffunction>
    
    <cffunction name="SetLocation" hint="Set a user's online location" returntype="void" access="remote" output="no">
    	<cfargument name="username" type="string">
    	<cfargument name="location" type="string">
        <cfargument name="activity" type="string">
                
        <cfquery name="sl" datasource="webwarecl">
        	UPDATE 	users
            SET 	location='#location#',
            		status='#activity#'
            WHERE 	username='#username#'
        </cfquery>
        
        <cfreturn>        
    </cffunction>

    <cffunction name="SetLocationURL" hint="Set a user's online location URL" returntype="void" access="remote" output="no">
    	<cfargument name="username" type="string">
    	<cfargument name="location_url" type="string">
                
        <cfquery name="slu" datasource="webwarecl">
        	UPDATE 	users
            SET 	location_url='#location_url#'
            WHERE 	username='#username#'
        </cfquery>
        
        <cfreturn>        
    </cffunction>
    
    <cffunction name="GetActivity" hint="Retrieve a user's online location" returntype="string" access="remote" output="no">
    	<cfargument name="username" type="string">
                
        <cfquery name="ga" datasource="webwarecl">
        	SELECT status FROM users WHERE username='#username#'
        </cfquery>
        
        <cfreturn #ga.status#>        
    </cffunction>
</cfcomponent>